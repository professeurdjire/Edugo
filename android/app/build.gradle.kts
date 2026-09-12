plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.edugo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.edugo"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // flutter_secure_storage exige Android 6.0 (API 23) minimum
        minSdk = maxOf(23, flutter.minSdkVersion)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Clé de release persistante fournie par la CI (secrets
        // EDUGO_KEYSTORE_*) : indispensable pour que les mises à jour
        // s'installent par-dessus les builds précédents.
        val cheminKeystore = System.getenv("EDUGO_KEYSTORE_PATH")
        if (!cheminKeystore.isNullOrBlank()) {
            create("release") {
                storeFile = file(cheminKeystore)
                storePassword = System.getenv("EDUGO_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("EDUGO_KEY_ALIAS")
                keyPassword = System.getenv("EDUGO_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            // Clé de release si fournie, sinon signature de débogage
            // (développement local et CI sans secrets).
            signingConfig = signingConfigs.findByName("release")
                ?: signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
