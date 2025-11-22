plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.rafaelamorim.mapamvs"
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
        applicationId = "br.com.rafaelamorim.mapamvs"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        release {
            storeFile file("key.jks")
            storePassword "SENHA_DO_KEYSTORE"
            keyAlias "ALIAS_DA_CHAVE"
            keyPassword "SENHA_DA_CHAVE"
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            shrinkResources false
            minifyEnabled false
        }
    }
}

flutter {
    source = "../.."
}
