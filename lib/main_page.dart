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

  Future<void> _captureAndUpload() async {
    setState(() => _isLoading = true);
    try {
      final position = await _getCurrentLocation();
      final photo = await _cameraScreenKey.currentState?.takePicture();

      if (photo == null) return;

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
      setState(() => _isLoading = false);
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
      body: Center(child: CameraScreen(key: _cameraScreenKey)),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BottomAppBar(
          color: Colors.black45,
          child: Row(
            children: [
              IconButton(
                onPressed: (!_isLoading) ? _switchCamera : null,
                icon: Icon(
                  Icons.flip_camera_ios_outlined,
                  size: 40,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
              ),
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
                onPressed: (!_isLoading) ? _captureAndUpload : null,
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
    );
  }
}
