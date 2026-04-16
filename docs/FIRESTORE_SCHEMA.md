# RaktSetu — Firestore Schema Reference

> Complete field-level documentation for all Firestore collections.

---

## Collection: `/users/{userId}`

Stores all user profiles — donors, patients, and hospital administrators.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `uid` | `string` | ✅ | Firebase Auth UID (matches document ID) |
| `name` | `string` | ✅ | Full name |
| `phone` | `string` | ✅ | Phone with country code (+91XXXXXXXXXX) |
| `email` | `string` | ❌ | Email address |
| `role` | `string` | ✅ | `"donor"` \| `"patient"` \| `"hospital_admin"` |
| `bloodGroup` | `string` | ✅ | `"A+"` \| `"A-"` \| `"B+"` \| `"B-"` \| `"O+"` \| `"O-"` \| `"AB+"` \| `"AB-"` |
| `rhFactor` | `string` | ❌ | `"+"` or `"-"` (redundant with bloodGroup, for legacy) |
| `location` | `GeoPoint` | ❌ | Current latitude/longitude |
| `city` | `string` | ❌ | City name |
| `state` | `string` | ❌ | State name |
| `isAvailable` | `boolean` | ✅ | Whether donor is available for requests |
| `availabilityMode` | `string` | ❌ | `"on_duty"` \| `"off_duty"` \| `"traveling"` |
| `lastDonated` | `Timestamp` | ❌ | Date of most recent donation |
| `totalDonations` | `number` | ✅ | Lifetime donation count |
| `badges` | `string[]` | ❌ | Gamification badges earned |
| `healthScore` | `number` | ❌ | Health score (0-100) |
| `preferredRadiusKm` | `number` | ❌ | Max donation travel radius (default: 10) |
| `anonymousDonation` | `boolean` | ❌ | Hide name from patient (default: false) |
| `profilePhotoUrl` | `string` | ❌ | Cloud Storage URL |
| `hemoglobinLevel` | `number` | ❌ | Last recorded hemoglobin (g/dL) |
| `medicalConditions` | `string[]` | ❌ | Known medical conditions |
| `medications` | `string[]` | ❌ | Current medications |
| `fcmToken` | `string` | ❌ | Firebase Cloud Messaging device token |
| `createdAt` | `Timestamp` | ✅ | Account creation timestamp |

### Indexes Required
- `role` + `isAvailable` + `bloodGroup` (matching query)
- `role` + `city` + `totalDonations` DESC (leaderboard)

---

## Collection: `/requests/{requestId}`

Blood request documents with full lifecycle tracking.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `requesterId` | `string` | ✅ | UID of user who created request |
| `patientName` | `string` | ✅ | Patient's name |
| `bloodGroup` | `string` | ✅ | Required blood group |
| `units` | `number` | ✅ | Number of blood units needed (1-10) |
| `urgencyScore` | `number` | ✅ | Computed urgency (0-100), set by Cloud Function |
| `condition` | `string` | ✅ | `"critical"` \| `"urgent"` \| `"standard"` |
| `hospital` | `map` | ✅ | Hospital details (see sub-fields below) |
| `hospital.name` | `string` | ✅ | Hospital name |
| `hospital.address` | `string` | ❌ | Hospital address |
| `hospital.geopoint` | `GeoPoint` | ❌ | Hospital coordinates |
| `status` | `string` | ✅ | Current status (see status flow below) |
| `matchedDonorId` | `string` | ❌ | UID of confirmed donor |
| `candidateDonors` | `string[]` | ❌ | Top-5 candidate donor UIDs |
| `etaMinutes` | `number` | ❌ | Estimated donor arrival time |
| `surgeryTime` | `Timestamp` | ❌ | Scheduled surgery time |
| `escalationLevel` | `number` | ✅ | 0 (normal) → 1 (blood banks) → 2 (state) |
| `notes` | `string` | ❌ | Additional notes from requester |
| `requestedAt` | `Timestamp` | ✅ | When request was created |
| `fulfilledAt` | `Timestamp` | ❌ | When request was fulfilled |

### Status Flow
```
pending → matching → matched → en_route → fulfilled
                  ↘ no_match (escalation)
          any state → cancelled
```

### Indexes Required
- `status` + `urgencyScore` DESC (priority queue)
- `requesterId` + `requestedAt` DESC (user history)
- `bloodGroup` + `status` + `urgencyScore` DESC (filtered queue)

---

## Collection: `/bloodBanks/{bankId}`

Verified blood bank profiles with live inventory.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | `string` | ✅ | Blood bank name |
| `license` | `string` | ❌ | License number |
| `location` | `GeoPoint` | ✅ | Coordinates |
| `phone` | `string` | ✅ | Contact number |
| `address` | `string` | ❌ | Full address |
| `inventory` | `map` | ✅ | Blood stock by group (see below) |
| `inventory.A+` | `number` | — | Units of A+ in stock |
| `inventory.A-` | `number` | — | Units of A- in stock |
| `inventory.B+` | `number` | — | Units of B+ in stock |
| `inventory.B-` | `number` | — | Units of B- in stock |
| `inventory.O+` | `number` | — | Units of O+ in stock |
| `inventory.O-` | `number` | — | Units of O- in stock |
| `inventory.AB+` | `number` | — | Units of AB+ in stock |
| `inventory.AB-` | `number` | — | Units of AB- in stock |
| `lastUpdated` | `Timestamp` | ✅ | Last inventory sync time |
| `isVerified` | `boolean` | ✅ | Admin-verified status |

---

## Collection: `/camps/{campId}`

Blood donation camps and drive events.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `organizerId` | `string` | ✅ | UID of camp organizer |
| `title` | `string` | ✅ | Camp/drive name |
| `date` | `Timestamp` | ✅ | Event date and time |
| `location` | `GeoPoint` | ❌ | Venue coordinates |
| `address` | `string` | ❌ | Venue address |
| `targetUnits` | `number` | ❌ | Goal units to collect |
| `collectedUnits` | `number` | ❌ | Actually collected |
| `rsvpCount` | `number` | ❌ | Number of RSVPs |
| `status` | `string` | ✅ | `"upcoming"` \| `"live"` \| `"completed"` |
| `description` | `string` | ❌ | Event description |
| `imageUrl` | `string` | ❌ | Event banner image URL |

---

## Collection: `/notifications/{notifId}`

Multi-channel notification records.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `userId` | `string` | ✅ | Recipient user ID |
| `type` | `string` | ✅ | `"match_found"` \| `"reminder"` \| `"escalation"` \| `"broadcast"` |
| `title` | `string` | ❌ | Notification title |
| `body` | `string` | ❌ | Notification body text |
| `channel` | `string[]` | ✅ | Channels used: `["fcm", "sms", "email"]` |
| `sentAt` | `Timestamp` | ✅ | When notification was sent |
| `read` | `boolean` | ✅ | Whether user has read it |
| `payload` | `map` | ❌ | Additional data (requestId, etc.) |

---

## Collection: `/forecasts/{forecastId}`

AI-generated demand predictions (written by `demandForecast` function).

| Field | Type | Description |
|-------|------|-------------|
| `generatedAt` | `Timestamp` | When forecast was generated |
| `forecastDays` | `number` | Number of days forecasted (14) |
| `byBloodGroup` | `map` | Forecast data per blood group |
| `model` | `string` | Model used (e.g., `"vertex_ai_automl"`) |

---

## Collection: `/leaderboard/{entryId}`

Pre-computed leaderboard entries (written by `leaderboardUpdater` function).

| Field | Type | Description |
|-------|------|-------------|
| `rank` | `number` | Leaderboard position (1-100) |
| `userId` | `string` | Donor user ID |
| `name` | `string` | Display name (or "Anonymous") |
| `bloodGroup` | `string` | Donor blood group |
| `totalDonations` | `number` | Lifetime donations |
| `city` | `string` | Donor city |
| `badges` | `string[]` | Earned badges |
| `updatedAt` | `Timestamp` | Last update time |
