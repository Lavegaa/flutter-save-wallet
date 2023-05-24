import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:savewallet/presentation/scan_page/result_screen.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'dart:async';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;
  ImagePicker? _imagePicker;
  GlobalKey _previewContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    initCamera();
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<File?> _captureImage() async {
    if (!_controller.value.isInitialized) {
      return null;
    }

    try {
      // CameraController로 이미지 캡처
      // final imageBytes = await _controller.takePicture();
      final XFile imageFile = await _controller.takePicture();
      // // Image 객체로 변환
      // final capturedImage =
      //     img.decodeImage(imageBytes.readAsBytes() as Uint8List);

      // // 현재 화면 크기
      // final RenderBox? renderBox =
      //     _previewContainerKey.currentContext?.findRenderObject() as RenderBox?;
      // if (renderBox == null) {
      //   return null;
      // }
      // final size = renderBox.size;

      // // 사각형 부분 자르기
      // final rect = Rect.fromCenter(
      //   center: Offset(size.width / 2, size.height / 2),
      //   width: 200, // 원하는 가운데 사각형의 너비
      //   height: 200, // 원하는 가운데 사각형의 높이
      // );

      // final croppedImage = img.copyCrop(capturedImage!,
      //     x: rect.left.toInt(),
      //     y: rect.top.toInt(),
      //     width: rect.width.toInt(),
      //     height: rect.height.toInt());

      // // Image 객체를 ui.Image로 변환
      // final capturedUiImage = await _convertImageToUiImage(croppedImage);
      //
      // 이미지를 읽어들이고 가운데 200x200 크기로 자름
      final img.Image? capturedImage =
          img.decodeImage(File(imageFile.path).readAsBytesSync());
      final RenderBox? renderBox =
          _previewContainerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return null;
      }
      final size = renderBox.size;
      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 200, // 원하는 가운데 사각형의 너비
        height: 200, // 원하는 가운데 사각형의 높이
      );

      final croppedImage = img.copyCrop(capturedImage!,
          x: rect.left.toInt(),
          y: rect.top.toInt(),
          width: rect.width.toInt(),
          height: rect.height.toInt()); // x, y, width, height는 필요에 따라 조정

      // 자른 이미지를 파일로 저장
      final String imagePath = (await getTemporaryDirectory()).path;
      final String fileName = 'cropped_image.jpg'; // 파일 이름 지정
      final File croppedFile = File('$imagePath/$fileName')
        ..writeAsBytesSync(img.encodeJpg(croppedImage));
      print('이미지 캡처 성공: $croppedFile');
      return croppedFile;
    } catch (e) {
      print('이미지 캡처 실패: $e');
      return null;
    }
  }

  void takePicture(bool isGallery) async {
    try {
      final image;
      if (isGallery) {
        image = await _imagePicker?.pickImage(source: ImageSource.gallery);
      } else {
        print('capture start!!!!');
        image = await _captureImage();
        print('image:    ' + image);
      }
      final inputImage = InputImage.fromFilePath(image.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(image: inputImage),
          fullscreenDialog: true,
        ),
      );
    } catch (e) {
      // 에러 처리 로직
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final Size size = MediaQuery.of(context).size;
    final double cameraAspectRatio = _controller.value.aspectRatio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('가격표를 찍어주세요'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => takePicture(true),
              child: const Icon(Icons.photo_library_outlined),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: AspectRatio(
          aspectRatio:
              cameraAspectRatio > 1 ? cameraAspectRatio : 1 / cameraAspectRatio,
          child: Stack(
            children: [
              Container(
                color: Colors.blue, // 배경 색상 예시
                width: double.infinity,
                height: double.infinity,
              ),
              CustomPaint(
                painter: MyCustomPainter(),
                child: CameraPreview(_controller),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => takePicture(false),
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 배경을 검은색으로 그리기
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // 중앙의 200x200 영역을 뚫어서 배경이 보이도록 그리기
    final holePaint = Paint()..blendMode = BlendMode.clear;
    final holeRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 200,
      height: 200,
    );
    canvas.drawRect(holeRect, holePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
