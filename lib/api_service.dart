import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:io';
import 'package:photo_capturing/photo_repository.dart';

class ApiService {
  static Future<void> uploadAndSavePhoto({
    required String imagePath,
    required String comment,
    required double latitude,
    required double longitude,
  }) async {
    try {
      File imageFile = File(imagePath);
      Uint8List imageBytes = await imageFile.readAsBytes();
      DateTime timestamp = DateTime.now();

      await Future.wait([
        _uploadToServer(
          imageBytes: imageBytes,
          imagePath: imagePath,
          comment: comment,
          latitude: latitude,
          longitude: longitude,
        ),
        PhotoRepositoryImpl().savePhoto(
          PhotoData(
            imageBytes: imageBytes,
            comment: comment,
            timestamp: timestamp,
          ),
        ),
      ]);
    } catch (e) {
      developer.log('Error in uploadAndSavePhoto: $e');
      rethrow;
    }
  }

  static Future<void> _uploadToServer({
    required Uint8List imageBytes,
    required String imagePath,
    required String comment,
    required double latitude,
    required double longitude,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://flutter-sandbox.free.beeceptor.com/upload_photo/'),
      );

      request.headers['Content-Type'] = 'application/javascript';

      request.fields['comment'] = comment;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();

      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          imageBytes,
          filename: imagePath.split('/').last,
        ),
      );

      var response = await request.send();
      developer.log('Response status: ${response.statusCode}');
    } catch (e) {
      developer.log('Error uploading photo: $e');
      rethrow;
    }
  }
}
