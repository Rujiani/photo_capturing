import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoRepositoryImpl {
  static const String _storageKey = 'last_captured_photo';

  Future<void> savePhoto(PhotoData photo) async {
    final prefs = await SharedPreferences.getInstance();
    final photoJson = json.encode(photo.toJson());
    await prefs.setString(_storageKey, photoJson);
  }

  Future<PhotoData?> getLastPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) return null;

    final map = json.decode(jsonString);
    return PhotoData(
      imageBytes: _decodeBase64(map['imageBytes']),
      comment: map['comment'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Future<void> clearPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Uint8List _decodeBase64(String base64String) {
    return base64.decode(base64String);
  }
}

class PhotoData {
  final Uint8List imageBytes;
  final String comment;
  final DateTime timestamp;

  PhotoData({
    required this.imageBytes,
    required this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'imageBytes': base64.encode(imageBytes),
    'comment': comment,
    'timestamp': timestamp.toIso8601String(),
  };
}
