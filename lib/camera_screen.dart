import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isLoading = true;
  int _currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeFirstCamera();
  }

  Future<void> _initializeFirstCamera() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      _cameras = await availableCameras();
      debugPrint('Found ${_cameras?.length} cameras');

      if (_cameras != null && _cameras!.isNotEmpty) {
        await _initializeCameraController(_currentCameraIndex);
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _initializeCameraController(int cameraIndex) async {
    if (_cameras == null || cameraIndex >= _cameras!.length) {
      debugPrint('Invalid camera index: $cameraIndex');
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);
    await _controller?.dispose();

    final newController = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await newController.initialize();
      if (mounted) {
        setState(() => _controller = newController);
      } else {
        newController.dispose();
      }
    } catch (e) {
      debugPrint('Controller initialization error: $e');
      newController.dispose();
      if (mounted) setState(() => _controller = null);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void switchCamera() {
    if (!mounted || _cameras == null || _cameras!.length < 2) return;

    final nextIndex = (_currentCameraIndex + 1) % _cameras!.length;
    _currentCameraIndex = nextIndex;
    _initializeCameraController(nextIndex);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      debugPrint('Camera is not ready');
      return null;
    }

    try {
      final XFile photo = await _controller!.takePicture();
      debugPrint('Photo taken: ${photo.path}');
      return photo;
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: Text('No camera available'));
    }

    return CameraPreview(_controller!);
  }
}
