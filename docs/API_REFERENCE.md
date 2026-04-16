# RaktSetu — Cloud Functions API Reference

> Complete reference for all Firebase Cloud Functions in RaktSetu.

---

## Overview

All functions run on **Node.js 20** in the **`asia-south1`** region. Business logic is organized into modules under `functions/src/`.

---

## 1. `onRequestCreated`

**Type**: Firestore Trigger (onCreate)
**Document**: `/requests/{requestId}`
**File**: `functions/src/matching/onRequestCreated.js`

### What It Does
1. Computes urgency score (0-100) from request parameters
2. Queries Firestore for available, compatible donors
3. Ranks donors by distance using Haversine formula
4. Filters to donors within their preferred radius
5. Updates request with top-5 candidate donor IDs
6. Sends FCM push notification to the #1 candidate

### Urgency Scoring Breakdown

| Factor | Points | Details |
|--------|--------|---------|
| Patient condition | 0-40 | critical=40, urgent=25, standard=10 |
| Surgery window | 0-30 | Closer deadline → higher score |
| Blood type rarity | 0-20 | AB-=20, B-/A-=15, O-=10, AB+=8, others=3-5 |
| Units needed | 0-10 | 2 points per unit, capped at 10 |

### Fields Updated
```json
{
  "candidateDonors": ["uid1", "uid2", "uid3", "uid4", "uid5"],
  "urgencyScore": 75,
  "status": "matching"  // or "no_match" if none found
}
```

---

## 2. `onDonorAccept`

**Type**: Firestore Trigger (onUpdate)
**Document**: `/requests/{requestId}`
**File**: `functions/src/matching/onDonorAccept.js`

### Trigger Condition
Fires when `status` changes to `'matched'` AND `matchedDonorId` is set.

### What It Does
1. Reads donor location from `/users/{donorId}`
2. Estimates ETA (distance × 2.5 min/km for city driving)
3. Updates request status to `'en_route'` with ETA
4. Sends FCM notification to patient: "Donor found! ETA: X min"

### Fields Updated
```json
{
  "etaMinutes": 15,
  "status": "en_route"
}
```

---

## 3. `escalationScheduler`

**Type**: Cloud Scheduler
**Schedule**: Every 10 minutes
**File**: `functions/src/scheduling/escalation.js`

### What It Does
1. Queries requests stuck in `'pending'` or `'matching'` for > 30 minutes
2. Increments `escalationLevel` (0 → 1 → 2)
3. Level 1: Notifies nearby blood banks
4. Level 2: Escalates to state reserves (NBTC API)

---

## 4. `demandForecast`

**Type**: Cloud Scheduler
**Schedule**: Daily at 2:00 AM IST
**File**: `functions/src/ai/demandForecast.js`

### What It Does
1. Aggregates last 30 days of request data
2. Groups by blood group
3. Computes daily average and weighted moving average
4. Generates 14-day forecast per blood group
5. Writes results to `/forecasts/latest`

### Output Document
```json
{
  "generatedAt": "Timestamp",
  "forecastDays": 14,
  "byBloodGroup": {
    "O+": {
      "last30dTotal": 45,
      "dailyAverage": 1.5,
      "forecast14d": [1.7, 1.7, 1.1, ...],
      "trend": "increasing"
    }
  },
  "model": "simple_moving_avg"
}
```

---

## 5. `notificationOrchestrator`

**Type**: Pub/Sub Trigger
**Topic**: `notif-events`
**File**: `functions/src/notifications/orchestrator.js`

### Input Message
```json
{
  "userId": "uid",
  "type": "match_found | reminder | escalation | broadcast",
  "title": "Blood Request Nearby",
  "body": "O+ blood needed at City Hospital",
  "data": { "requestId": "abc123" }
}
```

### Routing Logic
| Notification Type | FCM | SMS | Email |
|-------------------|-----|-----|-------|
| `emergency` | ✅ | ✅ | ❌ |
| `escalation` | ✅ | ✅ | ❌ |
| `match_found` | ✅ | ❌ | ❌ |
| `reminder` | ✅ | ❌ | ✅ |
| `broadcast` | ✅ | ❌ | ✅ |

---

## 6. `donationCooldownCheck`

**Type**: Firestore Trigger (onUpdate)
**Document**: `/users/{userId}`
**File**: `functions/src/scheduling/donationCooldown.js`

### Trigger Condition
Fires when `lastDonated` field value changes.

### What It Does
1. Sets `isAvailable = false`
2. Sets `availabilityMode = 'off_duty'`
3. (Production) Schedules Cloud Task to re-enable after 56 days

---

## 7. `donorEligibilityChat`

**Type**: HTTPS Callable
**Auth Required**: Yes
**File**: `functions/src/ai/eligibilityChat.js`

### Request
```json
{
  "data": {
    "message": "Can I donate blood if I have diabetes?",
    "lang": "en"
  }
}
```

### Response
```json
{
  "result": {
    "reply": "If you have well-controlled Type 2 diabetes..."
  }
}
```

### Supported Languages
`en`, `hi`, `ta`, `te`, `kn`, `ml`, `mr`, `gu`, `bn`, `pa`, `or`, `as`

---

## 8. `campCertificateGen`

**Type**: HTTPS Callable
**Auth Required**: Yes
**File**: `functions/src/camps/certificateGenerator.js`

### Request
```json
{
  "data": {
    "campId": "camp123",
    "volunteerId": "user456",
    "volunteerName": "Priya Sharma"
  }
}
```

### Response
```json
{
  "result": {
    "certificateUrl": "https://storage.googleapis.com/...",
    "campTitle": "Community Blood Drive",
    "volunteerName": "Priya Sharma",
    "date": "2025-03-15T10:00:00Z"
  }
}
```

---

## 9. `inventorySync`

**Type**: Pub/Sub Trigger
**Topic**: `hospital-inventory-events`
**File**: `functions/src/inventory/inventorySync.js`

### Input Message
```json
{
  "bankId": "bank123",
  "inventory": { "A+": 12, "O-": 3, "B+": 8 },
  "timestamp": "2025-03-15T10:00:00Z"
}
```

---

## 10. `leaderboardUpdater`

**Type**: Cloud Scheduler
**Schedule**: Every 60 minutes
**File**: `functions/src/leaderboard/leaderboardUpdater.js`

### What It Does
1. Queries top 100 donors by `totalDonations` (descending)
2. Batch writes to `/leaderboard/rank_1` through `/leaderboard/rank_100`
3. Respects `anonymousDonation` flag for display names
