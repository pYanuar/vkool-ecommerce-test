import 'package:flutter/material.dart';

class FaceDetector extends StatefulWidget {
  const FaceDetector({super.key});

  @override
  State<FaceDetector> createState() => _FaceDetectorState();
}

class _FaceDetectorState extends State<FaceDetector> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Face Detector'),
        ),
        body: Center(
          child: Text(
            'Teks di Tengah Layar',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
