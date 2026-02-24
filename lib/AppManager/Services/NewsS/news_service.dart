import 'package:http/http.dart' as http;

import '../../../Model/NewsM/news_model.dart';

class NewsService {
  static const String apiUrl = "https://login.amarshikshasadan.com/api/MasterApi/GetAllLatestNews";

  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return newsModelFromJson(response.body);
      } else {
        throw Exception("Failed to load news");
      }
    } catch (e) {
      throw Exception("Error fetching news: $e");
    }
  }
}