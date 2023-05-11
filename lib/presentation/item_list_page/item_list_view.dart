import 'package:flutter/material.dart';
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

  //TODO : api로 상품 받아오기
  final Future<List<ProductModel>> products =
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
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                //Expanded(child: makeList(snapshot))
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
    return ListView.separated(
      scrollDirection: Axis.horizontal,
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
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
