import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/product_model/product_model.dart';

//url 수정
class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<ProductModel>> getProduct() async {
    List<ProductModel> productInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        productInstances.add(ProductModel.fromJson(webtoon));
      }
      return productInstances;
    }
    throw Error();
  }
}
