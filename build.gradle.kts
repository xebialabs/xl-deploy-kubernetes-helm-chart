import com.github.gradle.node.yarn.task.YarnTask
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import org.jetbrains.kotlin.de.undercouch.gradle.tasks.download.Download
import java.io.ByteArrayOutputStream
import java.util.*
import org.apache.commons.lang.SystemUtils.*

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
        classpath("com.xebialabs.gradle.plugins:gradle-xl-plugins-plugin:${properties["xlPluginsPluginVersion"]}")
        classpath("com.xebialabs.gradle.plugins:integration-server-gradle-plugin:${properties["integrationServerGradlePluginVersion"]}")
    }
}

plugins {
    kotlin("jvm") version "1.8.10"

    id("com.github.node-gradle.node") version "4.0.0"
    id("idea")
    id("nebula.release") version (properties["nebulaReleasePluginVersion"] as String)
    id("maven-publish")
}

apply(plugin = "ai.digital.gradle-commit")
apply(plugin = "integration.server")
apply(plugin = "com.xebialabs.dependency")

group = "ai.digital.deploy.helm"
project.defaultTasks = listOf("build")

val helmVersion = properties["helmVersion"]
val operatorSdkVersion = properties["operatorSdkVersion"]
val os = detectOs()
val arch = detectHostArch()
val dockerHubRepository = System.getenv()["DOCKER_HUB_REPOSITORY"] ?: "xebialabsunsupported"
val releasedVersion = System.getenv()["RELEASE_EXPLICIT"] ?: "23.3.0-${
    LocalDateTime.now().format(DateTimeFormatter.ofPattern("Mdd.Hmm"))
}"
project.extra.set("releasedVersion", releasedVersion)

enum class Os {
    DARWIN {
        override fun toString(): String = "darwin"
    },
    LINUX {
        override fun toString(): String = "linux"
    },
    WINDOWS {
        override fun packaging(): String = "zip"
        override fun toString(): String = "windows"
    };
    open fun packaging(): String = "tar.gz"
    fun toStringCamelCase(): String = toString().replaceFirstChar { it.uppercaseChar() }
}

enum class Arch {
    AMD64 {
        override fun toString(): String = "amd64"
    },
    ARM64 {
        override fun toString(): String = "arm64"
    };

    fun toStringCamelCase(): String = toString().replaceFirstChar { it.uppercaseChar() }
}

allprojects {
    repositories {
        mavenLocal()
        mavenCentral()
        arrayOf("releases", "public", "thirdparty").forEach { r ->
            maven {
                url = uri("${project.property("nexusBaseUrl")}/repositories/${r}")
                credentials {
                    username = project.property("nexusUserName").toString()
                    password = project.property("nexusPassword").toString()
                }
            }
        }
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

    compileKotlin {
        kotlinOptions.jvmTarget = JavaVersion.VERSION_11.toString()
    }

    compileTestKotlin {
        kotlinOptions.jvmTarget = JavaVersion.VERSION_11.toString()
    }

    val buildXldDir = layout.buildDirectory.dir("xld")
    val buildXldOperatorDir = layout.buildDirectory.dir("xld/${project.name}")
    val helmDir = layout.buildDirectory.dir("helm").get()
    val helmCli = helmDir.dir("$os-$arch").file("helm")
    val operatorSdkDir = layout.buildDirectory.dir("operatorSdk").get()
    val operatorSdkCli = operatorSdkDir.file("operator-sdk")

    register<Download>("downloadHelm") {
        group = "helm"
        src("https://get.helm.sh/helm-v$helmVersion-$os-$arch.tar.gz")
        dest(helmDir.file("helm.tar.gz").getAsFile())
    }
    register<Copy>("unzipHelm") {
        group = "helm"
        dependsOn("downloadHelm")
        doNotTrackState("")
        from(tarTree(helmDir.file("helm.tar.gz")))
        into(helmDir)
        fileMode = 0b111101101
    }

    register<Download>("downloadOperatorSdk") {
        group = "operatorSdk"
        src("https://github.com/operator-framework/operator-sdk/releases/download/v$operatorSdkVersion/operator-sdk_${os}_$arch")
        dest(operatorSdkDir.dir("operator-sdk-tool").file("operator-sdk").getAsFile())
    }
    register<Copy>("unzipOperatorSdk") {
        group = "helm"
        dependsOn("downloadOperatorSdk")
        doNotTrackState("")
        from(operatorSdkDir.dir("operator-sdk-tool").file("operator-sdk"))
        into(operatorSdkDir)
        fileMode = 0b111101101
    }

    register<Copy>("prepareHelmPackage") {
        group = "helm"
        dependsOn("dumpVersion", "unzipHelm", ":integration-tests:core:jar")
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
        doFirst {
            delete(buildXldDir)
        }
    }

    register<Copy>("prepareValuesYaml") {
        group = "helm"
        dependsOn("prepareHelmPackage")
        from(buildXldOperatorDir)
        include("values-nginx.yaml")
        into(buildXldOperatorDir)
        rename("values-nginx.yaml", "values.yaml")
        doLast {
            exec {
                workingDir(buildXldOperatorDir)
                commandLine("rm", "-f", "values-haproxy.yaml")
            }
            exec {
                workingDir(buildXldOperatorDir)
                commandLine("rm", "-f", "values-nginx.yaml")
            }
        }
    }

    register<Exec>("prepareHelmDeps") {
        group = "helm"
        dependsOn("prepareValuesYaml")
        workingDir(buildXldOperatorDir)
        commandLine(helmCli, "dependency", "update", ".")

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
        group = "helm"
        dependsOn("prepareHelmDeps")
        workingDir(buildXldDir)
        commandLine(helmCli, "package", "--app-version=$releasedVersion", project.name)

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            copy {
                from(buildXldDir)
                include("*.tgz")
                into(buildXldDir)
                rename("digitalai-deploy-.*.tgz", "xld.tgz")
                duplicatesStrategy = DuplicatesStrategy.WARN
            }
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Helm package finished created ${buildDir}/xld/xld.tgz")
        }
    }

    register<Exec>("prepareOperatorImage") {
        group = "operator"
        dependsOn("buildHelmPackage", "unzipOperatorSdk")
        workingDir(buildXldDir)
        commandLine(operatorSdkCli, "init", "--domain=digital.ai", "--plugins=helm")

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Init operator image finished")
        }
    }

    register<Exec>("buildReadme") {
        group = "readme"
        workingDir(layout.projectDirectory)
        commandLine("readme-generator-for-helm", "--readme", "README.md", "--values", "values.yaml")

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Update README.md finished")
        }
    }

    register<Exec>("buildOperatorImage") {
        group = "operator"
        dependsOn("prepareOperatorImage", "buildReadme")
        workingDir(buildXldDir)
        commandLine(operatorSdkCli, "create", "api", "--group=xld", "--version=v1alpha1", "--helm-chart=xld.tgz")

        standardOutput = ByteArrayOutputStream()
        errorOutput = ByteArrayOutputStream()

        doLast {
            logger.lifecycle(standardOutput.toString())
            logger.error(errorOutput.toString())
            logger.lifecycle("Create operator image finished")
        }
    }

    register<Exec>("publishToDockerHub") {
        group = "operator"
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

    register("uploadArchives") {
        group = "upload"
        dependsOn("dumpVersion", "publish")
    }
    register("uploadArchivesMavenRepository") {
        group = "upload"
        dependsOn("dumpVersion","publishAllPublicationsToMavenRepository")
    }
    register("uploadArchivesToMavenLocal") {
        group = "upload"
        dependsOn("dumpVersion", "publishToMavenLocal")
    }

    register("dumpVersion") {
        group = "release"
        doLast {
            file(buildDir).mkdirs()
            file("$buildDir/version.dump").writeText("version=${releasedVersion}")
        }
    }

    register<NebulaRelease>("nebulaRelease") {
        group = "release"
        dependsOn(named("updateDocs"))
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
}

tasks.withType<AbstractPublishToMaven> {
    dependsOn("buildHelmPackage")
}

tasks.named("build") {
    dependsOn("buildOperatorImage")
}

publishing {
    publications {
        register("digitalai-deploy-helm", MavenPublication::class) {
            artifact("${buildDir}/xld/xld.tgz") {
                artifactId = "deploy-helm"
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

fun detectOs(): Os {

    val osDetectionMap = mapOf(
        Pair(Os.LINUX, IS_OS_LINUX),
        Pair(Os.WINDOWS, IS_OS_WINDOWS),
        Pair(Os.DARWIN, IS_OS_MAC_OSX),
    )

    return osDetectionMap
        .filter { it.value }
        .firstNotNullOfOrNull { it.key } ?: throw IllegalStateException("Unrecognized os")
}

fun detectHostArch(): Arch {

    val archDetectionMap = mapOf(
        Pair("x86_64", Arch.AMD64),
        Pair("x64", Arch.AMD64),
        Pair("amd64", Arch.AMD64),
        Pair("aarch64", Arch.ARM64),
        Pair("arm64", Arch.ARM64),
    )

    val arch: String = System.getProperty("os.arch")
    if (archDetectionMap.containsKey(arch)) {
        return archDetectionMap[arch]!!
    }
    throw IllegalStateException("Unrecognized architecture: $arch")
}
