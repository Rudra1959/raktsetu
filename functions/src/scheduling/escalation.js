/**
 * Escalation Scheduler
 *
 * Cloud Tasks trigger: checks for unmatched requests after 30 min.
 * Escalates to blood banks (level 1), then state reserves (level 2).
 */

const { onSchedule } = require('firebase-functions/v2/scheduler');
const admin = require('firebase-admin');

const escalationScheduler = onSchedule(
  {
    schedule: 'every 10 minutes',
    timeZone: 'Asia/Kolkata',
    region: 'asia-south1',
  },
  async (event) => {
    const db = admin.firestore();
    const thirtyMinAgo = new Date(Date.now() - 30 * 60 * 1000);

    // Find requests stuck in 'pending' or 'matching' for >30 min
    const staleRequests = await db
      .collection('requests')
      .where('status', 'in', ['pending', 'matching'])
      .where('requestedAt', '<=', admin.firestore.Timestamp.fromDate(thirtyMinAgo))
      .where('escalationLevel', '<', 2)
      .get();

    for (const doc of staleRequests.docs) {
      const req = doc.data();
      const newLevel = (req.escalationLevel || 0) + 1;

      // Escalate
      await doc.ref.update({
        escalationLevel: newLevel,
        status: 'pending', // Reset to pending for wider search
      });

      if (newLevel === 1) {
        // Level 1: Notify nearby blood banks
        console.log(`Escalating ${doc.id} to blood banks (level 1)`);
        // In production: query bloodBanks collection, send notifications
      } else if (newLevel === 2) {
        // Level 2: Notify state reserves
        console.log(`Escalating ${doc.id} to state reserves (level 2)`);
        // In production: trigger NBTC API integration
      }
    }

    if (!staleRequests.empty) {
      console.log(`Escalated ${staleRequests.size} stale requests`);
    }
  }
);

module.exports = { escalationScheduler };
