import 'package:flutter/material.dart';

import '../../AppManager/Services/AccountS/get_student_info_service.dart';
import '../../Model/AccountM/student_info_model.dart';

class StudentDetailViewModel extends ChangeNotifier {
  final StudentDetailService _service = StudentDetailService();

  StudentDetailModel? student;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getStudentDetails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      student = await _service.fetchStudentInfo();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}