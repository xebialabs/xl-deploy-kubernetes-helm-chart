import org.gradle.kotlin.dsl.apply
import org.gradle.kotlin.dsl.plugin

apply(plugin = "maven-publish")

tasks {
    register("uploadArchives") {
        group = "upload"
        dependsOn(tasks.named("publish"))
    }
    register("uploadArchivesMavenRepository") {
        group = "upload"
        dependsOn(tasks.named("publishAllPublicationsToMavenRepository"))
    }
    register("uploadArchivesToMavenLocal") {
        group = "upload"
        dependsOn(tasks.named("publishToMavenLocal"))
    }
}
