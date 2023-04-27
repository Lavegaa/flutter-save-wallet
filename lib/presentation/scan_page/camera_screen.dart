import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:savewallet/presentation/scan_page/result_screen.dart';

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

  void takePicture(bool isGallery) async {
    try {
      final image;
      if (isGallery) {
        image = await _imagePicker?.pickImage(source: ImageSource.gallery);
      } else {
        image = await _controller.takePicture();
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
              child: Icon(Icons.photo_library_outlined),
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
          child: CameraPreview(_controller),
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
