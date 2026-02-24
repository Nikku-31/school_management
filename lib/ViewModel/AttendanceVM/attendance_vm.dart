import 'package:flutter/material.dart';
import '../../AppManager/Services/AttendanceS/attendance_service.dart';
import '../../Model/AttendanceM/attendance_model.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();

  AttendanceModel? attendance;
  bool isLoading = false;

  Future<void> fetchAttendance(
      int studentId, DateTime date) async {
    isLoading = true;
    notifyListeners();

    String formattedDate =
        "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";

    attendance =
    await _service.getAttendance(studentId, formattedDate);

    isLoading = false;
    notifyListeners();
  }
}
