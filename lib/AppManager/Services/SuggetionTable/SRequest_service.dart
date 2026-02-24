import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/SuggetionM/SRequest_model.dart';

class SRequestService {
  static const String url =
      "https://login.amarshikshasadan.com/api/FeeApi/InsertSuuestion";

  Future<Map<String, dynamic>> insertSuggestion(
      SRequestModel model) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(model.toJson()),
      );
      print("Request URL: $url");
      print("Request Body: ${jsonEncode(model.toJson())}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to insert suggestion");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}