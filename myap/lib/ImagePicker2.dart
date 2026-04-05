import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  const ImageCarousel({Key? key, required this.imageUrls}) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  File? _ImagePicker;

  // ? => file itu belum tentu dipake atau belum tentu ada

  late PageController _pageController;
  int _currentPage = 0;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void pickedImageFromGallery() async {
    //async karena harus nunggu input dari usernya
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null){
        setState(() {
          _ImagePicker = File(pickedImage.path);
        });

    }
  }

  // Future<void> _pickerImage() async {
  //   final List<File> pickedFiles =
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ImageCarousel")),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return Image.asset(widget.imageUrls[index], fit: BoxFit.cover);
              },
            ),
          ),

          ElevatedButton(
            onPressed: pickedImageFromGallery,
            child: _ImagePicker == null ? Text("Image Picked") : Text("Change Image"),
          ),
          
        ],
      ),
    );
  }
}
