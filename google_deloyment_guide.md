# Mood Tracker App - Google Play Store Deployment Guide

This guide outlines the complete process for deploying the Mood Tracker app to the Google Play Store.

## Prerequisites

- Flutter SDK installed and configured
- Android Studio with Android SDK
- Google Play Console developer account
- Physical Android device for testing

---

## Step 1: Generate Release Keystore

The first step is to create a keystore file for signing your release build. This ensures the authenticity of your app.

### Command Used:

```bash
keytool -genkey -v -keystore upload_mood.jks -alias captured_heart -keyalg RSA -keysize 2048 -validity 10000
```

### Important Notes:

- I Store the keystore file (`upload_mood.jks`) locally (not checked to git), as it contains sensitive information for updating the app and shouldn't be available to the public
- The keystore file is located at: `/android/upload_mood.jks`

---

## Step 2: I Configured the Key Properties file

I created a `key.properties` file in the `android/` directory to store keystore configuration securely.

### File Location: `android/key.properties`

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=captured_heart
storeFile=/Users/capturedheart/Dev_Main/mood_tracker_assessment/android/upload_mood.jks
```

### Security Note:

-  `key.properties` was added to `.gitignore` because is a sensitive information just as the .jks file

---

## Step 3: Configure Build.gradle for Release

Updated `android/app/build.gradle.kts` to use the release keystore for signing.

### Key Changes Made:

1. **Added keystore properties loading:**

```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

2. **Updated application ID to unique identifier:**

```kotlin
applicationId = "com.capturedHeart.moodTracker"
namespace = "com.capturedHeart.moodTracker"
```

3. **Added release signing configuration:**

```kotlin
signingConfigs {
    create("release") {
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
    }
}
```

4. **Updated build types to use release signing:**

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

---

## Step 4: Update App Metadata in pubspec.yaml

I updated the app metadata for production release:

### Changes Made:

```yaml
name: mood_tracker_assessment
description: "Marcel created this Mood Tracker app for a technical assessment"
version: 0.0.3+3 # version_name+build_number
```

---

## Step 5: Update Application Bundle ID

Changed the bundle identifier to ensure uniqueness across the Play Store:

**Bundle ID:** `com.capturedHeart.moodTracker`


---

## Step 6: Create and Replace App Icons

### Icon Locations:

- `android/app/src/main/res/mipmap-*/ic_launcher.png`
- Custom icons stored in: `assets/images/png/app_logo.png`

---

## Step 7: Build and Test Release Version

Before uploading to Play Console, thoroughly test the release build:

### Build Commands:

```bash
# Clean previous builds
flutter clean 
# Get dependencies
flutter pub get
# Test release build on connected device
flutter run --release
# Build App Bundle (for Play Store upload)
flutter build appbundle --release
```

### My Checklist after i ran app on a physical device in release mode:

- App launches without crashes
-  All features work correctly
-  Performance is acceptable
-  Network requests work properly
-  Local storage functions correctly
-  UI looks correct on different mobile screen sizes

### Generated Files For Release:

- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`

---

## Step 8: Google Play Console Setup

### 8.1 Create New App

1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app"
3. Fill in app details:
   - **App name**: Mood Tracker Assessment
   - **Default language**: English (United States)
   - **App or game**: App
   - **Free or paid**: Free

### 8.2 Complete App Information
i didn't have to complete the app information for internal testing

---

## Step 9: Upload App Bundle

### 9.1 Create Internal Testing Release

1. Navigate to "Testing" → "Internal testing"
2. Clicked on "Create new release", and uploaded both the "aab" & "debug-symbol"(For crash reports) file
3. then i proceeded to adding "Release notes" and completed the process


### 9.4 Set Up Test Users

1. For test users, i created a google form to collect the email addresses and will upload CSV format of doc to invite users

---

## Step 10: Release Management

### Version Control:

- Keep track of version numbers in `pubspec.yaml`
- Each update must have a higher build number
- Tag releases in Git for version control

### Future Updates:

1. Increment version in `pubspec.yaml`
2. Build new app bundle
3. Upload to Play Console
4. Add release notes describing changes
5. Roll out to testing tracks before production

---


## Current Status

✅ **Completed Steps:**

- Release keystore generated and configured
- App bundle ID updated to unique identifier
- App metadata updated in pubspec.yaml
- Release build configuration completed
- App icons created and integrated
- Release build tested on physical device
- Google Play Console app created
- App bundle uploaded to Internal Testing
- Release notes added
- App ready for internal testing

🔄 **Next Steps:**

- Internal testing with team members
- Address any feedback from internal testing
- Complete remaining Play Console requirements
- Submit for review and production release

---
