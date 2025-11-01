import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_capturing/camera_screen.dart';
import 'package:photo_capturing/api_service.dart';
import 'package:geolocator/geolocator.dart';

//Photo capturing class
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late TextEditingController _textController;
  final GlobalKey<CameraScreenState> _cameraScreenKey = GlobalKey();
  bool _isLoading = false;
  bool _showBottomBar = false;
  bool _isCaptured = false;
  var photo;

  Future<void> _switchCamera() async {
    setState(() => _isLoading = true);
    try {
      _cameraScreenKey.currentState?.switchCamera();
    } catch (e) {
      if (mounted) {
        debugPrint('Error: $e');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _capture() async {
    photo = await _cameraScreenKey.currentState?.takePicture();
    if (photo == null) return;
    _isCaptured = true;
  }

  Future<void> _upload() async {
    setState(() => _isLoading = true);
    try {
      final position = await _getCurrentLocation();

      if (!_isCaptured) return;

      final comment = _textController.text.isEmpty
          ? "A photo from the phone camera."
          : _textController.text;

      await ApiService.uploadAndSavePhoto(
        imagePath: photo.path,
        comment: comment,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Photo uploaded successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      _textController.clear();
      setState(() {
        _isLoading = false;
        _isCaptured = false;
        _showBottomBar = false;
      });
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text('Take a picture'),
        titleTextStyle: TextStyle(fontSize: 22),
        centerTitle: true,
        leading: IconButton(
          onPressed: (!_isLoading) ? () => Navigator.pop(context) : null,
          icon: Icon(Icons.keyboard_backspace, size: 32, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: (_isCaptured)
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(File(photo.path)),
                        if (_isLoading)
                          CircularProgressIndicator(color: Colors.white),
                      ],
                    )
                  : CameraScreen(key: _cameraScreenKey),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(),
                color: Theme.of(context).colorScheme.surfaceDim,
              ),
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _showBottomBar ? 0.0 : 1.0,
                    child: IconButton(
                      onPressed: (!_isLoading) ? _switchCamera : null,
                      icon: Icon(
                        Icons.flip_camera_ios_outlined,
                        size: 40,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _showBottomBar ? 0.0 : 1.0,
                    child: IconButton(
                      iconSize: 40,
                      onPressed: () async {
                        await _capture();
                        setState(() => _showBottomBar = true);
                      },
                      icon: Icon(
                        Icons.photo_camera_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _showBottomBar ? 120 : 0,
          child: BottomAppBar(
            color: Colors.black45,
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
                IconButton(
                  onPressed: (!_isLoading) ? _upload : null,
                  icon: Icon(
                    Icons.send,
                    size: 40,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
