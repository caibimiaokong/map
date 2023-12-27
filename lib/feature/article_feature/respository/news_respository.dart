import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:wheatmap/feature/article_feature/model/model.dart';

class PostRepository {
  final categoryList = [
    'climate change',
    'agriculture',
    'environment protection',
  ];

  Future<CategoriesNewsModel> fetchCategoriesNews(int index) async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q="${categoryList[index]}"&apiKey=8a5ec37e26f845dcb4c2b78463734448'),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    } else {
      throw Exception('error fetching posts');
    }
  }
}
