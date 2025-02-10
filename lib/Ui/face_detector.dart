import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FaceDetectorScreen extends StatefulWidget {
  @override
  _FaceDetectorScreenState createState() => _FaceDetectorScreenState();
}

class _FaceDetectorScreenState extends State<FaceDetectorScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription _camera;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Get the list of available cameras
    final cameras = await availableCameras();
    _camera = cameras.first;

    // Initialize the camera controller
    _controller = CameraController(
      _camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      _controller.startImageStream((CameraImage image) {
        if (!_isDetecting) {
          _isDetecting = true;
          // Call a method to detect smile here
          // If smile detected, call _takePicture()
          _detectSmile(image);
        }
      });
    });
  }

  void _detectSmile(CameraImage image) async {
    // Implement smile detection logic here
    // This is a placeholder for smile detection
    // If smile is detected, call _takePicture()
    // For example:
    bool smileDetected = await _mockSmileDetection(image);
    if (smileDetected) {
      _takePicture();
    }
    _isDetecting = false;
  }

  Future<bool> _mockSmileDetection(CameraImage image) async {
    // Simulate smile detection with a delay
    await Future.delayed(Duration(seconds: 2));
    return true; // Assume smile is detected
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      _uploadFile(image.path);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      await FirebaseStorage.instance
          .ref('uploads/${DateTime.now().toIso8601String()}.jpg')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Detector')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: FaceDetectorScreen(),
  ));
}
