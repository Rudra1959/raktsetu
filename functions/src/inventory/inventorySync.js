/**
 * Inventory Sync — Hospital ERP Integration
 *
 * Pub/Sub trigger: receives hospital ERP webhook events,
 * updates blood bank inventory in Firestore.
 */

const { onMessagePublished } = require('firebase-functions/v2/pubsub');
const admin = require('firebase-admin');

const inventorySync = onMessagePublished(
  {
    topic: 'hospital-inventory-events',
    region: 'asia-south1',
  },
  async (event) => {
    const message = event.data.message.json;
    const { bankId, inventory, timestamp } = message;

    if (!bankId || !inventory) {
      console.error('Invalid inventory sync message:', message);
      return;
    }

    const db = admin.firestore();

    await db.collection('bloodBanks').doc(bankId).update({
      inventory,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`Inventory synced for blood bank ${bankId}`);
  }
);

module.exports = { inventorySync };
