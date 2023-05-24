// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'dart:ui' as ui;
// import 'package:image/image.dart' as img;
// import 'dart:async';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   GlobalKey _previewContainerKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();

//     // 사용 가능한 카메라 목록 가져오기
//     availableCameras().then((cameras) {
//       // 첫 번째 카메라 선택
//       final camera = cameras.first;

//       // CameraController 초기화
//       _controller = CameraController(camera, ResolutionPreset.medium);

//       // CameraController 초기화
//       _initializeControllerFuture = _controller.initialize().then((_) {
//         setState(() {});
//       });
//     });
//   }

//   @override
//   void dispose() {
//     // CameraController 종료
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<ui.Image> _captureImage() async {
//     if (!_controller.value.isInitialized) {
//       return null;
//     }

//     try {
//       // CameraController로 이미지 캡처
//       final imageBytes = await _controller.takePicture();

//       // Image 객체로 변환
//       final capturedImage = img.decodeImage(imageBytes.readAsBytesSync());

//       // 현재 화면 크기
//       final RenderBox renderBox =
//           _previewContainerKey.currentContext.findRenderObject();
//       final size = renderBox.size;

//       // 사각형 부분 자르기
//       final rect = Rect.fromCenter(
//         center: Offset(size.width / 2, size.height / 2),
//         width: 200, // 원하는 가운데 사각형의 너비
//         height: 200, // 원하는 가운데 사각형의 높이
//       );

//       final croppedImage = img.copyCrop(capturedImage, rect.left.toInt(),
//           rect.top.toInt(), rect.width.toInt(), rect.height.toInt());

//       // Image 객체를 ui.Image로 변환
//       final capturedUiImage = await _convertImageToUiImage(croppedImage);

//       return capturedUiImage;
//     } catch (e) {
//       print('이미지 캡처 실패: $e');
//       return null;
//     }
//   }

//   Future<ui.Image> _convertImageToUiImage(img.Image image) async {
//     final completer = Completer<ui.Image>();

//     ui.decodeImageFromPixels(
//       image.getBytes(),
//       image.width,
//       image.height,
//       ui.PixelFormat.rgba8888,
//       completer.complete,
//     );

//     return completer.future;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('카메라')),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               children: [
//                 CameraPreview(_controller),
//                 Positioned.fill(
//                   child: RepaintBoundary(
//                     key: _previewContainerKey,
//                     child: CustomPaint(
//                       painter: _RectanglePainter(
//                         rectColor: Colors.white.withOpacity(0.5),
//                         rectWidth: 200, // 원하는 가운데 사각형의 너비
//                         rectHeight: 200, // 원하는 가운데 사각형의 높이
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _captureImage().then((capturedImage) {
//             // 자른 이미지 사용
//           });
//         },
//         child: Icon(Icons.camera),
//       ),
//     );
//   }
// }

// class _RectanglePainter extends CustomPainter {
//   final Color rectColor;
//   final double rectWidth;
//   final double rectHeight;
//   final double strokeWidth;

//   _RectanglePainter({
//     required this.rectColor,
//     required this.rectWidth,
//     required this.rectHeight,
//     required this.strokeWidth,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double screenWidth = size.width;
//     final double screenHeight = size.height;
//     final double centerX = screenWidth / 2;
//     final double centerY = screenHeight / 2;

//     final rectLeft = centerX - (rectWidth / 2);
//     final rectTop = centerY - (rectHeight / 2);
//     final rectRight = centerX + (rectWidth / 2);
//     final rectBottom = centerY + (rectHeight / 2);

//     final rectPaint = Paint()
//       ..color = rectColor
//       ..style = PaintingStyle.fill;

//     final rect = Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
//     canvas.drawRect(rect, rectPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }