import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for interacting with the Gemini-powered eligibility chatbot.
/// Calls Cloud Functions endpoint that wraps the Vertex AI Gemini API.
class GeminiService {
  final String _functionsBaseUrl;

  GeminiService({required String functionsBaseUrl})
      : _functionsBaseUrl = functionsBaseUrl;

  /// Send a message to the eligibility chatbot.
  /// [message] is the user's question about blood donation eligibility.
  /// [lang] is the language code (e.g., 'en', 'hi', 'ta', 'te').
  /// Returns the chatbot's response text.
  Future<String> askEligibility({
    required String message,
    String lang = 'en',
    required String idToken,
  }) async {
    final url = Uri.parse('$_functionsBaseUrl/donorEligibilityChat');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'data': {
          'message': message,
          'lang': lang,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Chatbot error: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    return data['result']['reply'] ?? 'Sorry, I could not process your question.';
  }

  /// Get demand forecast summary for a city.
  Future<Map<String, dynamic>?> getDemandForecast({
    required String city,
    required String idToken,
  }) async {
    final url = Uri.parse('$_functionsBaseUrl/getDemandForecast');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode({
        'data': {'city': city},
      }),
    );

    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    return data['result'] as Map<String, dynamic>?;
  }

  /// Supported languages for the eligibility chatbot.
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'हिन्दी (Hindi)',
    'ta': 'தமிழ் (Tamil)',
    'te': 'తెలుగు (Telugu)',
    'kn': 'ಕನ್ನಡ (Kannada)',
    'ml': 'മലയാളം (Malayalam)',
    'mr': 'मराठी (Marathi)',
    'gu': 'ગુજરાતી (Gujarati)',
    'bn': 'বাংলা (Bengali)',
    'pa': 'ਪੰਜਾਬੀ (Punjabi)',
    'or': 'ଓଡ଼ିଆ (Odia)',
    'as': 'অসমীয়া (Assamese)',
  };
}
