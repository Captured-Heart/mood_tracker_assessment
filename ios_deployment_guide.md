# Mood Tracker App - App Store Deployment Guide

This guide outlines the complete process for deploying the Mood Tracker app to the Apple App Store.

## Prerequisites

- **macOS with Xcode**: Latest version of Xcode installed
- **Apple Developer Account**: Active paid Apple Developer Program membership ($99/year)
- **Flutter SDK**: Installed and configured for iOS development
- **Physical iOS Device**: For testing (recommended)
- **Transporter App**: Apple's official app for uploading to App Store Connect
- **Valid Apple ID**: Associated with your developer account
- **Code Signing Certificates**: Properly configured in Xcode/Keychain

---

## Step 1: Apple Developer Portal Setup

### 1.1 Create App Identifier

1. I open the [Apple Developer Portal](https://developer.apple.com/account/)
2. Navigated to "Certificates, Identifiers & Profiles" & created a new identifier for this project
3. Fill in the details:
   - **Bundle ID**: `com.capturedHeart.moodTracker` (Explicit)
   - **App Services**: Select required capabilities (In my case, there was no special capabilities to set, the app is basic)

### Important Notes:

- Bundle ID must match exactly with your Xcode project configuration
- Cannot be changed after first App Store submission
- Must be unique across the entire App Store

---

## Step 2: App Store Connect Setup

### 2.1 Create New App

1. I open the [App Store Connect website](https://appstoreconnect.apple.com/)
2. Created a "New App"
3. And finally completed the required information:
   - **Platforms**: iOS
   - **Name**: Mood Tracker (Cordelia)
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: Select `com.capturedHeart.moodTracker`
   - **SKU**: Unique identifier

### 2.2 App Information Setup

I didn't have to set app information for Internal testingon TestFlight

---

## Step 3: Xcode Project Configuration

### 3.1 Bundle Identifier Configuration

I ensured the bundle identifier matches across all configurations:

**Current Configuration:**

- **Bundle Identifier**: `com.capturedHeart.moodTracker`
- **Display Name**: `Mood Tracker (Cordelia)`
- **Bundle Name**: `Mood Tracker (Cordelia)`
- **Version Number**: i set the version and build number 0.0.2+2

### 3.3 Device Orientation Settings

Configured supported orientations in `Info.plist`:

```xml
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationPortraitUpsideDown</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
```

### 3.4 App Display Name

Set in `Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>Mood Tracker (Cordelia)</string>
<key>CFBundleName</key>
<string>Mood Tracker (Cordelia)</string>
```

---

## Step 4: Code Signing and Certificates

### 4.1 Automatic Code Signing (Recommended)

1. Open Xcode project: `ios/Runner.xcworkspace` and on the "Runner" target
2. I went to "Signing & Capabilities" tab and checked "Automatically manage signing", and also selected my development team
3. Finally, i ensured the bundle identifier matches: `com.capturedHeart.moodTracker`

---

## Step 5: App Icons and Assets

### 5.1 App Icon Requirements

I made use of [Icon Kitchen](https://icon.kitchen/) on the web to generate AppIcon for both Android and iOS

---

## Step 6: Build Process

### 6.1 Clean and Build IPA

Execute the following commands in sequence:

```bash
# Clean all previous builds
flutter clean
# Install/update all dependencies
flutter pub get
# Build IPA for distribution
flutter build ipa
```

### Build Process Details:

- **Build Location**: `build/ios/archive/Runner.xcarchive`
- **IPA Location**: `build/ios/ipa/mood_tracker_assessment.ipa`

---

## Step 7: App Distribution Using Transporter

### 7.1 Using the Transporter App
1. I signed in my Apple account and follow the steps to upload the IPA file. 
2. Clicked on "Verify" after uploading to Transporter, and when the verification passed, i finalize the proocess by clicking on "Deliver"

---

## Step 8: App Store Connect Final Steps

### 8.1 Build Processing

After successful upload via Transporter:

1. I go to [App Store Connect](https://appstoreconnect.apple.com/),I navigated to "TestFlight" and confirmed the build was successful delivered from Transporter. 
**Note**: The build processing (can take up to 30 minutes - 2 hours)

2. The build will appear under "iOS Builds"

### 8.2 TestFlight Internal Testing 

1. I wil add internal testers basedon requests



---


## Current Deployment Status

✅ **Completed Steps:**

- Apple Developer Portal app identifier created
- App Store Connect app created and configured
- Xcode project configured with proper bundle ID and display name
- Device orientations configured (supports all orientations)
- App bundle name and version updated
- Release build successfully generated using `flutter build ipa`
- IPA file uploaded to App Store Connect via Transporter app
- App ready for TestFlight or App Store review

🔄 **Next Steps:**

- Complete App Store Connect metadata (screenshots, description, etc.)
- Internal testing via TestFlight (optional)
- Submit for App Store review
- Monitor review status and respond to any feedback

---
