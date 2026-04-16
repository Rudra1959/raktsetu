/**
 * Notification Orchestrator
 *
 * Pub/Sub trigger: routes notifications to FCM/SMS/Email
 * based on user preferences and device availability.
 */

const { onMessagePublished } = require('firebase-functions/v2/pubsub');
const admin = require('firebase-admin');

const notificationOrchestrator = onMessagePublished(
  {
    topic: 'notif-events',
    region: 'asia-south1',
  },
  async (event) => {
    const message = event.data.message.json;
    const { userId, type, title, body, data } = message;

    const db = admin.firestore();
    const userDoc = await db.collection('users').doc(userId).get();

    if (!userDoc.exists) return;

    const user = userDoc.data();
    const channels = [];

    // 1. Always try FCM push notification
    if (user.fcmToken) {
      try {
        await admin.messaging().send({
          token: user.fcmToken,
          notification: { title, body },
          data: data || {},
          android: { priority: 'high' },
        });
        channels.push('fcm');
      } catch (err) {
        console.error(`FCM failed for ${userId}:`, err.message);
      }
    }

    // 2. SMS fallback for critical notifications
    if (type === 'emergency' || type === 'escalation') {
      // Integration point: Twilio SMS
      // await sendSMS(user.phone, `${title}: ${body}`);
      channels.push('sms');
      console.log(`SMS would be sent to ${user.phone}`);
    }

    // 3. Email for non-urgent notifications
    if (type === 'reminder' || type === 'broadcast') {
      // Integration point: Gmail API
      // await sendEmail(user.email, title, body);
      if (user.email) channels.push('email');
    }

    // 4. Store notification record in Firestore
    await db.collection('notifications').add({
      userId,
      type,
      title,
      body,
      channel: channels,
      sentAt: admin.firestore.FieldValue.serverTimestamp(),
      read: false,
      payload: data || {},
    });

    console.log(`Notification sent to ${userId} via: ${channels.join(', ')}`);
  }
);

module.exports = { notificationOrchestrator };
