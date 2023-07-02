import 'dart:typed_data';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:bike_detector/utils/networking.dart';
import 'package:bike_detector/utils/object_detection.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {

  Timer? t;
  ObjectDetection? objectDetection;
  Uint8List? image;

  void fetchImage() {
    t = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      Uint8List? fetchedBytes = await Networking.fetchImage();
      setState(() {
        if (fetchedBytes != null) {
          Uint8List imageBytes = fetchedBytes;
          image = objectDetection!.analyseImage(imageBytes);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    objectDetection = ObjectDetection();
    fetchImage();
  }

  @override
  void dispose() {
    super.dispose();
    t?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          image == null ? const Text("No Connection") : Image.memory(image!),
    );
  }
}
