import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/search_model.dart';

class showSearchNews {
  List<SearchModel> searches = [];

  Future<void> getSearchNews(String searchQuery) async {
    String url = "https://newsapi.org/v2/everything?q=$searchQuery&from=2023-12-22&to=2023-12-22&sortBy=popularity&apiKey=28fa55f66228405ea2866e573ccbd93d";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          SearchModel searchModel = SearchModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          searches.add(searchModel);
        }
      });
    }
  }
}