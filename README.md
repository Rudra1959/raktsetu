# 🩸 RaktSetu — Smart Blood Allocation Platform

> **रक्त • सेतु** — *Blood • Bridge*
>
> Real-time blood donor-patient matching with AI-powered demand forecasting.
> Built entirely on the Google ecosystem.

[![Flutter](https://img.shields.io/badge/Flutter-3.22+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase)](https://firebase.google.com)
[![Vertex AI](https://img.shields.io/badge/Vertex_AI-Gemini_2.0-4285F4?logo=google-cloud)](https://cloud.google.com/vertex-ai)
[![License](https://img.shields.io/badge/License-Proprietary-red)]()
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen)]()

---

## 📋 Table of Contents

- [Overview](#overview)
- [The Problem](#the-problem)
- [The Solution](#the-solution)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Setup Guide](#setup-guide)
- [Firestore Data Model](#firestore-data-model)
- [Cloud Functions Reference](#cloud-functions-reference)
- [Core Algorithm: Matching Engine](#core-algorithm-matching-engine)
- [AI Integration](#ai-integration)
- [Security & Compliance](#security--compliance)
- [Cost Estimation](#cost-estimation)
- [Roadmap](#roadmap)
- [Contributing](#contributing)

---

## Overview

**RaktSetu** (Sanskrit: *Blood Bridge*) is a next-generation, mobile-first blood allocation and emergency coordination platform. It connects blood donors with patients in **real-time** using:

- 🔴 **Intelligent matching algorithms** (sub-500ms response)
- 📍 **Location-aware services** (Google Maps Platform)
- 🤖 **AI-powered demand forecasting** (Vertex AI + Gemini)
- 🚨 **Emergency priority queue** (ML-based triage, not FIFO)

### Key Metrics
| Metric | Target |
|--------|--------|
| Matching latency | < 500ms |
| Search radius (default) | 5 km (auto-expands) |
| Forecast window | 14 days ahead |
| Languages supported | 12 Indian languages |
| Donation cooldown | 56 days (enforced) |

---

## The Problem

| Issue | Impact |
|-------|--------|
| Phone-based coordination | Hours of delay for critical patients |
| No real-time donor visibility | Blood banks can't locate available donors |
| FIFO queuing | Critical patients wait behind non-urgent cases |
| Rural disconnect | No access to urban blood supply chains |
| No demand prediction | Festivals/accidents cause unpredictable shortages |

## The Solution

| Feature | How It Works |
|---------|-------------|
| **Instant Matching** | Firestore real-time listeners + geoqueries → sub-500ms donor discovery |
| **Geospatial Ranking** | Haversine algorithm in Cloud Functions → nearest compatible donors |
| **Emergency Priority** | ML urgency scoring (0-100) → critical cases auto-prioritized |
| **Live Inventory** | Hospital ERP sync → real-time blood bank stock visibility |
| **AI Forecasting** | Gemini + Vertex AI → 14-day demand prediction with proactive outreach |
| **End-to-End Tracking** | Request → Match → En Route → Confirmed (real-time status) |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENTS                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐   │
│  │ Android  │  │   iOS    │  │   Web    │  │ Admin Panel  │   │
│  │ (Flutter)│  │ (Flutter)│  │ (Flutter)│  │   (Flutter)  │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬───────┘   │
│       └──────────────┴──────────────┴───────────────┘           │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                │   Firebase Services   │
                ├───────────────────────┤
                │ • Auth (OTP + Google) │
                │ • Firestore (RT DB)   │
                │ • Cloud Functions     │
                │ • Cloud Messaging     │
                │ • App Check           │
                │ • Storage             │
                │ • Remote Config       │
                └───────────┬───────────┘
                            │
         ┌──────────────────┼──────────────────┐
         │                  │                  │
┌────────┴────────┐ ┌───────┴───────┐ ┌───────┴───────┐
│  Google Maps    │ │   Vertex AI   │ │  Google Cloud  │
│  Platform       │ │   + Gemini    │ │   Services     │
├─────────────────┤ ├───────────────┤ ├────────────────┤
│ • Maps SDK      │ │ • AutoML      │ │ • Cloud Tasks  │
│ • Directions    │ │ • Gemini API  │ │ • Pub/Sub      │
│ • Distance Mx   │ │ • Vision OCR  │ │ • Cloud Run    │
│ • Geocoding     │ │ • Translate   │ │ • Memorystore  │
│ • Places        │ │ • NLP         │ │ • Secret Mgr   │
└─────────────────┘ └───────────────┘ └────────────────┘
```

### Architecture Principles
- **Serverless-first** — Zero infrastructure to manage, auto-scales to 10K+ users
- **Event-driven** — Every Firestore write triggers downstream Cloud Functions
- **Offline-first** — Firestore local cache keeps app functional without internet
- **Security-first** — Firebase Security Rules + App Check at the DB layer
- **Cost-optimized** — Free tier covers early stages, scales on demand

---

## Tech Stack

> **100% Google Ecosystem** — Native interoperability, unified billing, first-class support.

### Frontend — Flutter

| Package | Purpose |
|---------|---------|
| `flutter` (SDK) | Core UI framework (Dart) |
| `google_maps_flutter` | Interactive maps, route overlays |
| `firebase_core` | Firebase initialization |
| `firebase_auth` | Google Sign-In, Phone OTP |
| `cloud_firestore` | Real-time database |
| `firebase_messaging` | Push notifications (FCM) |
| `firebase_analytics` | User behavior analytics |
| `firebase_crashlytics` | Crash reporting |
| `firebase_storage` | Photos & documents |
| `firebase_app_check` | Anti-abuse protection |
| `google_sign_in` | OAuth 2.0 Google login |
| `geolocator` | Device GPS access |
| `provider` | State management |
| `fl_chart` | Analytics charts |
| `flutter_animate` | Micro-animations |
| `google_fonts` | Inter typography |

### Backend — Firebase + Google Cloud

| Service | Role in RaktSetu |
|---------|-----------------|
| Firebase Auth | Phone OTP, Google Sign-In |
| Cloud Firestore | Real-time donor/patient DB with geopoint indexing |
| Cloud Functions (Node.js 20) | Matching engine, scoring, notifications |
| FCM | Push notifications |
| App Hosting | Flutter Web + admin dashboard |
| Remote Config | Feature flags, A/B testing |
| Cloud Storage | Profile photos, KYC docs, certificates |
| Cloud Tasks | Scheduled jobs (reminders, escalation timers) |
| Cloud Pub/Sub | Event streaming between microservices |
| Cloud Run | Containerized ML inference |
| Secret Manager | Secure API key storage |

### AI / ML — Vertex AI + Gemini

| Tool | Use Case |
|------|----------|
| Vertex AI AutoML | Demand prediction on historical data |
| Gemini API (`gemini-2.0-flash-exp`) | Eligibility chatbot in 12 languages |
| Cloud Vision API | Aadhaar/ID card OCR for KYC |
| Google Translate API | Multi-language UI support |

### Maps — Google Maps Platform

| API | Usage |
|-----|-------|
| Maps SDK | Donor map, blood bank markers |
| Directions API | ETA calculation, route polylines |
| Distance Matrix API | Batch distance ranking |
| Geocoding API | Address → coordinates |
| Places API | Hospital name autocomplete |

---

## Project Structure

```
raktsetu/
├── 📄 pubspec.yaml                  # Flutter dependencies
├── 📄 firebase.json                 # Firebase project config
├── 📄 firestore.rules               # Firestore security rules
├── 📄 firestore.indexes.json        # Composite indexes
├── 📄 storage.rules                 # Storage security rules
├── 📄 .firebaserc                   # Environment aliases
├── 📄 .env.example                  # Environment variables template
├── 📄 cloudbuild.yaml               # CI/CD pipeline
├── 📄 analysis_options.yaml         # Dart lint rules
│
├── 📁 lib/                          # Flutter app source
│   ├── 📄 main.dart                 # Entry point + Firebase init
│   ├── 📄 app.dart                  # MaterialApp configuration
│   │
│   ├── 📁 config/                   # App configuration
│   │   ├── theme.dart               # Material 3 theme + brand colors
│   │   ├── routes.dart              # Named route definitions
│   │   ├── constants.dart           # App constants + blood compatibility
│   │   └── firebase_options.dart    # Firebase config (auto-generated)
│   │
│   ├── 📁 models/                   # Data models (Firestore ↔ Dart)
│   │   ├── user_model.dart          # Donor / Patient / Admin
│   │   ├── request_model.dart       # Blood request + hospital info
│   │   ├── blood_bank_model.dart    # Blood bank + inventory
│   │   ├── camp_model.dart          # Blood camp / drive
│   │   └── notification_model.dart  # Multi-channel notification
│   │
│   ├── 📁 services/                 # Business logic layer
│   │   ├── auth_service.dart        # Google Sign-In + Phone OTP
│   │   ├── firestore_service.dart   # CRUD for all collections
│   │   ├── matching_service.dart    # Haversine + donor ranking
│   │   ├── notification_service.dart# FCM + local notifications
│   │   ├── location_service.dart    # GPS + permissions
│   │   ├── maps_service.dart        # Directions + Distance Matrix
│   │   └── gemini_service.dart      # Eligibility chatbot API
│   │
│   ├── 📁 providers/                # State management (Provider)
│   │   ├── auth_provider.dart       # Auth session state
│   │   ├── request_provider.dart    # Blood request lifecycle
│   │   ├── donor_provider.dart      # Donor profile + availability
│   │   └── location_provider.dart   # Live GPS tracking
│   │
│   ├── 📁 screens/                  # UI screens
│   │   ├── splash_screen.dart       # Animated splash
│   │   ├── onboarding_screen.dart   # First-time user flow
│   │   ├── 📁 auth/                 # Authentication
│   │   ├── 📁 home/                 # Dashboard
│   │   ├── 📁 request/              # Blood request flow
│   │   ├── 📁 donor/                # Donor management
│   │   ├── 📁 maps/                 # Google Maps views
│   │   ├── 📁 blood_bank/           # Blood bank browsing
│   │   ├── 📁 camps/                # Blood camps
│   │   ├── 📁 analytics/            # Dashboard + charts
│   │   ├── 📁 chatbot/              # Gemini eligibility Q&A
│   │   └── 📁 settings/             # App settings
│   │
│   ├── 📁 widgets/                  # Reusable components
│   │   ├── status_tracker.dart      # Step progress indicator
│   │   ├── blood_group_chip.dart    # Color-coded blood badge
│   │   ├── urgency_badge.dart       # Critical/Urgent/Standard
│   │   ├── donor_card.dart          # Donor info card
│   │   ├── request_card.dart        # Request summary
│   │   ├── loading_overlay.dart     # Full-screen loader
│   │   └── empty_state.dart         # Empty list placeholder
│   │
│   └── 📁 utils/                    # Utility functions
│       ├── haversine.dart           # Distance calculation
│       ├── urgency_calculator.dart  # Score computation
│       ├── validators.dart          # Form validation
│       ├── formatters.dart          # Date/distance/time
│       └── extensions.dart          # Dart extensions
│
├── 📁 functions/                    # Firebase Cloud Functions
│   ├── 📄 package.json              # Node.js 20 dependencies
│   ├── 📄 index.js                  # Main exports
│   └── 📁 src/
│       ├── 📁 matching/             # Donor-patient matching
│       ├── 📁 scoring/              # Urgency scoring
│       ├── 📁 notifications/        # FCM/SMS/Email routing
│       ├── 📁 ai/                   # Gemini + Vertex AI
│       ├── 📁 scheduling/           # Timers + cooldowns
│       ├── 📁 camps/                # Certificate generation
│       ├── 📁 inventory/            # Hospital ERP sync
│       └── 📁 leaderboard/          # Gamification
│
├── 📁 assets/                       # App assets
│   ├── 📁 images/
│   ├── 📁 icons/
│   └── 📁 fonts/
│
├── 📁 docs/                         # Documentation
│   ├── ARCHITECTURE.md
│   ├── API_REFERENCE.md
│   ├── FIRESTORE_SCHEMA.md
│   ├── SETUP_GUIDE.md
│   └── DEPLOYMENT.md
│
└── 📁 .gemini/skills/               # AI development skills
    ├── raktsetu-firebase/
    ├── raktsetu-flutter/
    └── raktsetu-cloud-functions/
```

---

## Setup Guide

### Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter SDK | ≥ 3.22.0 | [flutter.dev/get-started](https://flutter.dev/docs/get-started/install) |
| Dart SDK | ≥ 3.4.0 | Included with Flutter |
| Node.js | 20.x | [nodejs.org](https://nodejs.org) |
| Firebase CLI | Latest | `npm install -g firebase-tools` |
| FlutterFire CLI | Latest | `dart pub global activate flutterfire_cli` |
| Google Cloud SDK | Latest | [cloud.google.com/sdk](https://cloud.google.com/sdk/docs/install) |

### Step 1: Clone & Install

```bash
# Clone the repository
git clone https://github.com/your-org/raktsetu.git
cd raktsetu

# Install Flutter dependencies
flutter pub get

# Install Cloud Functions dependencies
cd functions
npm install
cd ..
```

### Step 2: Firebase Setup

```bash
# Login to Firebase
firebase login

# Create project (or use existing)
firebase projects:create raktsetu-dev

# Configure Flutter app
flutterfire configure --project=raktsetu-dev

# Enable required services in Firebase Console:
# - Authentication (Phone + Google)
# - Cloud Firestore
# - Cloud Functions
# - Cloud Messaging
# - Cloud Storage
# - App Check
```

### Step 3: Google Cloud APIs

Enable these APIs in [Google Cloud Console](https://console.cloud.google.com/apis):

```
Maps JavaScript API
Maps SDK for Android
Maps SDK for iOS
Directions API
Distance Matrix API
Places API
Geocoding API
Vertex AI API
Cloud Tasks API
Cloud Scheduler API
Pub/Sub API
Secret Manager API
Cloud Vision API
Translation API
```

### Step 4: Environment Setup

```bash
# Copy environment template
cp .env.example .env

# Fill in your API keys:
# - Firebase config (from flutterfire configure)
# - Google Maps API keys
# - Twilio credentials (optional)
# - DigiLocker API keys (optional)
```

### Step 5: Android Setup

Add your Google Maps API key to `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ANDROID_MAPS_KEY"/>
```

### Step 6: Run

```bash
# Start Firebase emulators (for local dev)
firebase emulators:start

# Run Flutter app

flutter run
# Deploy to Firebase
firebase deploy
```

---

## Firestore Data Model

### `/users/{userId}`
```json
{
  "uid": "string",
  "name": "string",
  "phone": "+91XXXXXXXXXX",
  "email": "string",
  "role": "donor | patient | hospital_admin",
  "bloodGroup": "A+ | A- | B+ | B- | O+ | O- | AB+ | AB-",
  "location": "GeoPoint(lat, lng)",
  "city": "string",
  "state": "string",
  "isAvailable": true,
  "availabilityMode": "on_duty | off_duty | traveling",
  "lastDonated": "Timestamp",
  "totalDonations": 0,
  "badges": ["First Drop", "Life Saver"],
  "healthScore": 100,
  "preferredRadiusKm": 10.0,
  "createdAt": "Timestamp"
}
```

### `/requests/{requestId}`
```json
{
  "requesterId": "userId",
  "patientName": "string",
  "bloodGroup": "O+",
  "units": 2,
  "urgencyScore": 75,
  "condition": "critical | urgent | standard",
  "hospital": { "name": "string", "address": "string", "geopoint": "GeoPoint" },
  "status": "pending | matching | matched | en_route | fulfilled | no_match",
  "matchedDonorId": "userId | null",
  "candidateDonors": ["userId1", "userId2"],
  "escalationLevel": 0,
  "requestedAt": "Timestamp",
  "fulfilledAt": "Timestamp | null"
}
```

### `/bloodBanks/{bankId}`
```json
{
  "name": "City Blood Bank",
  "license": "string",
  "location": "GeoPoint",
  "phone": "+91XXXXXXXXXX",
  "inventory": { "A+": 12, "A-": 3, "B+": 8, "B-": 2, "O+": 15, "O-": 4, "AB+": 6, "AB-": 1 },
  "lastUpdated": "Timestamp",
  "isVerified": true
}
```

### `/camps/{campId}`
```json
{
  "organizerId": "userId",
  "title": "Community Blood Drive",
  "date": "Timestamp",
  "location": "GeoPoint",
  "address": "string",
  "targetUnits": 50,
  "collectedUnits": 32,
  "rsvpCount": 45,
  "status": "upcoming | live | completed"
}
```

See [docs/FIRESTORE_SCHEMA.md](docs/FIRESTORE_SCHEMA.md) for complete field descriptions.

---

## Cloud Functions Reference

| Function | Trigger | Description |
|----------|---------|-------------|
| `onRequestCreated` | Firestore `onCreate /requests/{id}` | Computes urgency, finds top-5 donors, sends FCM |
| `onDonorAccept` | Firestore `onUpdate /requests/{id}` | Confirms match, calculates ETA, notifies patient |
| `escalationScheduler` | Cloud Scheduler (every 10 min) | Escalates stale requests to blood banks → state reserves |
| `demandForecast` | Cloud Scheduler (daily 2 AM) | Generates 14-day blood demand forecast |
| `notificationOrchestrator` | Pub/Sub `notif-events` | Routes alerts to FCM/SMS/Email |
| `donationCooldownCheck` | Firestore `onUpdate /users/{id}` | Enforces 56-day cooldown after donation |
| `campCertificateGen` | HTTPS Callable | Generates PDF volunteer certificate |
| `inventorySync` | Pub/Sub `hospital-inventory-events` | Syncs hospital ERP data to Firestore |
| `leaderboardUpdater` | Cloud Scheduler (hourly) | Aggregates top-100 donor leaderboard |
| `donorEligibilityChat` | HTTPS Callable | Gemini-powered eligibility Q&A |

---

## Core Algorithm: Matching Engine

The matching engine runs in the `onRequestCreated` Cloud Function:

```
1. New blood request created in Firestore
       ↓
2. Compute urgency score (0-100)
   • Patient condition:  0-40 pts (critical=40, urgent=25, standard=10)
   • Surgery window:     0-30 pts (closer deadline = higher score)
   • Blood type rarity:  0-20 pts (AB-=20, B-/A-=15, O-=10, ...)
   • Units needed:       0-10 pts (2 pts per unit, max 10)
       ↓
3. Query Firestore for available, compatible donors
   • role == 'donor'
   • isAvailable == true
   • bloodGroup == requested group
       ↓
4. Rank by distance (Haversine formula)
   • Filter: within donor's preferred radius (default 10km)
   • Sort: nearest first
   • Select: top 5 candidates
       ↓
5. Update request with candidates + urgency score
       ↓
6. Send FCM push notification to #1 candidate
       ↓
7. If no response in 30 min → escalate
```

### Haversine Formula
```
d = 2R × arctan2(√a, √(1−a))

where:
  a = sin²(Δlat/2) + cos(lat1) × cos(lat2) × sin²(Δlon/2)
  R = 6371 km (Earth's radius)
```

---

## AI Integration

### Gemini Eligibility Chatbot
- **Model**: `gemini-2.0-flash-exp`
- **Region**: `asia-south1`
- **Languages**: English, Hindi, Tamil, Telugu, Kannada, Malayalam, Marathi, Gujarati, Bengali, Punjabi, Odia, Assamese
- **System prompt**: Trained on Indian NBTC/Red Cross eligibility criteria
- **Guardrails**: Only answers blood donation questions, redirects off-topic

### Demand Forecasting
- **Input**: 30 days of request history
- **Output**: 14-day forecast per blood group
- **Method**: Weighted moving average (v1), Vertex AI AutoML (v2)
- **Trigger**: Daily at 2 AM IST via Cloud Scheduler
- **Usage**: Proactive donor outreach, hospital inventory planning

---

## Security & Compliance

### Security Layers
| Layer | Technology | Protection |
|-------|-----------|------------|
| App Level | Firebase App Check | Blocks bots & scrapers |
| Auth Level | Firebase Auth (JWT) | 1-hour token expiry, auto-refresh |
| DB Level | Firestore Security Rules | Row-level access control |
| Network | HTTPS + TLS 1.3 | All traffic encrypted |
| Infrastructure | Cloud Armor | DDoS + WAF protection |
| Secrets | Secret Manager | No API keys in source code |
| Audit | Cloud Audit Logs | Immutable operation logs |

### DPDP Act 2023 (India) Compliance
- Data stored in `asia-south1` (Mumbai) — no cross-border transfer
- PII encrypted at rest via Google Cloud KMS
- Self-service account deletion with PII removal
- Explicit consent at signup with stored timestamps
- Anonymized aggregates preserved after deletion

---

## Cost Estimation

| Service | Free Tier | ~500 DAU/mo | ~10K DAU/mo |
|---------|-----------|-------------|-------------|
| Firestore | 50K reads/day | ~$5 | ~$80 |
| Cloud Functions | 2M invocations | $0 | ~$15 |
| Firebase Auth | 10K OTP/mo free | ~$5 | ~$30 |
| FCM | Unlimited | $0 | $0 |
| Google Maps | $200 credit/mo | $0 | ~$50 |
| Vertex AI/Gemini | 60 req/min free | ~$5 | ~$40 |
| Cloud Storage | 5GB free | $0 | ~$5 |
| Cloud Run | 2M vCPU-sec free | $0 | ~$20 |
| **Total** | — | **~$15/mo** | **~$240/mo** |

---

## Roadmap

| Phase | Timeline | Deliverables |
|-------|----------|-------------|
| **Phase 1 — MVP** | Month 1-3 | Donor registration, blood request, basic matching, FCM, Maps |
| **Phase 2 — Intelligence** | Month 4-6 | Urgency scoring, escalation, Gemini chatbot, live inventory |
| **Phase 3 — Community** | Month 7-9 | Blood camps, gamification, leaderboard, multi-language |
| **Phase 4 — AI/Analytics** | Month 10-12 | Vertex AI forecasting, Looker Studio dashboard, reporting |
| **Phase 5 — Scale** | Year 2 | Drone delivery, blockchain certificates, NBTC API, Wear OS |

---

## Contributing

1. Create a feature branch from `develop`
2. Follow Flutter naming conventions (see `.gemini/skills/raktsetu-flutter/SKILL.md`)
3. Write tests for new features
4. Run `flutter analyze` and `flutter test` before PR
5. PR reviews required before merge

---

## References

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter + Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)
- [Vertex AI Gemini API](https://cloud.google.com/vertex-ai/docs/generative-ai/start/quickstarts/quickstart-multimodal)
- [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [DPDP Act 2023](https://www.meity.gov.in/data-protection-framework)

---

<p align="center">
  Built with ❤️ using Google · Firebase · Vertex AI<br>
  <strong>RaktSetu v1.0 — Saving lives, one connection at a time.</strong>
</p>
