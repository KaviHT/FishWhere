import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordService {
  static Future<bool> addRecord({
    required String date,
    required String lon,
    required String lat,
    required String weight,
  }) async {
    var uri = Uri.parse('http://192.168.1.22:3000/add-record');
    // var uri = Uri.parse('http://10.31.8.26:3000/add-record');
    try {
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'date': double.tryParse(date),
            'lon': double.tryParse(lon),
            'lat': double.tryParse(lat),
            'weight': double.tryParse(weight)
          }));
      if (response.statusCode == 200) {
        print('Record added successfully');
        return true;
      } else {
        print('Failed to add record');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
