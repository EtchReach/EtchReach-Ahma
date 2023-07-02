import 'dart:typed_data';

import 'package:http/http.dart' as http;

class Networking {
  static Future<Uint8List?> fetchImage() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.31.131/capture'));
      // await http.get(Uri.parse('http://192.168.31.72:3000/capture'));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      // debugPrint('$e');
    }
    return null;
  }
}
