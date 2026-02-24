import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/ComplaintM/complaint_model.dart';

class ComplaintService {

  Future<List<ComplaintModel>> getComplaints(int studentId) async {

    final url = Uri.parse(
        "https://login.amarshikshasadan.com/api/MasterApi/GetComplaintByStudentIdAndDate?studentId=$studentId");
    print("Request URL: $url");

    final response = await http.get(url);

    print("Complaint API Status: ${response.statusCode}");
    print("Complaint API Body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((e) => ComplaintModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load complaints");
    }
  }
}