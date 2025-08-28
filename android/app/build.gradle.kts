// BEGIN read_versions_from_local_properties
import java.util.Properties

val localProps = Properties().apply {
    val f = rootProject.file("local.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
val flutterVersionCode = (localProps.getProperty("flutter.versionCode") ?: "1").toInt()
val flutterVersionName = localProps.getProperty("flutter.versionName") ?: "1.0"
// END read_versions_from_local_properties


// BEGIN app_build_gradle_full_replace
// Purpose: Clean Flutter + Firebase setup for app module
// - compileSdk / targetSdk = 35 (required by google_sign_in_android)
// - minSdk = 23 (required by firebase-auth 23.x)
// - NDK = 27.0.12077973 (matches Firebase plugins request)
// - Resource shrink OFF while minify is OFF
// - Google Services plugin applied (remember to add google-services.json)

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Keep if your project uses modern Flutter Gradle plugin
    id("dev.flutter.flutter-gradle-plugin")
    // Needed to process google-services.json
    id("com.google.gms.google-services")
}

android {
    // Matches your MainActivity package
    namespace = "com.example.locsy_skeleton"

    // Android SDKs
    compileSdk = 35

    // Match installed NDK (exact folder name)
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.locsy_skeleton"
        minSdk = 23
        targetSdk = 35

        // ADD THESE:
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            // Keep code shrink OFF for now
            isMinifyEnabled = false
            // Resource shrink must be OFF when minify is OFF
            isShrinkResources = false
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
        debug {
            // Debug should not shrink either
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // Java/Kotlin 17 for AGP 8.x compatibility
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

// Standard Flutter config
flutter {
    source = "../.."
}

// Android-only deps (usually empty; Flutter pulls from pubspec)
dependencies {
    // intentionally empty
}
// END app_build_gradle_full_replace
