import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSource {
  static const menWatches =
      'https://dummyjson.com/products/category/mens-watches';

  static const womenWatches =
      'https://dummyjson.com/products/category/womens-watches';

  Future<Map<String, dynamic>> getMenWatches() async {
    final response = await http.get(Uri.parse(menWatches));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getWomenWatches() async {
    final response = await http.get(Uri.parse(womenWatches));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
