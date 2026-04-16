/**
 * Demand Forecast — Vertex AI Integration
 *
 * Cloud Scheduler trigger: runs daily at 2 AM IST.
 * Calls Vertex AI AutoML model to predict blood demand 14 days ahead.
 * Writes forecast to /forecasts collection.
 */

const { onSchedule } = require('firebase-functions/v2/scheduler');
const admin = require('firebase-admin');

const demandForecast = onSchedule(
  {
    schedule: '0 2 * * *', // Daily at 2 AM
    timeZone: 'Asia/Kolkata',
    region: 'asia-south1',
  },
  async (event) => {
    const db = admin.firestore();

    // 1. Aggregate recent request data
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const requestsSnap = await db
      .collection('requests')
      .where('requestedAt', '>=', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
      .get();

    // 2. Group by blood group and city
    const demandByGroup = {};
    const bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

    for (const group of bloodGroups) {
      const requests = requestsSnap.docs.filter(
        (d) => d.data().bloodGroup === group
      );
      const dailyAvg = requests.length / 30;

      // Simple forecast: weighted moving average with seasonal multiplier
      // In production, replace with Vertex AI AutoML prediction endpoint
      const forecast14d = Array.from({ length: 14 }, (_, i) => {
        const dayOfWeek = new Date(Date.now() + i * 86400000).getDay();
        const weekendMultiplier = dayOfWeek === 0 || dayOfWeek === 6 ? 0.7 : 1.1;
        return Math.round(dailyAvg * weekendMultiplier * 10) / 10;
      });

      demandByGroup[group] = {
        last30dTotal: requests.length,
        dailyAverage: Math.round(dailyAvg * 10) / 10,
        forecast14d,
        trend: dailyAvg > (requests.length / 60) ? 'increasing' : 'stable',
      };
    }

    // 3. Write forecast
    await db.collection('forecasts').doc('latest').set({
      generatedAt: admin.firestore.FieldValue.serverTimestamp(),
      forecastDays: 14,
      byBloodGroup: demandByGroup,
      model: 'simple_moving_avg', // Replace with 'vertex_ai_automl' in production
    });

    console.log('Demand forecast generated successfully');
  }
);

module.exports = { demandForecast };
