plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.school_management_system.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // 1. Enable Core Library Desugaring
        isCoreLibraryDesugaringEnabled = true

        // Ensure these match your current Java 17 setting
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
        freeCompilerArgs += listOf("-Xskip-prerelease-check")
    }

    defaultConfig {
        applicationId = "com.school_management_system.app"
        minSdk = flutter.minSdkVersion // Local notifications usually require at least 21 for full support
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 2. Enable MultiDex
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // Minification reduces APK size but requires the proguard-rules.pro file
            isMinifyEnabled = true
            isShrinkResources = true

            // Correct way to reference the ProGuard file in Kotlin DSL
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 3. Add the desugar library here
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
