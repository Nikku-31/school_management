import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Model/SuggetionM/SD_model.dart';

class SDService {

  Future<SDModel> deleteSuggestion(int id) async {
    final url =  "https://login.amarshikshasadan.com/api/FeeApi/DeleteSuggestion?id=$id";
    print("Request URL: $url");

    final response = await http.delete(Uri.parse(url),
    );
    print("Status Code: ${response.statusCode}");




    if (response.statusCode == 200) {
      return SDModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to delete suggestion");
    }
  }
}