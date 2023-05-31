import 'dart:io';

import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final String image;
  const ResultView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결과'),
      ),
      body: SafeArea(
        child: Expanded(
          flex: 1,
          child: Image.file(
            File(image),
            // fit: BoxFit.fitWidth,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
