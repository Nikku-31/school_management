import 'package:flutter/material.dart';
import '../../Model/SyllabusM/syllabus_model.dart';
import '../../AppManager/Services/SyllabusS/syllabus_service.dart';

class SyllabusVM extends ChangeNotifier {

  final SyllabusService _service = SyllabusService();

  List<SyllabusModel> syllabusList = [];
  bool isLoading = false;
  String error = '';

  Future<void> fetchSyllabus(int classId) async {
    try {
      isLoading = true;
      notifyListeners();

      syllabusList = await _service.getSyllabus(classId);

    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
