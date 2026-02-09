allprojects {
    repositories {
        google()
        mavenCentral()
    }
    configurations.all {
        resolutionStrategy {
            eachDependency {
                if (requested.group == "com.android.ndk" && requested.name.startsWith("ndk")) {
                    useVersion("27.1.12297006")
                }
            }
        }
    }
}
allprojects {
    gradle.projectsEvaluated {
        tasks.withType<JavaCompile> {
            options.compilerArgs.add("-Xlint:unchecked")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 强制所有插件项目使用 SDK 36
subprojects {
    afterEvaluate {
        if (project.name != "app") {
            plugins.withId("com.android.library") {
                configure<com.android.build.gradle.LibraryExtension> {
                    compileSdk = 36
                    defaultConfig {
                        minSdk = 21
                    }
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
