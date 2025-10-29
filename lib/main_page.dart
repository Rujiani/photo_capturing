import 'package:flutter/material.dart';

//Photo capturing class
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Take a picture'),
        titleTextStyle: TextStyle(fontSize: 22),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, size: 32, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black87,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.white,
          shape: CircleBorder(side: BorderSide(color: Colors.white, width: 4)),
        ),
      ),
    );
  }
}
