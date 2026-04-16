/**
 * onRequestCreated — Core Matching Engine
 *
 * Firestore trigger: fires when a new blood request document is created.
 * 1. Computes urgency score
 * 2. Finds compatible, available donors via geospatial query
 * 3. Ranks by distance (Haversine) within preferred radius
 * 4. Updates request with top-5 candidates
 * 5. Sends FCM notification to top candidate
 */

const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const { computeUrgency } = require('../scoring/urgencyCalculator');

// Haversine formula: distance in km between two GeoPoints
function toRad(deg) {
  return (deg * Math.PI) / 180;
}

function distanceKm(p1, p2) {
  const R = 6371; // Earth radius in km
  const dLat = toRad(p2.latitude - p1.latitude);
  const dLon = toRad(p2.longitude - p1.longitude);
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(p1.latitude)) *
      Math.cos(toRad(p2.latitude)) *
      Math.sin(dLon / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

/**
 * Send FCM notification to a donor about a blood request.
 */
async function sendFCMNotification(donorId, request) {
  const db = admin.firestore();
  const donorDoc = await db.collection('users').doc(donorId).get();

  if (!donorDoc.exists) return;

  const donor = donorDoc.data();
  if (!donor.fcmToken) return;

  try {
    await admin.messaging().send({
      token: donor.fcmToken,
      notification: {
        title: '🩸 Blood Request Nearby',
        body: `${request.patientName} needs ${request.bloodGroup} blood at ${request.hospital?.name || 'a hospital'}`,
      },
      data: {
        type: request.condition === 'critical' ? 'emergency' : 'match',
        requestId: request._requestId || '',
        bloodGroup: request.bloodGroup,
      },
      android: {
        priority: 'high',
        notification: {
          channelId: request.condition === 'critical'
            ? 'emergency_channel'
            : 'match_channel',
          sound: 'default',
        },
      },
    });
    console.log(`FCM sent to donor ${donorId}`);
  } catch (err) {
    console.error(`FCM failed for donor ${donorId}:`, err);
  }
}

const onRequestCreated = onDocumentCreated(
  {
    document: 'requests/{requestId}',
    region: 'asia-south1',
  },
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const req = snap.data();
    const db = admin.firestore();

    // 1. Compute urgency score
    const urgencyScore = computeUrgency(req);

    // 2. Find all available donors with matching blood group
    const donorsSnap = await db
      .collection('users')
      .where('role', '==', 'donor')
      .where('isAvailable', '==', true)
      .where('bloodGroup', '==', req.bloodGroup)
      .get();

    // 3. Rank by distance (nearest first)
    const hospitalGeo = req.hospital?.geopoint;
    let ranked = [];

    if (hospitalGeo && !donorsSnap.empty) {
      ranked = donorsSnap.docs
        .map((d) => {
          const data = d.data();
          if (!data.location) return null;
          return {
            id: d.id,
            ...data,
            dist: distanceKm(hospitalGeo, data.location),
          };
        })
        .filter((d) => d !== null && d.dist <= (d.preferredRadiusKm || 10))
        .sort((a, b) => a.dist - b.dist)
        .slice(0, 5); // Top 5 candidates
    }

    // 4. Update request with matches + urgency score
    await snap.ref.update({
      candidateDonors: ranked.map((d) => d.id),
      urgencyScore: urgencyScore,
      status: ranked.length > 0 ? 'matching' : 'no_match',
    });

    // 5. Send FCM to top candidate first
    if (ranked.length > 0) {
      req._requestId = event.params.requestId;
      await sendFCMNotification(ranked[0].id, req);
    }

    console.log(
      `Request ${event.params.requestId}: urgency=${urgencyScore}, donors=${ranked.length}`
    );
  }
);

module.exports = { onRequestCreated };
