
# Mindly Deployment Checkist

## 1. App Identity & Package Name
Currently, your app ID is `com.example.quiz_app`. This is a placeholder and usually rejected by stores.
**To fix this:**
1.  Choose a unique ID (e.g., `com.mindly.app`).
2.  Edit `android/app/build.gradle`:
    *   Change `namespace "com.example.quiz_app"` to `namespace "com.your.id"`
    *   Change `applicationId "com.example.quiz_app"` to `applicationId "com.your.id"`
3.  **IMPORTANT**: Search the entire project folder for `com.example.quiz_app` and replace it (specifically in `MainActivity.kt` or `AndroidManifest.xml` if present).

## 2. Firebase Configuration (CRITICAL)
If you change the Package Name (Step 1), Firebase will stop working because the ID doesn't match `google-services.json`.
**Action:**
1.  Go to [Firebase Console](https://console.firebase.google.com/).
2.  Project Settings -> General.
3.  "Add App" -> Android.
4.  Enter your NEW package name (e.g., `com.mindly.app`).
5.  Download `google-services.json`.
6.  Replace the existing file in `android/app/google-services.json`.
7.  (Optional) Setup SHA-1 / SHA-256 fingerprints in Firebase Console for Google Sign-In to work in production (Release Keys).

## 3. Database Indexes
Ensure you created the Firestore Index (link provided previously).

## 4. App Icons
I have run the icon generator for you. The app now uses the Mindly logo (`assets/icon/mindly_icon.png`) instead of the Flutter default icon.

## 5. Android Signing (Keystore)
To publish a Release build (AAB/APK), you must sign it.
1.  **Generate Keystore**:
    Run this terminal command (set your own password):
    ```bash
    keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    ```
2.  Move the generated `upload-keystore.jks` file into the `android/app/` folder.
3.  Create a file `android/key.properties` (do not commit this to public git):
    ```properties
    storePassword=<your_password>
    keyPassword=<your_password>
    keyAlias=upload
    storeFile=upload-keystore.jks
    ```
4.  Edit `android/app/build.gradle` to use the keystore in `buildTypes -> release`.

## 6. Build Command
Once ready, run:
```bash
flutter build appbundle
```
Upload the resulting `.aab` file to Google Play Console.

## 7. iOS Deployment (If applicable)
1.  Open `ios/Runner.xcworkspace` in Xcode.
2.  In "Runner" settings -> General -> Identity, update "Bundle Identifier".
3.  In "Signing & Capabilities", select your Apple Developer Team.
4.  Archive and Upload to App Store.
