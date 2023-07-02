import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bike_detector/utils/networking.dart';
import 'package:vibration/vibration.dart';

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
      if (fetchedBytes != null) {
        setState(() {
          imageBytes = fetchedBytes;
        });
      }
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageBytes == null
              ? const Text("Hello")
              : Image.memory(
                  imageBytes!,
                  gaplessPlayback: true,
                ),
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
