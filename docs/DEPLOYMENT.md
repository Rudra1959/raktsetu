# RaktSetu — Deployment Guide

> CI/CD pipeline documentation and deployment procedures for all environments.

---

## Environments

| Environment | Firebase Project | Purpose | Access |
|-------------|-----------------|---------|--------|
| **Development** | `raktsetu-dev` | Local dev + unit tests | Engineers only |
| **Staging** | `raktsetu-staging` | QA + integration tests | QA + PMs |
| **Production** | `raktsetu-prod` | Live users | Operations team |

### Switch Environments
```bash
firebase use dev          # Development
firebase use staging      # Staging
firebase use production   # Production
```

---

## CI/CD Pipeline (Google Cloud Build)

The pipeline is defined in `cloudbuild.yaml` and triggers automatically on GitHub events.

### Pipeline Flow

```
Developer pushes to feature branch
        │
        ▼
┌───────────────┐
│ Cloud Build   │  PR trigger
│ Trigger       │
└───────┬───────┘
        │
        ▼
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│ flutter       │────▶│ flutter       │────▶│ flutter       │
│ pub get       │     │ analyze       │     │ test          │
└───────────────┘     └───────────────┘     └───────┬───────┘
                                                    │
                                                    ▼
                      ┌───────────────┐     ┌───────────────┐
                      │ npm install   │────▶│ npm run lint  │
                      │ (functions)   │     │ (functions)   │
                      └───────────────┘     └───────┬───────┘
                                                    │
                                            ┌───────┴───────┐
                                            │               │
                                            ▼               ▼
                                    ┌──────────────┐ ┌──────────────┐
                                    │ flutter      │ │ firebase     │
                                    │ build apk    │ │ deploy       │
                                    └──────────────┘ └──────────────┘
```

### Trigger Rules

| Event | Branch | Action |
|-------|--------|--------|
| PR opened/updated | Any → `develop` | Lint + Test (no deploy) |
| PR merged | `develop` | Deploy to **staging** |
| PR merged | `main` | Deploy to **production** |
| Manual trigger | Any | Custom deploy target |

---

## Manual Deployment

### Deploy Everything
```bash
firebase deploy --project=raktsetu-staging
```

### Deploy Specific Components

```bash
# Cloud Functions only
firebase deploy --only functions --project=raktsetu-prod

# Specific function
firebase deploy --only functions:onRequestCreated --project=raktsetu-prod

# Firestore rules + indexes
firebase deploy --only firestore --project=raktsetu-prod

# Storage rules
firebase deploy --only storage --project=raktsetu-prod

# Hosting (Flutter web)
flutter build web
firebase deploy --only hosting --project=raktsetu-prod
```

---

## Flutter App Deployment

### Android (APK / AAB)

```bash
# Build release APK
flutter build apk --release

# Build release App Bundle (for Play Store)
flutter build appbundle --release

# Output locations:
# APK:  build/app/outputs/flutter-apk/app-release.apk
# AAB:  build/app/outputs/bundle/release/app-release.aab
```

### Beta Distribution (Firebase App Distribution)
```bash
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_ANDROID_APP_ID \
  --groups "qa-testers" \
  --release-notes "Bug fixes and performance improvements"
```

### Google Play Store
1. Build signed AAB: `flutter build appbundle --release`
2. Upload to [Google Play Console](https://play.google.com/console)
3. Submit for review → Production release

### iOS
```bash
flutter build ios --release
# Then open Xcode → Archive → Upload to App Store Connect
```

### Web
```bash
flutter build web
firebase deploy --only hosting
```

---

## Post-Deployment Checklist

- [ ] Verify app loads correctly (web / mobile)
- [ ] Test critical flow: create request → match → confirm
- [ ] Check Cloud Functions logs for errors
- [ ] Verify Firestore security rules are active
- [ ] Check Firebase Performance monitoring
- [ ] Review Crashlytics for new crashes
- [ ] Verify FCM notifications are delivered

---

## Monitoring

### Cloud Functions Logs
```bash
firebase functions:log --follow
firebase functions:log --only onRequestCreated
```

### Google Cloud Monitoring
- Set up uptime checks: [Cloud Monitoring](https://console.cloud.google.com/monitoring)
- Alerting policies for response time > 2s
- Error rate alerting > 1%

### Firebase Console
- **Analytics**: User engagement, active users
- **Crashlytics**: Real-time crash reports
- **Performance**: App startup, network latency

---

## Rollback Procedures

### Cloud Functions
```bash
# List recent deployments
firebase functions:log

# Rollback to previous version via Google Cloud Console:
# Cloud Functions → Select function → Versions → Deploy previous
```

### Firestore Rules
```bash
# Edit firestore.rules to previous state
git checkout HEAD~1 -- firestore.rules
firebase deploy --only firestore:rules
```

### Flutter App
- For web: redeploy previous build via `firebase hosting:rollback`
- For mobile: previous versions still on users' devices; push urgent update via Play Store

---

## Security Checklist

- [ ] API keys stored in Secret Manager (not in source code)
- [ ] App Check enabled for production
- [ ] Firestore rules are restrictive (no open read/write)
- [ ] Storage rules enforce file size limits
- [ ] HTTPS enforced on all endpoints
- [ ] Firebase Auth token expiry set to 1 hour
- [ ] Cloud Armor rules configured for Cloud Run
