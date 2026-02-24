import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/FeeM/fee_recevieM.dart';

class FeeService {

  Future<List<FeeModel>> fetchFees(int admNo) async {

    final uri = Uri.parse(
        "https://login.amarshikshasadan.com/api/FeeApi/FeeReceivedSummary"
    ).replace(queryParameters: {
      "addmissionNo": admNo.toString(),
    });

    print("REQUEST URI: $uri");

    final response = await http.get(uri);

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      print("LIST LENGTH: ${data.length}");

      return data
          .map<FeeModel>((e) => FeeModel.fromJson(e))
          .toList();

    } else {
      throw Exception("API Failed");
    }
  }
}
