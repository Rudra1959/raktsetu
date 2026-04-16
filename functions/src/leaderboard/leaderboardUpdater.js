/**
 * Leaderboard Updater
 *
 * Cloud Scheduler trigger: runs hourly.
 * Aggregates donation counts and updates leaderboard.
 */

const { onSchedule } = require('firebase-functions/v2/scheduler');
const admin = require('firebase-admin');

const leaderboardUpdater = onSchedule(
  {
    schedule: 'every 60 minutes',
    timeZone: 'Asia/Kolkata',
    region: 'asia-south1',
  },
  async (event) => {
    const db = admin.firestore();

    // Get top 100 donors by total donations
    const topDonors = await db
      .collection('users')
      .where('role', '==', 'donor')
      .orderBy('totalDonations', 'desc')
      .limit(100)
      .get();

    // Write to leaderboard collection
    const batch = db.batch();
    let rank = 1;

    for (const doc of topDonors.docs) {
      const data = doc.data();
      const leaderRef = db.collection('leaderboard').doc(`rank_${rank}`);

      batch.set(leaderRef, {
        rank,
        userId: doc.id,
        name: data.anonymousDonation ? 'Anonymous' : data.name,
        bloodGroup: data.bloodGroup,
        totalDonations: data.totalDonations,
        city: data.city || 'Unknown',
        badges: data.badges || [],
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      rank++;
    }

    await batch.commit();
    console.log(`Leaderboard updated: ${topDonors.size} entries`);
  }
);

module.exports = { leaderboardUpdater };
