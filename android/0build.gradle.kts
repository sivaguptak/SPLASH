plugins {
    id("com.android.application")
    id("kotlin-android")
    // IMPORTANT: Apply Google Services plugin at the app module
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.locsy" // <-- mee package id
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.locsy" // <-- Firebase package_name match ayye vidhamga
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        // If method count grows
        multiDexEnabled = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // optional: debug configs
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    // Use Firebase BOM to manage versions
    implementation(platform("com.google.firebase:firebase-bom:33.3.0"))

    // Firebase Auth (required for Phone Auth)
    implementation("com.google.firebase:firebase-auth")

    // If you use Google Sign-In
    implementation("com.google.android.gms:play-services-auth:21.1.1")

    // Optional: for large projects
    implementation("androidx.multidex:multidex:2.0.1")
}
