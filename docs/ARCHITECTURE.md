# RaktSetu — System Architecture

> Detailed architecture documentation for the RaktSetu Smart Blood Allocation Platform.

---

## Architecture Overview

RaktSetu uses an **event-driven, serverless architecture**. Flutter clients talk directly to Firestore for real-time data and to Cloud Functions for complex operations. All side effects (notifications, AI, escalations) are triggered by Firestore document writes via Cloud Functions triggers.

```
                     ┌─────────────────────────────────────┐
                     │         Flutter Clients              │
                     │  (Android / iOS / Web / Admin)       │
                     └───────────┬─────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │    Firebase SDK Layer    │
                    │  (Auth, Firestore, FCM,  │
                    │   Storage, App Check)    │
                    └────────────┬────────────┘
                                 │
             ┌───────────────────┼───────────────────┐
             │                   │                   │
    ┌────────┴────────┐ ┌────────┴────────┐ ┌────────┴────────┐
    │  Cloud Firestore │ │ Cloud Functions │ │  Cloud Storage  │
    │  (Real-time DB)  │ │  (Business      │ │  (Files/Media)  │
    │                  │ │   Logic)        │ │                 │
    │  • users         │ │                 │ │  • Profile pics  │
    │  • requests      │ │  10 functions   │ │  • KYC docs      │
    │  • bloodBanks    │ │  (see below)    │ │  • Certificates  │
    │  • camps         │ │                 │ │  • Camp assets   │
    │  • notifications │ │                 │ │                 │
    │  • forecasts     │ │                 │ │                 │
    │  • leaderboard   │ │                 │ │                 │
    └────────┬────────┘ └────────┬────────┘ └─────────────────┘
             │                   │
             │   ┌───────────────┼───────────────┐
             │   │               │               │
             │   │    ┌──────────┴──────────┐    │
             │   │    │   External Services  │    │
             │   │    ├─────────────────────┤    │
             │   │    │ • Google Maps API    │    │
             │   │    │ • Vertex AI / Gemini │    │
             │   │    │ • Cloud Tasks        │    │
             │   │    │ • Cloud Pub/Sub      │    │
             │   │    │ • Cloud Scheduler    │    │
             │   │    │ • Twilio SMS         │    │
             │   │    │ • DigiLocker API     │    │
             │   │    └─────────────────────┘    │
             │   │                               │
             └───┴───────────────────────────────┘
```

---

## Data Flow: Blood Request Lifecycle

```
[Patient]                              [System]                              [Donor]
    │                                      │                                     │
    │  1. Create request                   │                                     │
    │─────────────────────────────────────▶│                                     │
    │                                      │                                     │
    │                          2. onRequestCreated                               │
    │                             • Compute urgency                              │
    │                             • Query donors                                 │
    │                             • Rank by distance                             │
    │                             • Update candidates                            │
    │                                      │                                     │
    │                                      │  3. FCM Push Notification           │
    │                                      │────────────────────────────────────▶│
    │                                      │                                     │
    │                                      │             4. Accept match         │
    │                                      │◀────────────────────────────────────│
    │                                      │                                     │
    │                          5. onDonorAccept                                  │
    │                             • Confirm match                                │
    │                             • Calculate ETA                                │
    │                             • Update status                                │
    │                                      │                                     │
    │   6. FCM: "Donor found! ETA: 15min"  │                                     │
    │◀─────────────────────────────────────│                                     │
    │                                      │                                     │
    │   7. Real-time status updates        │    8. Share live location           │
    │◀─────────────────────── Firestore ──│◀────────────────────────────────────│
    │                       snapshots()    │                                     │
    │                                      │                                     │
    │   9. "Donor arrived! Confirmed."     │                                     │
    │◀─────────────────────────────────────│                                     │
    │                                      │                                     │
    │                         10. donationCooldownCheck                           │
    │                             • Set isAvailable=false                         │
    │                             • Schedule 56-day re-enable                     │
    │                                      │                                     │
```

---

## Escalation Flow

```
T+0 min     Request created, urgency scored, top-5 donors notified
T+10 min    escalationScheduler checks for stale requests
T+30 min    Level 1 escalation: notify nearby blood banks
T+60 min    Level 2 escalation: notify state reserves (NBTC API)
```

---

## Cloud Functions Architecture

Each function is **single-responsibility** and **independently deployable**.

| Function | Trigger Type | Event Source | Output |
|----------|-------------|-------------|--------|
| `onRequestCreated` | Firestore onCreate | `/requests/{id}` | Updates request, sends FCM |
| `onDonorAccept` | Firestore onUpdate | `/requests/{id}` | Updates status, ETA, FCM |
| `escalationScheduler` | Cloud Scheduler | Every 10 min | Updates escalation level |
| `demandForecast` | Cloud Scheduler | Daily 2 AM | Writes to `/forecasts` |
| `notificationOrchestrator` | Pub/Sub | `notif-events` topic | Sends FCM/SMS/Email |
| `donationCooldownCheck` | Firestore onUpdate | `/users/{id}` | Sets availability |
| `campCertificateGen` | HTTPS Callable | Client call | Returns PDF URL |
| `inventorySync` | Pub/Sub | `hospital-inventory-events` | Updates blood bank |
| `leaderboardUpdater` | Cloud Scheduler | Hourly | Batch update leaderboard |
| `donorEligibilityChat` | HTTPS Callable | Client call | Returns AI response |

---

## Security Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet                                 │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                    ┌───────┴───────┐
                    │  Cloud Armor  │  ← DDoS / WAF
                    └───────┬───────┘
                            │
                    ┌───────┴───────┐
                    │  HTTPS / TLS  │  ← Encryption in transit
                    │    1.3        │
                    └───────┬───────┘
                            │
                    ┌───────┴───────┐
                    │   App Check   │  ← Block non-app clients
                    └───────┬───────┘
                            │
                    ┌───────┴───────┐
                    │  Firebase     │  ← JWT tokens, 1hr expiry
                    │  Auth         │
                    └───────┬───────┘
                            │
                    ┌───────┴───────┐
                    │  Firestore    │  ← Row-level access rules
                    │  Security     │
                    │  Rules        │
                    └───────┬───────┘
                            │
                    ┌───────┴───────┐
                    │  Cloud KMS    │  ← Encryption at rest
                    └───────────────┘
```

---

## Offline Architecture

Firestore provides **built-in offline support**:

1. **Cache**: All queried data is cached locally on device
2. **Writes**: Offline writes are queued and synced when connectivity returns
3. **Listeners**: `snapshots()` listeners fire from cache if offline
4. **Persistence**: Enabled by default on mobile (Android/iOS)

This means the app remains functional for:
- Viewing recent requests and donor profiles
- Creating new requests (queued for sync)
- Browsing blood bank inventory (from last sync)

---

## Scaling Strategy

| Scale | Users | Architecture | Cost |
|-------|-------|-------------|------|
| MVP | 0-500 DAU | Firebase free tier | ~$15/mo |
| Growth | 500-5K DAU | Firebase Blaze + auto-scaling | ~$100/mo |
| Scale | 5K-50K DAU | + Cloud Run for ML, + Memorystore | ~$500/mo |
| Enterprise | 50K+ DAU | + Load balancer, + multi-region | ~$2K/mo |

Cloud Functions and Firestore auto-scale without configuration changes.
