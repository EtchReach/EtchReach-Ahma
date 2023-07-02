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
  Uint8List? imageBytes;
  Timer? t;
  void fetchImage() {
    t = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      Uint8List? fetchedBytes = await Networking.fetchImage();
      setState(() {
        imageBytes = fetchedBytes;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          imageBytes == null ? const Text("Hello") : Image.memory(imageBytes!),
    );
  }
}
