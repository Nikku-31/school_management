import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/AttendanceM/attendance_model.dart';

class AttendanceService {
  Future<AttendanceModel?> getAttendance(
      int studentId, String date) async {
    final url = "https://login.amarshikshasadan.com/api/StudentApi/GetStudentAttendance?studentId=$studentId&date=$date";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AttendanceModel.fromJson(data);
    } else {
      return null;
    }
  }
}
