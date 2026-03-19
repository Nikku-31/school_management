import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/AccountM/send_login_model.dart';

class SendLoginService {
  static const String _url = "https://login.amarshikshasadan.com/api/AuthApi/login";

  static Future<SendLoginResponse> login(
      SendLoginRequest request) async {

    // ✅ Request body me set kar rahe hain (logic same hai)

    final uri = Uri.parse(_url);
    print(" LOGIN API URL: $uri");
    print("REQUEST BODY: ${jsonEncode(request.toJson())}");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("🔹 STATUS CODE: ${response.statusCode}");
    print("🔹 RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      return SendLoginResponse.fromJson(
        jsonDecode(response.body), // ✅ FIX
      );
    } else {
      throw Exception("Login failed");
    }
  }
}