import 'package:flutter/material.dart';
import 'package:bike_detector/pages/image_page.dart';

void main() {
  runApp(const ReachAhma());
}

class ReachAhma extends StatelessWidget {
  const ReachAhma({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reach Ahma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: ImagePage(),
      ),
    );
  }
}
