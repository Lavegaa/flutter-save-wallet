import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/search/repositories/SearchRepository.dart';
import '../../model/product_model/product_model.dart';
import '../../widgets/product_widget.dart';

class ItemListView extends StatelessWidget {
  final String title;
  final String price;

  ItemListView({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  //TODO : title넣기?...? final이라 안됨?
  late final Future<List<ProductModel>> products =
      SearchRepository.getProductList(title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        foregroundColor: Colors.black.withOpacity(0.8),
        backgroundColor: Colors.purple.shade50,
        title: Row(
          children: const [
            Icon(
              Icons.manage_search,
              size: 45,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "결과보기",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(child: makeList(snapshot))
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

//TODO : 상품 나열
  ListView makeList(AsyncSnapshot<List<ProductModel>> snapshot) {
    String priceString = price;
    var numberFormat = NumberFormat('#,###');
    num imgPrice = 0;
    try {
      imgPrice = numberFormat.parse(priceString);
      print(price); // 출력: 123123123
    } catch (e) {
      print('유효한 가격 형식이 아닙니다.');
    }
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      itemBuilder: (context, index) {
        var product = snapshot.data![index];
        return Product(
          title: product.title,
          price: product.price,
          image: product.image,
          link: product.link,
          imgPrice: imgPrice,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 20,
      ),
    );
  }
}
