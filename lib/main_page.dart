import 'package:flutter/material.dart';
import 'package:photo_capturing/camera_screen.dart';

//Photo capturing class
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        title: Text('Take a picture'),
        titleTextStyle: TextStyle(fontSize: 22),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, size: 32, color: Colors.white),
        ),
      ),
      body: CameraScreen(),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surfaceTint,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Add a picture comment',
                  ),
                ),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  size: 40,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
