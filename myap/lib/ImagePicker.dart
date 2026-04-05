import 'package:flutter/material.dart';

class ImagePicker extends StatefulWidget {
  const ImagePicker({super.key});

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ImageWidgets"),
      ),
      body: Center(
        child: Image.asset("assets/image/ringed-planet-3840x2160-25389.jpg", scale: 1.0),
      ),
    );
  }
}