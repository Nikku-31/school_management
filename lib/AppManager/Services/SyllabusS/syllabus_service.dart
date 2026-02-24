import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/SyllabusM/syllabus_model.dart';

class SyllabusService {
  Future<List<SyllabusModel>> getSyllabus(int classId) async {

    final url = Uri.parse(
      "https://login.amarshikshasadan.com/api/StudentApi/GetSyllabusByClass?classId=$classId",
    );

    print("Request URL: $url");

    final response = await http.get(url);

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => SyllabusModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load syllabus");
    }
  }
}
