// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/prediction.dart';

// class ApiService {
//   static const String _baseUrl = 'https://192.168.1.22:3000';

//     Future<List<Prediction>> _fetchPredictions() async {
//     var uri = Uri.parse('$_baseUrl/predictions');
//     var response = await http.get(uri);
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((data) => Prediction.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load predictions');
//     }
//   }

//     // (DB) Method to submit record to backend
//   Future<void> _addRecord() async {
//     var uri = Uri.parse('http://192.168.1.22:3000/add-record');
//     // var uri = Uri.parse('http://10.31.8.26:3000/add-record');
//     var response = await http.post(uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           'date': double.tryParse(_dateController.text),
//           'lon': double.tryParse(_lonController.text),
//           'lat': double.tryParse(_latController.text),
//           'weight': double.tryParse(_weightController.text)
//         }));
//     if (response.statusCode == 200) {
//       print('Record added successfully');
//     } else {
//       print('Failed to add record');
//     }
//   }

// }