import 'package:flutter/material.dart';

//Simple HomePage with camera icon and 'Open Camera' Button
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          SizedBox(height: 48),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/main'),
            icon: Icon(Icons.camera_alt),
            label: Text('Open Camera'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
