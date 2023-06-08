import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Product extends StatelessWidget {
  final dynamic title, price, image, link;

  const Product({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.link,
  });

  //TODO  : 사진찍은 가격도 필요?!
  static num imgPrice = 8;

  OnButtonTap() async {
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
      child: Row(
        children: [
          Hero(
            tag: title,
            child: Container(
              width: 150, //이미지 크기
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 35,
                      offset: const Offset(20, 20),
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ]),
              child: Image.network(image),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: OnButtonTap,
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade500,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "구매하기 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
              )
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //가격비교
              imgPrice < price
                  ? Text(
                      price.toString(),
                      style: const TextStyle(fontSize: 22),
                    )
                  : Row(
                      children: [
                        Text(
                          price.toString(),
                          style:
                              const TextStyle(fontSize: 22, color: Colors.red),
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
      ),
    );
  }
}
