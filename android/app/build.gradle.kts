plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

repositories {
    google()
    mavenCentral()
}

dependencies {
    // Firebase BOM version — stable and working (you can later update this to 33.15.0)
    implementation(platform("com.google.firebase:firebase-bom:33.0.0"))

    // Example Firebase libraries (add/remove based on what you use)
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
}

android {
    namespace = "com.example.atl_membership"
    compileSdk = 35 // Or flutter.compileSdkVersion, but specifying works well too
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.atl_membership"
        minSdk = 24
        targetSdk = 34 // Or flutter.targetSdkVersion
        versionCode = 1 // Update as needed
        versionName = "1.0.0"
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
