import 'package:flutter/material.dart';
import '../../AppManager/Services/FeeS/fee_pending_service.dart';
import '../../Model/FeeM/fee_pending_model.dart';

class PendingVM extends ChangeNotifier {

  final PendingService _service = PendingService();

  List<PendingModel> pendingList = [];
  bool loading = false;

  int get totalMonthlyFee =>
      pendingList.fold(0, (sum, e) => sum + e.monthlyFee);

  Future<void> getPending(int admNo) async {
    try {
      loading = true;
      notifyListeners();

      pendingList = await _service.fetchPending(admNo);

      print("VM LENGTH: ${pendingList.length}");

    } catch (e) {
      print("ERROR: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}