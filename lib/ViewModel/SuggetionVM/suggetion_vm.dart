import 'package:flutter/material.dart';
import '../../Model/SuggetionM/suggetion_model.dart';
import '../../AppManager/Services/SuggetionTable/suggetion_service.dart';

class SuggetionVM extends ChangeNotifier {
  final SuggetionService _service = SuggetionService();

  List<SuggetionModel> _suggetions = [];
  bool _isLoading = false;

  List<SuggetionModel> get suggetions => _suggetions;
  bool get isLoading => _isLoading;

  Future<void> getAllSuggetions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _suggetions = await _service.fetchSuggetions();
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
  void deleteSuggestion(int id) {
    _suggetions.removeWhere(
            (element) => element.suggestionId == id);
    notifyListeners();
  }
}