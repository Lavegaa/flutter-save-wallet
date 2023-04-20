import 'package:flutter/material.dart';
import 'package:savewallet/presentation/item_list_page/result_screen.dart';

class ItemListView extends StatelessWidget {
  ItemListView({super.key});

  //TODO - recognizedText 받아오기
  final TextEditingController myText = TextEditingController(text: "배고파피자먹고싶어");
  final TextEditingController myText1 =
      TextEditingController(text: "배고파치킨먹고싶어");
  final TextEditingController myText2 =
      TextEditingController(text: "배고파육회먹고싶어");
  //TODO - 결과 후처리?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "ItemListTestPage",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: Column(children: [
          ItemListTextField(myText: myText),
          ItemListTextField(myText: myText1),
          ItemListTextField(myText: myText2),
          const SizedBox(
            height: 100,
          ),
          OutlinedButton(
            clipBehavior: Clip.hardEdge,
            onPressed: () {
              //TODO : 후처리 후 버튼 클릭 결과 합쳐서 스크린 결과화면 출력
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    //결과보내기?
                    text: myText.text + myText1.text + myText2.text,
                  ),
                ),
              );
            },
            child: const Text("결과보기"),
          )
        ]),
      ),
    );
  }
}

class ItemListTextField extends StatelessWidget {
  const ItemListTextField({
    super.key,
    required this.myText,
  });

  final TextEditingController myText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        TextField(
          controller: myText,
          decoration: const InputDecoration(
            labelText: 'String',
            hintText: 'Fix your Text',
            labelStyle: TextStyle(color: Colors.redAccent),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 2, color: Colors.blueAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 1, color: Colors.redAccent),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
