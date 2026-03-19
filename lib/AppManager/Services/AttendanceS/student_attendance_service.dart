import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/AttendanceM/student_attandance_model.dart';

class StudentAttendanceService {
  static const String baseUrl =
      "https://login.amarshikshasadan.com/api/StudentApi/studentAttendanceStatus";

  static Future<List<StudentAttendanceStatusModel>> fetchAttendanceStatus({
    required int studentId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {

    final url =
        "$baseUrl?studentId=$studentId&fromDate=${_formatDate(fromDate)}&toDate=${_formatDate(toDate)}";

    print("Range Attendance API: $url");

    final response = await http.get(Uri.parse(url));

    print("Response Body: ${response.body}");   // 👈 Debug ke liye add karo

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((e) => StudentAttendanceStatusModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load attendance status");
    }
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }
}