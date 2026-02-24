import 'package:flutter/material.dart';
import '../../Model/HomeWorkM/hw_model.dart';
import '../../AppManager/Services/Home_WorkS/hw_service.dart';

class HwViewModel extends ChangeNotifier {
  final HwService _service = HwService();

  List<HwModel> _homeworks = [];
  List<HwModel> get homeworks => _homeworks;

  bool isLoading = false;

  Future<void> getHomework() async {
    try {
      isLoading = true;
      notifyListeners();

      _homeworks = await _service.fetchHomework();
    } catch (e) {
      print("ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<HwModel> filterByDate(DateTime selectedDate) {
    return _homeworks.where((hw) {
      return hw.date.year == selectedDate.year &&
          hw.date.month == selectedDate.month &&
          hw.date.day == selectedDate.day;
    }).toList();
  }
}
