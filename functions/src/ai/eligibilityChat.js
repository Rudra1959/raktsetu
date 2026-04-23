/**
 * Donor Eligibility Chatbot — Gemini API
 *
 * HTTPS Callable: wraps Vertex AI Gemini API for
 * blood donation eligibility Q&A in 12 Indian languages.
 */

const { onCall, HttpsError } = require('firebase-functions/v2/https');

const SYSTEM_INSTRUCTION =
  'You are a blood donation eligibility assistant for India. ' +
  'You help users understand if they can donate blood based on Indian ' +
  'guidelines (NBTC/Red Cross). ' +
  'Answer accurately and concisely. ' +
  'If the user asks about non-blood-donation topics, politely redirect them. ' +
  'Key eligibility criteria: age 18-65, weight ≥45kg, hemoglobin ≥12.5 g/dL, ' +
  'no recent surgery (6 months), no tattoo (12 months), ' +
  '56-day gap between whole blood donations. ' +
  'Always recommend consulting a doctor for specific medical conditions.';

let cachedModel;

function getModel() {
  if (cachedModel) {
    return cachedModel;
  }

  const { VertexAI } = require('@google-cloud/vertexai');
  const vertexAI = new VertexAI({
    project: process.env.GCP_PROJECT || 'raktsetu-prod',
    location: process.env.GCP_REGION || 'asia-south1',
  });

  cachedModel = vertexAI.getGenerativeModel({
    model: 'gemini-2.0-flash-exp',
  });
  return cachedModel;
}

const donorEligibilityChat = onCall(
  {
    region: 'asia-south1',
    maxInstances: 20,
  },
  async (request) => {
    // Auth check
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Must be signed in.');
    }

    const { message, lang = 'en' } = request.data;

    if (!message || message.trim().length === 0) {
      throw new HttpsError('invalid-argument', 'Message is required.');
    }

    try {
      const model = getModel();
      const result = await model.generateContent({
        contents: [
          {
            role: 'user',
            parts: [
              {
                text:
                  `You are a blood donation eligibility assistant for India. ` +
                  `Answer in ${lang}. Question: ${message}`,
              },
            ],
          },
        ],
        systemInstruction: SYSTEM_INSTRUCTION,
      });

      const reply =
        result.response.candidates?.[0]?.content?.parts?.[0]?.text ||
        'Sorry, I could not process your question. Please try again.';

      return { reply };
    } catch (err) {
      console.error('Gemini API error:', err);
      throw new HttpsError('internal', 'AI service temporarily unavailable.');
    }
  }
);

module.exports = { donorEligibilityChat };
