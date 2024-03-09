import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class FileService {
  static Future<List<String>> listInputFiles() async {
    // var uri = Uri.parse('$APIEndpoints.listInputFiles');
    var uri = Uri.parse('http://192.168.1.22:3000/list-input-files');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<String> files = List<String>.from(data['files']);
        return files;
      } else {
        print('Failed to load files');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<void> uploadFile(String filePath) async {
    var uri = Uri.parse('$APIEndpoints.predict');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed');
    }
  }
}
