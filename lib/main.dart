import 'package:flutter/material.dart';
import 'package:photo_capturing/home_page.dart';
import 'package:photo_capturing/main_page.dart';

void main() {
  runApp(const PhotoCapturing());
}

class PhotoCapturing extends StatelessWidget {
  const PhotoCapturing({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Capturing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/home',
      routes: {
        //Home page
        '/home': (context) => HomePage(),
        //Main page with camera capturing
        '/main': (context) => MainPage(),
      },
    );
  }
}
