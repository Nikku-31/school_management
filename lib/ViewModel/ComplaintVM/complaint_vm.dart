import 'package:flutter/material.dart';
import '../../AppManager/Services/complaintS/complaint_service.dart';
import '../../Model/ComplaintM/complaint_model.dart';


class ComplaintVM extends ChangeNotifier {

  final ComplaintService _service = ComplaintService();

  List<ComplaintModel> complaintList = [];
  bool isLoading = false;

  Future<void> fetchComplaints(int studentId) async {

    isLoading = true;
    notifyListeners();

    try {
      complaintList = await _service.getComplaints(studentId);
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}