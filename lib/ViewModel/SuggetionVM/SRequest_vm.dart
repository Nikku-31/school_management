import 'package:flutter/material.dart';
import '../../Model/SuggetionM/SRequest_model.dart';
import '../../AppManager/Services/SuggetionTable/SRequest_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SRequestVM extends ChangeNotifier {
  final SRequestService _service = SRequestService();

  bool isLoading = false;
  String message = "";
  Future<bool> submitSuggestion({
    required String title,
    required String category,
    required String remarks,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final int admissionNo = prefs.getInt('add_no') ?? 0;
      debugPrint("Fetched AdmissionNo In Suggestion: $admissionNo");
      final now = DateTime.now();
      final model = SRequestModel(
        createdBy: 0,
        createdDate: now.toIso8601String(),
        modifiedBy: 0,
        modifiedDate: now.toIso8601String(),
        suggestionId: 0,
        appNo: admissionNo, 
        date: now.toString().split(' ')[0],
        title: title,
        category: category,
        remarks: remarks,
      );

      final response = await _service.insertSuggestion(model);

      if (response["succeeded"] == true) {
        message = response["message"] ?? "Suggestion Saved";
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        message = "Something went wrong";
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      message = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}