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
  bool _isUploading = false;

  Future<void> _captureAndUpload() async {
    setState(() => _isUploading = true);
    try {
      final photo = await _cameraScreenKey.currentState?.takePicture();
      if (photo == null) return;

      final position = await _getCurrentLocation();

      await ApiService.uploadPhoto(
        imagePath: photo.path,
        comment: _textController.text.isEmpty
            ? "A photo from the phone camera."
            : _textController.text,
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
      setState(() => _isUploading = false);
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
      backgroundColor: Theme.of(context).colorScheme.surfaceTint,
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
      body: Center(child: CameraScreen(key: _cameraScreenKey)),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BottomAppBar(
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
              IconButton(
                onPressed: (!_isUploading) ? _captureAndUpload : null,
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
