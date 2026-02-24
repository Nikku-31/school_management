import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/SuggetionM/suggetion_model.dart';

class SuggetionService {
  Future<List<SuggetionModel>> fetchSuggetions() async {

    final url = "https://login.amarshikshasadan.com/api/FeeApi/GetAllSuggestion";

    print("Request URL: $url");

    final response = await http.get(
      Uri.parse(url),
    );
    print("Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => SuggetionModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load suggestions");
    }
  }
}