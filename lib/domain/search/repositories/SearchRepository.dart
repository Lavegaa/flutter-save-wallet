import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/product_model/product_model.dart';

//url 수정
class SearchRepository {
  static const String baseUrl =
      "https://e7c72s2zc4.execute-api.ap-northeast-2.amazonaws.com";
  static const String endpoint = "dev";

  static Future<List<ProductModel>> getProductList(String title) async {
    try {
      List<ProductModel> productInstances = [];
      final url = Uri.parse('$baseUrl/$endpoint?title=$title');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-KEY': 'OuNCOGoTNtcZnYE2gEE82TP1EtycJdr5T8dQ2Jwj'
      });
      print('response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> productList = jsonDecode(response.body);
        for (var product in productList) {
          productInstances.add(ProductModel.fromJson(product));
        }
        print('productInstances: $productInstances');

        return productInstances;
      } else {
        return [];
      }
    } catch (e) {
      print("SearcbRepository getProductList error: $e");
      return [];
    }
  }
}
