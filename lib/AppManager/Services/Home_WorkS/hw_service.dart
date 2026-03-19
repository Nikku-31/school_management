import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/HomeWorkM/hw_model.dart';

class HwService {
  Future<List<HwModel>> fetchHomework() async {
    final uri = Uri.parse(
        "https://login.amarshikshasadan.com/api/StudentApi/GetStudentHomework?classId=1&SectionId=1&Date=2026-02-25T00%3A00%3A00");

    print("REQUEST URL: $uri");

    final response = await http.get(uri);

    print("RESPONSE STATUS: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => HwModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load homework");
    }
  }
}
