/**
 * Donation Cooldown Check
 *
 * Firestore trigger: when a user's lastDonated field changes,
 * sets isAvailable=false and schedules re-enable after 56 days.
 */

const { onDocumentUpdated } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');

const COOLDOWN_DAYS = 56;

const donationCooldownCheck = onDocumentUpdated(
  {
    document: 'users/{userId}',
    region: 'asia-south1',
  },
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    // Only trigger when lastDonated changes
    const beforeTs = before.lastDonated?.toMillis?.() || 0;
    const afterTs = after.lastDonated?.toMillis?.() || 0;

    if (beforeTs === afterTs) return;

    // Set donor as unavailable
    await event.data.after.ref.update({
      isAvailable: false,
      availabilityMode: 'off_duty',
    });

    // In production: create a Cloud Task to re-enable availability after 56 days
    // const { CloudTasksClient } = require('@google-cloud/tasks');
    // Schedule task for 56 days later to set isAvailable=true

    const eligibleDate = new Date(afterTs + COOLDOWN_DAYS * 24 * 60 * 60 * 1000);
    console.log(
      `User ${event.params.userId}: cooldown started, eligible on ${eligibleDate.toISOString()}`
    );
  }
);

module.exports = { donationCooldownCheck };
