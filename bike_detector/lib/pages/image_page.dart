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
        Uint8List? processedImageBytes =
            objectDetection?.analyseImage(fetchedBytes);
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
          image == null ? const Text("No Connection") : Image.memory(image!),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text('Vibrate with pattern and amplitude'),
            onPressed: () {
              const snackBar = SnackBar(
                content: Text(
                  'Vibrate',
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Vibration.vibrate(
                pattern: [3000],
                intensities: [128],
              );
            },
          ),
        ],
      ),
    );
  }
}
