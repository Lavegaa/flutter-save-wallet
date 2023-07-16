import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Product extends StatelessWidget {
  final dynamic title, price, image, link, imgPrice;

  const Product({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.link,
    required this.imgPrice,
  });

  onButtonTap() async {
    await launchUrlString(link);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: Colors.black.withOpacity(0.5),
            style: BorderStyle.solid,
            width: 2),
      ),
      child: Flexible(
        fit: FlexFit.tight,
        child: Row(
          children: [
            //상품 Image
            Container(
              width: 70,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(image),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //상품 Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      //구매하기 버튼
                      GestureDetector(
                        onTap: onButtonTap,
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade500,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Text(
                                  "구매하기 ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //가격비교
                          imgPrice <= price
                              ? Text(
                                  price.toString(),
                                  style: const TextStyle(fontSize: 22),
                                )
                              : Row(
                                  children: [
                                    Text(
                                      price.toString(),
                                      style: const TextStyle(
                                          fontSize: 22, color: Colors.red),
                                    ),
                                    const Icon(
                                      Icons.arrow_downward_sharp,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
