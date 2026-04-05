import 'package:flutter/material.dart';
import 'package:myap/ImagePicker2.dart';
import 'package:myap/imagePicker.dart';
import 'package:myap/sesi66666.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const ImageCarousel(
      //   imageUrls: [
      //     "assets/image/hotdog.jpg",
      //     "assets/image/ringed-planet-3840x2160-25389.jpg",
      //     "assets/image/cocacola.jpg",
      //   ],
      // ),
      home: Sesi66666(),
    );
  }
}