import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bike_detector/utils/networking.dart';
import 'package:vibration/vibration.dart';
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
      if (fetchedBytes != null && objectDetection != null) {
        Map processedInformation = objectDetection!.analyseImage(fetchedBytes);
        Uint8List processedImageBytes = processedInformation['imageBytes'];
        int objectCount = processedInformation['objectCount'];
        if (objectCount > 0) {
          Vibration.vibrate(
            pattern: [1000, 1000],
            intensities: [128, 128],
          );
        }
        setState(() {
          image = processedImageBytes;
        });
      }
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image == null
              ? const Text("No Connection")
              : Image.memory(
                  image!,
                  gaplessPlayback: true,
                ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text('Vibrate with pattern and amplitude'),
            onPressed: () {
              Vibration.vibrate(
                pattern: [1000, 1000],
                intensities: [128, 128],
              );
            },
          ),
        ],
      ),
    );
  }
}
