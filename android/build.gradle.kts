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

// 为所有子项目提供 Flutter 扩展对象
gradle.beforeProject {
    // 创建 flutter 扩展，供插件使用
    project.extensions.create("flutter", FlutterExtension::class.java)
}

// Flutter 扩展类定义
open class FlutterExtension {
    val compileSdkVersion: Int = 36
    val minSdkVersion: Int = 21
    val targetSdkVersion: Int = 36
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android")
            if (android is com.android.build.gradle.LibraryExtension) {
                android.compileSdk = 36
                android.defaultConfig {
                    minSdk = 21
                    targetSdk = 36
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
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
