import 'package:flutter/material.dart';
import '../../AppManager/Services/FeeS/save_fee_service.dart';
import '../../Model/FeeM/save_fee_model.dart';

class SaveFeeViewModel extends ChangeNotifier {
  bool isSaving = false;

  Future<String?> postFee(SaveFeeRequest request) async {
    isSaving = true;
    notifyListeners();

    // Call service and get the URL
    String? redirectUrl = await SaveFeeService.saveFee(request);

    isSaving = false;
    notifyListeners();
    return redirectUrl;
  }
}