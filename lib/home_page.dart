import 'package:flutter/material.dart';
import 'package:photo_capturing/photo_repository.dart';
import 'package:intl/intl.dart';

//Simple HomePage with camera icon and 'Open Camera' Button
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PhotoData? _lastPhoto;

  Widget _noPhoto() {
    return Column(
      children: [
        Icon(
          Icons.photo_camera_outlined,
          size: 120,
          color: Colors.blueGrey[300],
        ),
        SizedBox(height: 32),
        Text(
          'Photo Capture App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Capture photos with comments and location data',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _previewPhoto() {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            constraints: BoxConstraints(maxHeight: 400, maxWidth: 300),
            child: Image.memory(_lastPhoto!.imageBytes, fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _lastPhoto!.comment,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
        ),
        Text(
          'Created at:',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
        ),
        Text(
          DateFormat('dd.MM.yyyy HH:mm').format(_lastPhoto!.timestamp),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Future<void> _getPhoto() async {
    final photo = await PhotoRepositoryImpl().getLastPhoto();
    setState(() {
      _lastPhoto = photo;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Photo App',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (_lastPhoto == null) ? _noPhoto() : _previewPhoto(),
          SizedBox(height: 48),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, '/main').then((_) => _getPhoto()),
            icon: Icon(Icons.camera_alt),
            label: Text('Open Camera'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await PhotoRepositoryImpl().clearPhoto();
              setState(() {
                _lastPhoto = null;
              });
            },
            icon: Icon(Icons.delete),
            label: Text('Clear HomePage'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
