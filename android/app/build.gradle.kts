plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.myapp" // Namespace do aplicativo
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Versão NDK específica

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.example.myapp" // ID do aplicativo
        minSdk = 23 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Linhas para image_cropper:
        vectorDrawables.useSupportLibrary = true
        multiDexEnabled = true // MultiDex ativado

        // Chave API Google Maps
        resValue("string", "Maps_api_key", (project.findProperty("MAPS_API_KEY") as String? ?: ""))

    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // DEPENDÊNCIA PARA MULTIDEX
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
