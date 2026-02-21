
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {

  static const String apiKey = "AIzaSyCFpYulL01xHCgl_Of84AWjrMXLQNQjYaM";

  static Future<Map<String, dynamic>> evaluateAbstract(String abstract) async {

    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$apiKey"
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": """
You are an expert hackathon judge.

Evaluate the following abstract and give score out of 100.

Return ONLY JSON format like:
{
  "score": 85
}

Abstract:
$abstract
"""
              }
            ]
          }
        ]
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Gemini API Failed");
    }

    final data = jsonDecode(response.body);

    final text =
    data["candidates"][0]["content"]["parts"][0]["text"];

    final jsonStart = text.indexOf("{");
    final jsonEnd = text.lastIndexOf("}") + 1;

    if (jsonStart == -1 || jsonEnd == -1) {
      throw Exception("Invalid Gemini JSON");
    }

    final jsonString = text.substring(jsonStart, jsonEnd);

    final result = jsonDecode(jsonString);

    return {
      "score": result["score"] ?? 50,
    };
  }
}