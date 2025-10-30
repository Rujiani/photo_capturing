import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class ApiService {
  static Future<void> uploadPhoto({
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

      request.files.add(await http.MultipartFile.fromPath('photo', imagePath));

      var response = await request.send();
      developer.log('Response status: ${response.statusCode}');
    } catch (e) {
      developer.log('Error uploading photo: $e');
      rethrow;
    }
  }
}
