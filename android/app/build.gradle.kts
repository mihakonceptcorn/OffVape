import java.util.Properties

val buildTypeName = gradle.startParameter.taskNames
    .joinToString(" ")
    .lowercase()

val envFile = when {
    buildTypeName.contains("release") -> rootProject.file("../.env.production")
    else -> rootProject.file("../.env.development")
}

val envProps = Properties()
if (envFile.exists()) envFile.reader().use { envProps.load(it) }

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.off_vape"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    defaultConfig {
        applicationId = "com.offvape.app"
        manifestPlaceholders["ADMOB_APP_ID"] = envProps["ADMOB_APP_ID"] ?: ""
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
