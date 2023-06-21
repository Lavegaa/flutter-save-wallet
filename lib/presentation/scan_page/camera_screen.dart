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
  static double overlay_width = 300;
  static double overlay_height = 200;
  int imageId = 0;

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

  Future<File?> _captureImage(Rect rect) async {
    if (!_controller.value.isInitialized) {
      return null;
    }

    try {
      final XFile imageFile = await _controller.takePicture();
      final String imagePath = (await getTemporaryDirectory()).path;
      const String fileName = 'cropped_image';
      final File prevCroppedFile = File('$imagePath/${fileName}_$imageId.jpg');
      if (await prevCroppedFile.exists()) {
        await prevCroppedFile.delete();
      }

      final img.Image? capturedImage =
          img.decodeImage(File(imageFile.path).readAsBytesSync());

      final imageSize = Size(
          capturedImage!.width.toDouble(), capturedImage!.height.toDouble());

      final screenSize = MediaQuery.of(context).size;
      final appBarHeight = AppBar().preferredSize.height;

      final statusBarHeight = MediaQuery.of(context).padding.top;
      final widthRatio = imageSize.width / screenSize.width;
      final heightRatio = imageSize.height /
          (screenSize.height - statusBarHeight - appBarHeight);
      final transformedRect = Rect.fromLTRB(
        rect.left * widthRatio,
        rect.top * heightRatio,
        rect.right * widthRatio,
        rect.bottom * heightRatio,
      );

      final croppedImage = img.copyCrop(
        capturedImage!,
        x: transformedRect.left.toInt(),
        y: transformedRect.top.toInt(),
        width: transformedRect.width.toInt(),
        height: transformedRect.height.toInt(),
      );
      // 자른 이미지를 파일로 저장
      final File croppedFile = File('$imagePath/${fileName}_$imageId.jpg');
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage!));
      imageId += 1;
      print('이미지 캡처 성공: $croppedFile');
      return croppedFile;
    } catch (e) {
      print('이미지 캡처 실패: $e');
      return null;
    }
  }

  void takePicture(bool isGallery, Rect rect) async {
    try {
      final image;
      if (isGallery) {
        image = await _imagePicker?.pickImage(source: ImageSource.gallery);
      } else {
        if (!_controller.value.isInitialized) {
          return;
        }
        final croppedFile = await _captureImage(rect);
        if (croppedFile != null) {
          image = XFile(croppedFile.path);
        } else {
          return;
        }
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
      print('error!!!!!!!!!!!!!!' + e.toString());
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
    final appBarHeight = AppBar().preferredSize.height;

    final rect = Rect.fromCenter(
      center: Offset(
        size.width / 2,
        (size.height - appBarHeight - MediaQuery.of(context).padding.top) / 2,
      ),
      width: _CameraScreenState.overlay_width, // 원하는 가운데 사각형의 너비
      height: _CameraScreenState.overlay_height, // 원하는 가운데 사각형의 높이
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('가격표를 찍어주세요'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => takePicture(true, rect),
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
          child: FutureBuilder<void>(
            future: _controller.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        SizedBox.expand(
                          child: CameraPreview(_controller), // 카메라 미리보기
                        ),
                        SizedBox.expand(
                          child: cameraOverlay(
                              color: Color(0x55000000), rect: rect),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => takePicture(false, rect),
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

Widget cameraOverlay({required Color color, required Rect rect}) {
  return Container(
    color: Colors.transparent,
    child: LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding;
        double verticalPadding;

        horizontalPadding = rect.left;
        verticalPadding = rect.top;

        return Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: horizontalPadding,
                color: color,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: horizontalPadding,
                color: color,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color,
              ),
            ),
          ],
        );
      },
    ),
  );
}
