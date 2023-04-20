import 'package:flutter/material.dart';
import 'package:savewallet/presentation/item_list_page/item_list_view.dart';
import 'package:savewallet/presentation/scan_page/text_detector_view.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 2,
              child: TextRecognizerView(),
            ),
            Expanded(
              flex: 1,
              child: ItemListView(),
            ),
            ],
        )
      ),
    );
  }
}