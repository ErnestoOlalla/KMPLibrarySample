pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
    }
}
plugins {
    id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/ErnestoOlalla/KMPLibrarySample")
            credentials {
                val localProps = java.util.Properties().also { props ->
                    val f = File(rootDir, "local.properties")
                    if (f.exists()) props.load(f.inputStream())
                }
                username = localProps.getProperty("gpr.user")
                    ?: providers.gradleProperty("gpr.user").orElse("").get()
                password = localProps.getProperty("gpr.token")
                    ?: providers.gradleProperty("gpr.token").orElse("").get()
            }
        }
    }
}

rootProject.name = "KMPLibraryTest"
include(":app")
 