import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResultScreen extends StatelessWidget {
  final String text;
  const ResultScreen({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: Text(
          //TODO - 결과 창? 추후 작업?
          text, //받아온 text 출력
          style: const TextStyle(
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}
