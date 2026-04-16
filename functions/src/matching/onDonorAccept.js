/**
 * onDonorAccept — Donor Match Confirmation
 *
 * Firestore trigger: fires when a request is updated with a matched donor.
 * 1. Confirms the match
 * 2. Calls Directions API for ETA
 * 3. Notifies the patient
 * 4. Starts ETA polling
 */

const { onDocumentUpdated } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const https = require('https');

const onDonorAccept = onDocumentUpdated(
  {
    document: 'requests/{requestId}',
    region: 'asia-south1',
  },
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    // Only trigger when status changes to 'matched'
    if (before.status === 'matched' || after.status !== 'matched') return;
    if (!after.matchedDonorId) return;

    const db = admin.firestore();

    // Get donor location for ETA calculation
    const donorDoc = await db
      .collection('users')
      .doc(after.matchedDonorId)
      .get();

    if (!donorDoc.exists) return;

    const donor = donorDoc.data();
    const hospitalGeo = after.hospital?.geopoint;

    let etaMinutes = null;

    // Calculate ETA via Directions API (if locations available)
    if (donor.location && hospitalGeo) {
      // In production, call Google Directions API here
      // For now, estimate based on distance
      const dist = distanceKm(donor.location, hospitalGeo);
      etaMinutes = Math.ceil(dist * 2.5); // ~2.5 min per km (city driving)
    }

    // Update request with ETA
    await event.data.after.ref.update({
      etaMinutes: etaMinutes,
      status: 'en_route',
    });

    // Notify patient
    const requesterDoc = await db
      .collection('users')
      .doc(after.requesterId)
      .get();

    if (requesterDoc.exists && requesterDoc.data().fcmToken) {
      await admin.messaging().send({
        token: requesterDoc.data().fcmToken,
        notification: {
          title: '✅ Donor Found!',
          body: `A ${after.bloodGroup} donor is on the way. ETA: ${etaMinutes || '~'} minutes`,
        },
        data: {
          type: 'match',
          requestId: event.params.requestId,
        },
      });
    }

    console.log(
      `Request ${event.params.requestId}: donor ${after.matchedDonorId} accepted, ETA=${etaMinutes}min`
    );
  }
);

function toRad(deg) {
  return (deg * Math.PI) / 180;
}

function distanceKm(p1, p2) {
  const R = 6371;
  const dLat = toRad(p2.latitude - p1.latitude);
  const dLon = toRad(p2.longitude - p1.longitude);
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(p1.latitude)) *
      Math.cos(toRad(p2.latitude)) *
      Math.sin(dLon / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

module.exports = { onDonorAccept };
