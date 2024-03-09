import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/prediction.dart';
import '../utils/constants.dart';

class PredictionService {
  static Future<bool> processFile(String fileName) async {
    var uri = Uri.parse(APIEndpoints.processFile);
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
    var uri = Uri.parse(APIEndpoints.predictions);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Prediction.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
