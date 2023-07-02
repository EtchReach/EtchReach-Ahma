import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bike_detector/utils/networking.dart';
import 'package:vibration/vibration.dart';
import 'package:bike_detector/utils/object_detection.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Setting();
  }
}

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  double _currentDurationValue = 1;
  double _currentIntensityValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Duration of Vibration",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Slider(
          value: _currentDurationValue,
          min: 0,
          max: 5,
          divisions: 5,
          label: _currentDurationValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentDurationValue = value;
            });
          },
        ),
        SizedBox(height: 15),
        Text("Intensity of Vibration",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Slider(
          value: _currentIntensityValue,
          min: 0,
          max: 100,
          divisions: 5,
          label: _currentIntensityValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentIntensityValue = value;
            });
          },
        )
      ],
    ));
  }
}
