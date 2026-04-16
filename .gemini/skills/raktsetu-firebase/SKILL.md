---
name: raktsetu-firebase
description: Firebase operations skill for RaktSetu — deploy functions, update rules, manage environments, run emulators, and manage Firestore data.
---

# RaktSetu Firebase Operations Skill

## Purpose
This skill provides standardized patterns and commands for all Firebase operations in the RaktSetu project.

## Prerequisites
- Firebase CLI installed: `npm install -g firebase-tools`
- Logged in: `firebase login`
- Project selected: `firebase use <project-id>`

---

## Common Operations

### 1. Switch Environment
```bash
# Development
firebase use dev

# Staging
firebase use staging

# Production
firebase use production
```

### 2. Deploy Cloud Functions
```bash
# Deploy all functions
firebase deploy --only functions

# Deploy a single function
firebase deploy --only functions:onRequestCreated

# Deploy multiple specific functions
firebase deploy --only functions:onRequestCreated,functions:onDonorAccept
```

### 3. Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### 4. Deploy Firestore Indexes
```bash
firebase deploy --only firestore:indexes
```

### 5. Deploy Storage Rules
```bash
firebase deploy --only storage
```

### 6. Deploy Hosting (Flutter Web)
```bash
# Build Flutter web first
flutter build web

# Deploy hosting
firebase deploy --only hosting
```

### 7. Full Deploy
```bash
firebase deploy
```

---

## Local Development

### Start Emulators
```bash
# Start all configured emulators
firebase emulators:start

# Start specific emulators
firebase emulators:start --only auth,firestore,functions

# Start with data import
firebase emulators:start --import=./emulator-data

# Start and export data on shutdown
firebase emulators:start --export-on-exit=./emulator-data
```

### View Emulator UI
Open `http://localhost:4000` in your browser.

### Test Functions Locally
```bash
cd functions
npm run serve
```

### View Cloud Functions Logs
```bash
# All logs
firebase functions:log

# Specific function
firebase functions:log --only onRequestCreated

# Follow mode
firebase functions:log --follow
```

---

## Firestore Operations

### Export Data (Backup)
```bash
gcloud firestore export gs://raktsetu-prod-backups/$(date +%Y%m%d)
```

### Import Data
```bash
gcloud firestore import gs://raktsetu-prod-backups/20250416
```

### Seed Test Data
Use the Firebase Emulator UI or create a seed script:
```bash
node scripts/seed-test-data.js
```

---

## App Distribution (Beta Testing)
```bash
# Build APK
flutter build apk

# Upload to App Distribution
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app <your-app-id> \
  --groups "testers"
```

---

## Monitoring
```bash
# Check Firebase project status
firebase projects:list

# View usage
firebase hosting:channel:list
```

---

## Troubleshooting

### "Permission Denied" on deploy
```bash
firebase login --reauth
firebase use <correct-project>
```

### Functions not deploying
```bash
cd functions
npm install
npm run lint
```

### Emulator port conflicts
Check `firebase.json` emulator ports and ensure nothing else is using 5000, 5001, 8080, 9099, or 9199.
