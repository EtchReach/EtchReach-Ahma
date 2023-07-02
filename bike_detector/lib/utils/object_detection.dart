/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'constants.dart';

class ObjectDetection {
  static const String _modelPath = 'assets/models/ssd_mobilenet.tflite';
  static const String _labelPath = 'assets/models/labelmap.txt';

  Interpreter? _interpreter;
  List<String>? _labels;

  ObjectDetection() {
    _loadModel();
    _loadLabels();
    log('Done.');
  }

  Future<void> _loadModel() async {
    log('Loading interpreter options...');
    final interpreterOptions = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      interpreterOptions.addDelegate(XNNPackDelegate());
    }

    // Use Metal Delegate
    if (Platform.isIOS) {
      interpreterOptions.addDelegate(GpuDelegate());
    }

    log('Loading interpreter...');
    _interpreter =
        await Interpreter.fromAsset(_modelPath, options: interpreterOptions);
  }

  Future<void> _loadLabels() async {
    log('Loading labels...');
    final labelsRaw = await rootBundle.loadString(_labelPath);
    _labels = labelsRaw.split('\n');
  }

  Map analyseImage(Uint8List imageBytes) {
    log('Analysing image...');
    // Reading image bytes from file
    // final imageData = File(imagePath).readAsBytesSync();

    // Decoding image
    final image = img.decodeImage(imageBytes);

    // Resizing image for model, [300, 300]
    final imageInput = img.copyResize(
      image!,
      width: 300,
      height: 300,
    );

    // Creating matrix representation, [300, 300, 3]
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    final output = _runInference(imageMatrix);

    log('Processing outputs...');
    // Location
    final locationsRaw = output.first.first as List<List<double>>;
    final locations = locationsRaw.map((list) {
      return list.map((value) => (value * 300).toInt()).toList();
    }).toList();
    log('Locations: $locations');

    // Classes
    final classesRaw = output.elementAt(1).first as List<double>;
    final classes = classesRaw.map((value) => value.toInt()).toList();
    log('Classes: $classes, Labels: $_labels');

    // Scores
    final scores = output.elementAt(2).first as List<double>;
    log('Scores: $scores');

    // Number of detections
    final numberOfDetectionsRaw = output.last.first as double;
    final numberOfDetections = numberOfDetectionsRaw.toInt();
    log('Number of detections: $numberOfDetections');

    log('Classifying detected objects...');
    final List<Map<String, dynamic>> classifications = [];
    for (var i = 0; i < numberOfDetections; i++) {
      final String label = _labels![classes[i]];
      final double score = scores[i];
      if (Constants.labels.contains(label) &&
          score > Constants.classificationThreshold) {
        classifications.add({
          'label': label,
          'score': scores[i],
          'location': locations[i],
        });
      }
    }

    log('Outlining objects...');
    for (var i = 0; i < classifications.length; i++) {
      // Rectangle drawing
      img.drawRect(
        imageInput,
        x1: classifications[i]['location'][1],
        y1: classifications[i]['location'][0],
        x2: classifications[i]['location'][3],
        y2: classifications[i]['location'][2],
        color: img.ColorRgb8(255, 0, 0),
        thickness: 3,
      );

      // Label drawing
      img.drawString(
        imageInput,
        '${classifications[i]['label']} ${classifications[i]["score"]}',
        font: img.arial14,
        x: classifications[i]['location'][1] + 1,
        y: classifications[i]['location'][0] + 1,
        color: img.ColorRgb8(255, 0, 0),
      );
    }

    log('Done.');
    return {
      "imageBytes": img.encodeJpg(imageInput),
      "objectCount": classifications.length,
    };
  }

  List<List<Object>> _runInference(
    List<List<List<num>>> imageMatrix,
  ) {
    log('Running inference...');

    // Set input tensor [1, 300, 300, 3]
    final input = [imageMatrix];

    // Set output tensor
    // Locations: [1, 10, 4]
    // Classes: [1, 10],
    // Scores: [1, 10],
    // Number of detections: [1]
    final output = {
      0: [List<List<num>>.filled(10, List<num>.filled(4, 0))],
      1: [List<num>.filled(10, 0)],
      2: [List<num>.filled(10, 0)],
      3: [0.0],
    };

    _interpreter!.runForMultipleInputs([input], output);
    return output.values.toList();
  }
}
