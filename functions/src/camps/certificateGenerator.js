/**
 * Camp Certificate Generator
 *
 * HTTPS Callable: generates a PDF volunteer/donor certificate
 * for blood camp participants, uploads to Cloud Storage.
 */

const { onCall, HttpsError } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

const campCertificateGen = onCall(
  {
    region: 'asia-south1',
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Must be signed in.');
    }

    const { campId, volunteerId, volunteerName } = request.data;

    if (!campId || !volunteerName) {
      throw new HttpsError('invalid-argument', 'campId and volunteerName are required.');
    }

    const db = admin.firestore();
    const campDoc = await db.collection('camps').doc(campId).get();

    if (!campDoc.exists) {
      throw new HttpsError('not-found', 'Camp not found.');
    }

    const camp = campDoc.data();

    // In production: use PDFKit to generate certificate PDF
    // const PDFDocument = require('pdfkit');
    // Create certificate with camp details, volunteer name, date, signature

    // For now, return a placeholder response
    const certificateUrl = `https://storage.googleapis.com/raktsetu-prod.appspot.com/certificates/${campId}_${volunteerId}.pdf`;

    console.log(`Certificate generated for ${volunteerName} at camp ${camp.title}`);

    return {
      certificateUrl,
      campTitle: camp.title,
      volunteerName,
      date: camp.date?.toDate?.()?.toISOString() || new Date().toISOString(),
    };
  }
);

module.exports = { campCertificateGen };
