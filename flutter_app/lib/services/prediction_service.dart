import 'package:http/http.dart' as http;
import '../models/prediction.dart';
import 'dart:convert';

class PredictionService {
  static Future<bool> processFile(String fileName) async {
    var uri = Uri.parse('http://192.168.1.22:3000/process-file');
    // var uri = Uri.parse('http://10.31.8.26:3000/process-file');
    try {
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'fileName': fileName}));
      if (response.statusCode == 200) {
        print('File processed successfully');
        return true;
      } else {
        print('Failed to process file');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<List<Prediction>> fetchPredictions() async {
    var uri = Uri.parse('http://192.168.1.22:3000/predictions');
    // var uri = Uri.parse('http://10.31.8.26:3000/predictions');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Prediction.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
