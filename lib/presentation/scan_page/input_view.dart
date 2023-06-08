import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:savewallet/presentation/item_list_page/result_screen.dart';
// import 'package:tflite/tflite.dart';
import '../item_list_page/item_list_view.dart';

class InputView extends StatefulWidget {
  final InputImage image;
  const InputView({super.key, required this.image});

  @override
  State<InputView> createState() => _InputViewState();
}

class TAG_TYPE {
  static const String SINGLE = 'SINGLE';
  static const String SINGLE_SOLDOUT = 'SINGLE_SOLDOUT';
  static const String SINGLE_SALE = 'SINGLE_SALE';
  static const String MULTI = 'MULTI';
}

class _InputViewState extends State<InputView> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.korean);
  bool _canProcess = true;
  bool _isBusy = false;
  String? _text;

  final Map<String, Map<String, dynamic>> TAG_TYPES = {
    TAG_TYPE.SINGLE: {
      'length': 6,
      'nameIndex': 0,
      'priceIndex': 4,
    },
    TAG_TYPE.SINGLE_SOLDOUT: {
      'length': 7,
      'nameIndex': 1,
      'priceIndex': 6,
    },
    TAG_TYPE.SINGLE_SALE: {
      'length': 10,
      'nameIndex': 5,
      'priceIndex': 9,
    },
    // 이거 좀 쉽지않은데
    TAG_TYPE.MULTI: {
      'length': 8,
      'nameIndex': 0,
      'priceIndex': 4,
    },
  };

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void initState() {
    // processImage(widget.image);
    super.initState();
    // loadModel().then((value) {
    //   setState(() {});
    // });
  }

  // // 모델과 label.txt를 가져온다.
  // loadModel() async {
  //   await Tflite.loadModel(
  //     // 모델 넣기
  //     model: "assets/model_unquant.tflite",
  //     // 이건 뭔지 모르겠네
  //     labels: "assets/testlabel.txt",
  //   ).then((value) {
  //     setState(() {
  //       //_loading = false;
  //     });
  //   });
  // }

  // 이미지 분류
  // Future classifyImage(File image) async {
  //   // 아래 잘 넣어보기
  //   var output = await Tflite.runModelOnImage(
  //       path: image.path,
  //       imageMean: 0.0, // defaults to 117.0
  //       imageStd: 255.0, // defaults to 1.0
  //       numResults: 2, // defaults to 5
  //       threshold: 0.2, // defaults to 0.1
  //       asynch: true // defaults to true
  //       );
  //   setState(() {});
  // }

  late final TextEditingController itemName = TextEditingController(text: "");

  late final TextEditingController itemPrice = TextEditingController(text: "");

  late final TextEditingController itemAmount =
      TextEditingController(text: "1");

  bool _isCheckTitle = true;

  bool _isCheckPrice = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // ignore: prefer_const_literals_to_create_immutables
          child: Column(children: [
            Checkbox(
              value: _isCheckTitle,
              onChanged: (value) {
                setState(() {
                  _isCheckTitle = value!;
                });
              },
            ),
            ItemListTextField(
              textValue: itemName,
              labelText: '상품명',
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
              textValue: itemPrice,
              labelText: '가격',
            ),
            ItemListTextField(
              textValue: itemAmount,
              labelText: '수량',
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
                      title: _isCheckTitle ? itemName.text : "",
                      price: _isCheckPrice ? itemPrice.text : "",
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
    List<String> textList = recognizedText.blocks.map((e) => e.text).toList();
    print('textList:  ${textList}');
    // tag추론
    Map<String, dynamic> tag = estimateTag(textList);
    // tag에 따라 상품명, 가격, 수량 추론
    Map<String, dynamic> itemInfo = estimateItemInfo(textList, tag);
    itemName.text = itemInfo['name'];
    itemPrice.text = itemInfo['price'];
    // 가격 추출
    // List<String> priceList = detectPrice(textList);
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  List<String> detectPrice(List<String> textList) {
    RegExp exp = RegExp(r'^[\d,]+$');
    List<String>? priceTextList = [];
    for (String text in textList) {
      if (exp.hasMatch(text)) {
        priceTextList.add(text);
      }
    }
    return priceTextList;
  }

  /// 아주 기초적인 추론 방법
  /// textList를 받아서 length에 따라 tag를 추론하는 함수
  /// tag추론 방법을 더 강화해야함.
  /// 현재는 단순 배열의 길이로만 판단.
  /// 추후에는 가격과 단위당 가격 및 단위를 이용하여 추론해야함.
  /// 세일 잘라내기 등등 구분 필요 아이디어 더 필요함.
  /// 솔직히 저런것들보단 자연어 처리가 맞지 않나 생각이 들기도 함;;

  Map<String, dynamic> estimateTag(List<String> textList) {
    switch (textList.length) {
      case 6:
        return TAG_TYPES[TAG_TYPE.SINGLE]!;
      case 7:
        return TAG_TYPES[TAG_TYPE.SINGLE_SOLDOUT]!;
      case 10:
        return TAG_TYPES[TAG_TYPE.SINGLE_SALE]!;
      case 8:
        return TAG_TYPES[TAG_TYPE.MULTI]!;
      default:
        return TAG_TYPES[TAG_TYPE.SINGLE]!;
    }
  }

  // textList를 받아서 tag에 따라 상품명, 가격, 수량을 추론하는 함수
  Map<String, dynamic> estimateItemInfo(
      List<String> textList, Map<String, dynamic> tag) {
    Map<String, dynamic> itemInfo = {};
    itemInfo['name'] = textList[tag['nameIndex']];
    itemInfo['price'] = textList[tag['priceIndex']];
    // itemInfo['quantity'] = textList[tag['length'] - 1];
    return itemInfo;
  }
}

class ItemListTextField extends StatelessWidget {
  const ItemListTextField({
    super.key,
    required this.textValue,
    required this.labelText,
  });
  final String labelText;
  final TextEditingController textValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: textValue,
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
