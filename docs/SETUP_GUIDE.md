# RaktSetu — Developer Setup Guide

> Step-by-step environment setup for new developers joining the RaktSetu project.

---

## Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Minimum Version | Installation |
|------|----------------|-------------|
| **Flutter SDK** | 3.22.0+ | [flutter.dev/get-started](https://flutter.dev/docs/get-started/install) |
| **Dart SDK** | 3.4.0+ | Included with Flutter |
| **Node.js** | 20.x | [nodejs.org](https://nodejs.org) |
| **npm** | 10.x+ | Included with Node.js |
| **Firebase CLI** | Latest | `npm install -g firebase-tools` |
| **FlutterFire CLI** | Latest | `dart pub global activate flutterfire_cli` |
| **Git** | Latest | [git-scm.com](https://git-scm.com) |
| **Android Studio** | Latest | [developer.android.com/studio](https://developer.android.com/studio) |
| **VS Code** (recommended) | Latest | [code.visualstudio.com](https://code.visualstudio.com) |

### Verify Installation

```bash
flutter --version    # Should show ≥ 3.22.0
dart --version       # Should show ≥ 3.4.0
node --version       # Should show v20.x.x
firebase --version   # Should show latest
flutter doctor       # Should show no critical issues
```

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/your-org/raktsetu.git
cd raktsetu
```

---

## Step 2: Install Dependencies

### Flutter Dependencies
```bash
flutter pub get
```

### Cloud Functions Dependencies
```bash
cd functions
npm install
cd ..
```

---

## Step 3: Firebase Project Setup

### 3.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Add Project** → Name it `raktsetu-dev`
3. Enable Google Analytics (optional for dev)

### 3.2 Enable Firebase Services
In the Firebase Console, enable:
- **Authentication** → Sign-in methods → Enable **Phone** and **Google**
- **Cloud Firestore** → Create database → Start in **test mode** → Region: `asia-south1`
- **Cloud Storage** → Get started → Region: `asia-south1`
- **Cloud Messaging** → Enabled by default
- **App Check** → Register your app (optional for dev)

### 3.3 Configure Flutter App
```bash
# Login to Firebase
firebase login

# Select your project
firebase use raktsetu-dev

# Auto-configure Flutter
flutterfire configure --project=raktsetu-dev
```

This generates `lib/config/firebase_options.dart` with your project's config.

### 3.4 Deploy Firestore Rules & Indexes
```bash
firebase deploy --only firestore
```

### 3.5 Deploy Storage Rules
```bash
firebase deploy --only storage
```

---

## Step 4: Google Cloud APIs

### 4.1 Enable APIs
Go to [Google Cloud Console → APIs](https://console.cloud.google.com/apis/library) and enable:

```
✅ Maps JavaScript API
✅ Maps SDK for Android
✅ Maps SDK for iOS
✅ Directions API
✅ Distance Matrix API
✅ Places API
✅ Geocoding API
✅ Vertex AI API
✅ Cloud Tasks API
✅ Cloud Scheduler API
✅ Cloud Pub/Sub API
✅ Secret Manager API
```

### 4.2 Create API Keys
1. Go to **APIs & Services → Credentials**
2. Create an API key for **Android** (restrict to Maps SDK for Android)
3. Create an API key for **iOS** (restrict to Maps SDK for iOS)
4. Create an API key for **Web** (restrict to Maps JavaScript API)

---

## Step 5: Environment Configuration

```bash
# Copy the template
cp .env.example .env
```

Fill in your values in `.env`:
```
GOOGLE_MAPS_API_KEY_ANDROID=AIza...
GOOGLE_MAPS_API_KEY_IOS=AIza...
GOOGLE_MAPS_API_KEY_WEB=AIza...
```

### Android Maps Key
Add to `android/app/src/main/AndroidManifest.xml` inside `<application>`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ANDROID_MAPS_KEY"/>
```

### iOS Maps Key
Add to `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_IOS_MAPS_KEY")
```

---

## Step 6: Run Locally

### Option A: With Firebase Emulators (Recommended for dev)
```bash
# Terminal 1: Start emulators
firebase emulators:start

# Terminal 2: Run Flutter app
flutter run
```

The Emulator UI is at `http://localhost:4000`.

### Option B: Against Live Firebase (for testing)
```bash
flutter run
```

### Run on specific device
```bash
flutter devices                  # List available devices
flutter run -d chrome            # Web
flutter run -d emulator-5554      # Android emulator
flutter run -d <device-id>       # Specific device
```

---

## Step 7: Deploy Cloud Functions (Optional)

```bash
# Deploy all functions
firebase deploy --only functions

# Deploy a specific function
firebase deploy --only functions:onRequestCreated

# View logs
firebase functions:log --follow
```

---

## VS Code Extensions (Recommended)

| Extension | Purpose |
|-----------|---------|
| Dart | Dart language support |
| Flutter | Flutter SDK integration |
| Firebase Explorer | Browse Firestore in VS Code |
| GitLens | Git blame/history |
| Error Lens | Inline error display |

### VS Code Settings
Create `.vscode/settings.json`:
```json
{
  "dart.flutterSdkPath": "path/to/flutter",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.rulers": [80, 120]
  }
}
```

---

## Troubleshooting

### `flutter pub get` fails
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Firebase emulator won't start
```bash
# Check for port conflicts
lsof -i :5000    # Hosting
lsof -i :5001    # Functions
lsof -i :8080    # Firestore
lsof -i :9099    # Auth

# Kill conflicting process
kill -9 <PID>
```

### Google Maps not showing
- Verify API key is added to `AndroidManifest.xml` / `AppDelegate.swift`
- Check API key restrictions in Google Cloud Console
- Ensure Maps SDK API is enabled

### Cloud Functions deployment fails
```bash
cd functions
npm install     # Reinstall deps
npm run lint    # Check for errors
firebase deploy --only functions --debug  # Verbose output
```
