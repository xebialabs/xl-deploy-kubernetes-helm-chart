import com.github.gradle.node.yarn.task.YarnTask
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.io.ByteArrayOutputStream

buildscript {
    repositories {
        mavenLocal()
        gradlePluginPortal()
        arrayOf("releases", "public").forEach { r ->
            maven {
                url = uri("${project.property("nexusBaseUrl")}/repositories/${r}")
                credentials {
                    username = project.property("nexusUserName").toString()
                    password = project.property("nexusPassword").toString()
                }
            }
        }
    }

    dependencies {
        classpath("com.xebialabs.gradle.plugins:gradle-commit:${properties["gradleCommitPluginVersion"]}")
        classpath("com.xebialabs.gradle.plugins:gradle-xl-defaults-plugin:${properties["xlDefaultsPluginVersion"]}")
    }
}

plugins {
    kotlin("jvm") version "1.4.20"

    id("com.github.node-gradle.node") version "3.1.0"
    id("idea")
    id("nebula.release") version "15.3.1"
    id("maven-publish")
}

apply(plugin = "ai.digital.gradle-commit")

group = "ai.digital.deploy.helm"
project.defaultTasks = listOf("build")

val dockerHubRepository = System.getenv()["DOCKER_HUB_REPOSITORY"] ?: "xebialabsunsupported"
val releaseExplicitEnv = System.getenv()["RELEASE_EXPLICIT"]
val releasedVersion = releaseExplicitEnv ?: "22.0.0-${
    LocalDateTime.now().format(DateTimeFormatter.ofPattern("Mdd.Hmm"))
}"
project.extra.set("releasedVersion", releasedVersion)

repositories {
    mavenLocal()
    gradlePluginPortal()
    maven {
        url = uri("https://plugins.gradle.org/m2/")
    }
}

idea {
    module {
        setDownloadJavadoc(true)
        setDownloadSources(true)
    }
}

dependencies {
    implementation(gradleApi())
    implementation(gradleKotlinDsl())

}

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
    withSourcesJar()
    withJavadocJar()
}

tasks.named<Test>("test") {
    useJUnitPlatform()
}

tasks.withType<AbstractPublishToMaven> {
    dependsOn("buildHelmPackage")
}

tasks {

    val buildXldDir = layout.buildDirectory.dir("xld")
    val buildXldOperatorDir = layout.buildDirectory.dir("xld/${project.name}")

    register("dumpVersion") {
        doLast {
            file(buildDir).mkdirs()
            file("$buildDir/version.dump").writeText("version=${releasedVersion}")
        }
    }

    named<YarnTask>("yarn_install") {
        args.set(listOf("--mutex", "network"))
        workingDir.set(file("${rootDir}/documentation"))
    }

    register<YarnTask>("yarnRunStart") {
        dependsOn(named("yarn_install"))
        args.set(listOf("run", "start"))
        workingDir.set(file("${rootDir}/documentation"))
    }

    register<YarnTask>("yarnRunBuild") {
        dependsOn(named("yarn_install"))
        args.set(listOf("run", "build"))
        workingDir.set(file("${rootDir}/documentation"))
    }

    register<Delete>("docCleanUp") {
        delete(file("${rootDir}/docs"))
        delete(file("${rootDir}/documentation/build"))
        delete(file("${rootDir}/documentation/.docusaurus"))
        delete(file("${rootDir}/documentation/node_modules"))
    }

    register<Copy>("docBuild") {
        dependsOn(named("yarnRunBuild"), named("docCleanUp"))
        from(file("${rootDir}/documentation/build"))
        into(file("${rootDir}/docs"))
    }

    register<GenerateDocumentation>("updateDocs") {
        dependsOn(named("docBuild"))
    }

    register<NebulaRelease>("nebulaRelease") {
        dependsOn(named("updateDocs"))
    }

    compileKotlin {
        kotlinOptions.jvmTarget = JavaVersion.VERSION_11.toString()
    }

    compileTestKotlin {
        kotlinOptions.jvmTarget = JavaVersion.VERSION_11.toString()
    }

    register<Copy>("prepareHelmPackage") {
        dependsOn("dumpVersion")
        from(layout.projectDirectory)
        exclude(
            layout.buildDirectory.get().asFile.name,
            "buildSrc/",
            "docs/",
            "documentation/",
            "gradle/",
            "*gradle*",
            ".*/",
            "*.iml",
            "*.sh"
        )
        into(buildXldOperatorDir)
    }

    register<Exec>("prepareHelmDeps") {
        dependsOn("prepareHelmPackage")
        workingDir(buildXldOperatorDir)
        commandLine("helm", "dependency", "update", ".")

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            exec {
                workingDir(buildXldOperatorDir)
                commandLine("rm", "-f", "Chart.lock")
            }
        }
        doLast {
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Prepare helm deps finished")
        }
    }

    register<Exec>("buildHelmPackage") {
        dependsOn("prepareHelmDeps")
        workingDir(buildXldDir)
        commandLine("helm", "package", "--app-version=${releasedVersion}", project.name)

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            copy {
                from(buildXldDir)
                include("*.tgz")
                into(buildXldDir)
                rename("digitalai-deploy-.*.tgz", "xld.tgz")
            }
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Helm package finished created ${buildDir}/xld/xld.tgz")
        }
    }

    register<Exec>("prepareOperatorImage") {
        dependsOn("buildHelmPackage")
        workingDir(buildXldDir)
        commandLine("operator-sdk", "init", "--domain=digital.ai", "--plugins=helm")

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Init operator image finished")
        }
    }

    register<Exec>("buildOperatorImage") {
        dependsOn("prepareOperatorImage")
        workingDir(buildXldDir)
        commandLine("operator-sdk", "create", "api", "--group=xldocp", "--version=v1alpha1", "--helm-chart=xld.tgz")

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Create operator image finished")
        }
    }

    register<Exec>("publishToDockerHub") {
        dependsOn("buildOperatorImage")
        workingDir(buildXldDir)
        val imageUrl = "docker.io/$dockerHubRepository/deploy-operator:$releasedVersion"
        commandLine("make", "docker-build", "docker-push", "IMG=$imageUrl")

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Publish to DockerHub $imageUrl finished")
        }
    }

    register("checkDependencyVersions") {
        // a placeholder to unify with release in jenkins-job
    }
}

publishing {
    publications {
        register("digitalai-deploy-helm", MavenPublication::class) {
            artifact("${buildDir}/xld/xld.tgz") {
                artifactId = "deploy-helm-openshift"
                version = releasedVersion
            }
        }
    }

    repositories {
        maven {
            url = uri("${project.property("nexusBaseUrl")}/repositories/releases")
            credentials {
                username = project.property("nexusUserName").toString()
                password = project.property("nexusPassword").toString()
            }
        }
    }
}

node {
    version.set("14.17.5")
    yarnVersion.set("1.22.11")
    download.set(true)
}
