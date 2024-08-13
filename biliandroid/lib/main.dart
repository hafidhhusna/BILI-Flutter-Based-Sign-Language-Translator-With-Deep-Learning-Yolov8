import 'package:biliandroid/Backend/scan_controller.dart';
import 'package:flutter/material.dart';
// import 'package:camera/camera.dart'; // Uncomment this
import 'package:biliandroid/pages/intro_pages.dart';
import 'package:biliandroid/Pages/speechtotext.dart';
import 'pages/menu_pages.dart';
// import 'Controller/scan_controller.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
      routes: {
        '/intropage': (context) => const IntroPage(),
        '/menupage': (context) => const MenuPages(),
        '/trackingpages': (context) => const ScanController(),
        '/speechtotext': (context) =>  SpeechToText(),
      },
    );
  }
}
