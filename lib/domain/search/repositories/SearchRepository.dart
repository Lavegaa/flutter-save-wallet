import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:savewallet/domain/search/repositories/mock.dart';
import '../../../model/product_model/product_model.dart';

//url 수정
class SearchRepository {
  static const String baseUrl =
      "https://e7c72s2zc4.execute-api.ap-northeast-2.amazonaws.com";
  static const String endpoint = "dev";

  static Future<List<ProductModel>> getProductList(String title) async {
    const bool test = false;
    try {
      if (test) {
        List<ProductModel> productInstances = [];

        dynamic productList = mockData;

        for (var product in productList) {
          productInstances.add(ProductModel.fromJson(product));
        }
        return productInstances;
      }
      String? apiKey = dotenv.env['X-API-KEY'];
      if (apiKey == null) throw 'apiKey is null';
      List<ProductModel> productInstances = [];
      final url = Uri.parse('$baseUrl/$endpoint?title=$title');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-KEY': apiKey
      });
      List<int> responseBodyBytes = response.bodyBytes;
      String responseBody = utf8.decode(responseBodyBytes);
      dynamic jsonData = jsonDecode(responseBody);
      /**
       * NOTE:
       * resposnse.statusCode - 우리서버
       * jsonData['statusCode'] - naver서버
       * 추후 상황에 따라 UI를 다르게 표기해줄 수 있을 것 같음.
       */
      if (response.statusCode == 200 && jsonData['statusCode'] == '200') {
        // dynamic jsonData = jsonDecode(response.body);
        dynamic productList = jsonData['data'];
        for (var product in productList) {
          productInstances.add(ProductModel.fromJson(product));
        }
        print('productInstances: ${productInstances[0].title}');

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
