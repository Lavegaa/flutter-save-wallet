// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'item_list_view.dart';

// ignore: must_be_immutable
class ResultScreen extends StatefulWidget {
  ResultScreen({super.key, required String text});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  //TODO - recognizedText title,price 받아오기
  final TextEditingController title = TextEditingController(text: "오색어묵탕");
  //이름
  final TextEditingController price = TextEditingController(text: "8800");
  //가격
  bool _isCheckTitle = true;

  bool _isCheckPrice = true;

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
              Icons.camera_alt_outlined,
              size: 45,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "상품명 스캔 결과",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            //TODO : 체크 박스 추가하여 검색 스트링 조절?
            Checkbox(
              value: _isCheckTitle,
              onChanged: (value) {
                setState(() {
                  _isCheckTitle = value!;
                });
              },
            ),
            ItemListTextField(
              myText: title,
              labelText: '이름',
            ),
            Checkbox(
              value: _isCheckPrice,
              onChanged: (value) {
                setState(() {
                  _isCheckPrice = value!;
                });
              },
            ),
            ItemListTextField(
              myText: price,
              labelText: '가격',
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
              clipBehavior: Clip.hardEdge,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemListView(
                      title: _isCheckTitle ? title.text : "",
                      price: _isCheckPrice ? price.text : "",
                    ),
                  ),
                );
              },
              child: const Text("결과보기"),
            )
          ]),
        ),
      ),
    );
  }
}

class ItemListTextField extends StatelessWidget {
  const ItemListTextField({
    super.key,
    required this.myText,
    required this.labelText,
  });
  final String labelText;
  final TextEditingController myText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: myText,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: 'Fix your Text',
            labelStyle: const TextStyle(color: Colors.redAccent),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 2, color: Colors.blueAccent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 1, color: Colors.redAccent),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
