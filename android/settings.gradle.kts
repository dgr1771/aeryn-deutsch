pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")

// 为所有项目提供 flutter 扩展配置
gradle.beforeProject {
    val flutterExt = project.extensions.findByType(
        groovy.lang.GroovyObject::class.java
    )?.properties?.get("flutter")

    // 如果 flutter 扩展不存在，创建一个简单的
    if (flutterExt == null) {
        project.extensions.add("flutter", object {
            val compileSdkVersion = 36
            val minSdkVersion = 21
            val targetSdkVersion = 36
        })
    }
}
