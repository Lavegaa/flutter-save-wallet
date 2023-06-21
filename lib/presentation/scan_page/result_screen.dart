import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:savewallet/presentation/scan_page/input_view.dart';
import 'package:savewallet/presentation/scan_page/result_view.dart';

class ResultScreen extends StatelessWidget {
  final InputImage image;
  const ResultScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            flex: 2,
            child: ResultView(
              image: image.filePath!,
            ),
          ),
          Expanded(
            flex: 1,
            child: InputView(
              image: image,
            ),
          ),
        ],
      )),
    );
  }
}
