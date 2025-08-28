// BEGIN app_build_gradle_full_replace
// Purpose: Fix NDK mismatch + minSdk error; modern Flutter + Firebase compatible.

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin (required by recent Flutter templates)
    id("dev.flutter.flutter-gradle-plugin")
    // Google services plugin to process google-services.json
    id("com.google.gms.google-services")
}

android {
    // TODO: REPLACE with your actual package/namespace (e.g., "com.knls.lsp1")
    namespace = "REPLACE_WITH_YOUR_NAMESPACE"

    // Match your installed SDK
    compileSdk = 34

    // Pin NDK required by firebase_* and google_sign_in
    ndkVersion = "27.0.12077973"

    defaultConfig {
        // TODO: REPLACE with your actual applicationId (usually same as namespace)
        applicationId = "REPLACE_WITH_YOUR_APPLICATION_ID"

        // Firebase Auth 23.x requires minSdk >= 23
        minSdk = 23
        targetSdk = 34

        // Versioning can be driven by Flutter; if you manage here, keep these:
        // versionCode = 1
        // versionName = "1.0"
    }

    buildTypes {
        release {
            // Keep minify off initially; enable R8 later as needed
            isMinifyEnabled = false
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
        debug {
            // You can add debug config here if needed
        }
    }

    // Ensure Java/Kotlin 17 for modern Android/AGP combos
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    // Packaging tweaks if you later hit duplicate native libs (not needed now)
    // packaging {
    //     jniLibs {
    //         useLegacyPackaging = false
    //     }
    // }
}

// Flutter plugin configuration
flutter {
    source = "../.."
}

// Dependencies: usually managed by Flutter; keep empty here unless you add Android-only libs.
dependencies {
    // (No direct dependencies required here for Firebase Auth/Core/GoogleSignIn;
    // they come via Flutter plugins + pubspec.)
}
// END app_build_gradle_full_replace
