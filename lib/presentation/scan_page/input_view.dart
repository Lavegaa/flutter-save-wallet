import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:savewallet/presentation/item_list_page/result_screen.dart';

class InputView extends StatefulWidget {
  final InputImage image;
  const InputView({super.key, required this.image});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.korean);
  bool _canProcess = true;
  bool _isBusy = false;
  String? _text;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void initState() {
    processImage(widget.image);
    super.initState();
  }

  final TextEditingController myText = TextEditingController(text: "배고파피자먹고싶어");

  final TextEditingController myText1 =
      TextEditingController(text: "배고파치킨먹고싶어");

  final TextEditingController myText2 =
      TextEditingController(text: "배고파육회먹고싶어");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // ignore: prefer_const_literals_to_create_immutables
          child: Column(children: [
            ItemListTextField(
              myText: myText,
              labelText: '상품명',
            ),
            ItemListTextField(
              myText: myText1,
              labelText: '가격',
            ),
            ItemListTextField(
              myText: myText2,
              labelText: '수량',
            ),
            const SizedBox(
              height: 30,
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
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);

    _text = 'Recognized text:\n\n${recognizedText.text}';
    print('result:      ' + _text!);
    recognizedText.blocks
        .forEach((element) => print('result:      ' + element.text));

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
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
