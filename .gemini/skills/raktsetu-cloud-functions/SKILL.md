---
name: raktsetu-cloud-functions
description: Cloud Functions development skill for RaktSetu — function patterns, triggers, testing, deployment, and monitoring.
---

# RaktSetu Cloud Functions Skill

## Purpose
Patterns and best practices for developing Firebase Cloud Functions in RaktSetu.

---

## Function Types

### 1. Firestore Trigger (onCreate)
```javascript
const { onDocumentCreated } = require('firebase-functions/v2/firestore');

exports.onSomethingCreated = onDocumentCreated(
  { document: 'collection/{docId}', region: 'asia-south1' },
  async (event) => {
    const data = event.data.data();
    // Business logic
  }
);
```

### 2. Firestore Trigger (onUpdate)
```javascript
const { onDocumentUpdated } = require('firebase-functions/v2/firestore');

exports.onSomethingUpdated = onDocumentUpdated(
  { document: 'collection/{docId}', region: 'asia-south1' },
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();
    // Only act on specific field changes
  }
);
```

### 3. HTTPS Callable
```javascript
const { onCall, HttpsError } = require('firebase-functions/v2/https');

exports.myFunction = onCall(
  { region: 'asia-south1' },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required.');
    const { param } = request.data;
    // Business logic
    return { result: 'success' };
  }
);
```

### 4. Pub/Sub Trigger
```javascript
const { onMessagePublished } = require('firebase-functions/v2/pubsub');

exports.myPubSubFn = onMessagePublished(
  { topic: 'my-topic', region: 'asia-south1' },
  async (event) => {
    const message = event.data.message.json;
    // Process message
  }
);
```

### 5. Scheduled (Cron)
```javascript
const { onSchedule } = require('firebase-functions/v2/scheduler');

exports.myScheduledFn = onSchedule(
  { schedule: 'every 60 minutes', timeZone: 'Asia/Kolkata', region: 'asia-south1' },
  async (event) => {
    // Periodic task
  }
);
```

---

## Best Practices

1. **Always set `region: 'asia-south1'`** — Minimize latency for Indian users
2. **Single responsibility** — One function does one thing
3. **Idempotent** — Functions may retry; handle duplicate execution
4. **Error handling** — Always try/catch, log errors with `console.error`
5. **No secrets in code** — Use `defineSecret()` or Secret Manager
6. **Batch Firestore writes** — Use `batch` or `bulkWriter` for >1 write
7. **Set `maxInstances`** — Prevent runaway scaling

---

## Local Testing

```bash
cd functions

# Run lint
npm run lint

# Start emulators
npm run serve

# Interactive shell
npm run shell

# Unit tests
npm test
```

---

## Deployment

```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:onRequestCreated

# View logs
firebase functions:log --only onRequestCreated --follow
```

---

## Directory Structure

```
functions/
├── index.js                  # Main exports
├── package.json              # Dependencies
└── src/
    ├── matching/             # Donor-patient matching
    │   ├── onRequestCreated.js
    │   └── onDonorAccept.js
    ├── scoring/              # Urgency score calculation
    │   └── urgencyCalculator.js
    ├── notifications/        # FCM/SMS/Email routing
    │   └── orchestrator.js
    ├── ai/                   # Gemini & Vertex AI
    │   ├── eligibilityChat.js
    │   └── demandForecast.js
    ├── scheduling/           # Timers & cooldowns
    │   ├── escalation.js
    │   └── donationCooldown.js
    ├── camps/                # Blood camp operations
    │   └── certificateGenerator.js
    ├── inventory/            # Hospital ERP sync
    │   └── inventorySync.js
    └── leaderboard/          # Gamification
        └── leaderboardUpdater.js
```
