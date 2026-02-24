import 'package:flutter/material.dart';
import '../../AppManager/Services/SuggetionTable/SD_service.dart';

class SDVM extends ChangeNotifier {

  final SDService _service = SDService();
  bool isDeleting = false;

  Future<bool> deleteSuggestion(int id) async {

    isDeleting = true;
    notifyListeners();

    try {
      final response = await _service.deleteSuggestion(id);

      isDeleting = false;
      notifyListeners();

      return response.succeeded;

    } catch (e) {
      isDeleting = false;
      notifyListeners();
      return false;
    }
  }
}