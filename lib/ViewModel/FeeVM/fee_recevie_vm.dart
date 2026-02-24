import 'dart:convert';

import 'package:flutter/material.dart';
import '../../AppManager/Services/FeeS/fee_recevie_service.dart';
import '../../Model/FeeM/fee_recevieM.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeeVM extends ChangeNotifier {
  final FeeService _service = FeeService();

  List<FeeModel> fees = [];
  bool loading = false;



  int get totalAmount =>
      fees.fold(0, (sum, item) => sum + item.totalFee);

  Future<void> getFees(int admNo) async {
    try {
      loading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      var StudentData = prefs.getString('student_data');
      // int? admissionNo = StudentData[""];


      if (StudentData != null) {
        var studentMap = jsonDecode(StudentData);

        admNo = studentMap['admissionNo']; // ya 'studentName' key

      }



      fees = await _service.fetchFees(admNo);

      print("FEES LENGTH: ${fees.length}");
    } catch (e) {
      print("ERROR: $e");
    } finally {
      // ✅ MOST IMPORTANT
      loading = false;
      notifyListeners();
    }
  }
}
