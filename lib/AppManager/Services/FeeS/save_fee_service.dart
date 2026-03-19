import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../Model/FeeM/save_fee_model.dart';

class SaveFeeService {
  static Future<String?> saveFee(SaveFeeRequest request) async {
    final url = Uri.parse('https://login.amarshikshasadan.com/api/FeeApi/SaveFeeCollection');
    final requestBody = jsonEncode(request.toJson());

    debugPrint("URI: $url");
    debugPrint("PAYLOAD: $requestBody");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: requestBody,
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Return the redirect URL provided by the API
          return data['redirectUrl'] as String?;
        }
      }
      return null;
    } catch (e) {
      debugPrint("EXCEPTION: $e");
      return null;
    }
  }
}