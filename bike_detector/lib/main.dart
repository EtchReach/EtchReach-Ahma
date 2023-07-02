import 'package:flutter/material.dart';
import 'package:bike_detector/pages/image_page.dart';
import 'package:bike_detector/pages/settings.dart';

void main() {
  runApp(const ReachAhma());
}

class ReachAhma extends StatelessWidget {
  const ReachAhma({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: RootPage(),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0; //created a variable, put before build
  List<Widget> pages = const [
    ImagePage(),
    Settings(),
    // add other pages when done
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        height: 60.0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.videocam), label: 'Video'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onDestinationSelected: (int index) {
          
            setState(() {
              currentPage = index;
            });
          },

        selectedIndex: currentPage,
        backgroundColor: Colors.red,
        indicatorColor: Colors.white,
        animationDuration: const Duration(seconds: 3),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
