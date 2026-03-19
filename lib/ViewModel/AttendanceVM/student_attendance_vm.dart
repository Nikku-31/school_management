import 'package:flutter/material.dart';
import '../../AppManager/Services/AttendanceS/student_attendance_service.dart';
import '../../Model/AttendanceM/student_attandance_model.dart';
class StudentAttendanceStatusViewModel extends ChangeNotifier {
  List<StudentAttendanceStatusModel> attendanceList = [];
  bool isLoading = false;

  Future<void> fetchRangeAttendance(
      int studentId,
      DateTime fromDate,
      DateTime toDate,
      ) async {
    isLoading = true;
    notifyListeners();

    try {
      attendanceList =
      await StudentAttendanceService.fetchAttendanceStatus(
        studentId: studentId,
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// Calendar ke liye helper
  String? getStatusForDate(DateTime day) {

    for (var item in attendanceList) {

      final apiDate = DateTime(
        item.date.year,
        item.date.month,
        item.date.day,
      );

      final calendarDate = DateTime(
        day.year,
        day.month,
        day.day,
      );

      if (apiDate == calendarDate) {

        // 🔥 Sunday rule
        if (day.weekday == DateTime.sunday) {

          // Sunday me sirf Leave show karo
          if (item.status == "L") {
            return "L";
          } else {
            return null;
          }
        }

        return item.status;
      }
    }

    return null;
  }
}