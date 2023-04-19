import 'package:flutter/material.dart';
import 'package:savewallet/presentation/scan_page/text_detector_view.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextRecognizerView(),
        )
      ),
    );
  }
}