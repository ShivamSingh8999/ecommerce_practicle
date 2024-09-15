import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String apiUrl = 'https://dummyjson.com/products';

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['products'];
      } else {
        throw Exception('Failed to load products');
      }
    }  catch (e) {
       rethrow;
    }
  }
}
