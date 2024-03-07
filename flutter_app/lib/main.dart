import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// Prediction model
// This class helps in parsing the JSON data fetched from the backend
class Prediction {
  final double lon;
  final double lat;

  Prediction({required this.lon, required this.lat});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      lon: json['lon'],
      lat: json['lat'],
    );
  }
}

class _MyAppState extends State<MyApp> {
  String? _selectedFile;
  List<String> _files = [];
  bool _showPredictions = false;

  // (DB) Add TextEditingController for each input field
  TextEditingController _dateController = TextEditingController();
  TextEditingController _lonController = TextEditingController();
  TextEditingController _latController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // (DB) Method to pick date
  // void _pickDate() {
  //   DatePicker.showDatePicker(context,
  //       showTitleActions: true,
  //       minTime: DateTime(2000, 1, 1),
  //       maxTime: DateTime.now(), onConfirm: (date) {
  //     setState(() {
  //       _selectedDate = date;
  //       _dateController.text =
  //           date.toString().split(' ')[0]; // Format date as YYYY-MM-DD
  //     });
  //   }, currentTime: DateTime.now(), locale: LocaleType.en);
  // }

  // MODIFY
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = picked.toString().split(
            ' ')[0]; // Assuming you have a TextEditingController for the date
      });
    }
  }

  // (DB) Method to submit record to backend
  Future<void> _addRecord() async {
    // var uri = Uri.parse('http://192.168.1.22:3000/add-record');
    var uri = Uri.parse('http://10.31.8.26:3000/add-record');
    var response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'date': _selectedDate.toIso8601String(),
          'lon': double.tryParse(_lonController.text),
          'lat': double.tryParse(_latController.text),
          'weight': double.tryParse(_weightController.text)
        }));
    if (response.statusCode == 200) {
      print('Record added successfully');
    } else {
      print('Failed to add record');
    }
  }

  @override
  void initState() {
    super.initState();
    _listInputFiles();
  }

  // This is for testing only in this machine
  // Future<void> _listInputFiles() async {
  //   final directory = (await getApplicationDocumentsDirectory()).path;
  //   final inputDir = Directory('$directory/FishWhere/model_service/inputs');
  //   final files = inputDir
  //       .listSync()
  //       .map((item) => item.path)
  //       .where((item) => item.endsWith('.csv'))
  //       .toList();
  //   setState(() {
  //     _files = files;
  //   });
  // }

  Future<void> _listInputFiles() async {
    // var uri = Uri.parse('http://192.168.1.22:3000/list-input-files');
    var uri = Uri.parse('http://10.31.8.26:3000/list-input-files');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<String> files = List<String>.from(data['files']);
        setState(() {
          _files = files;
        });
      } else {
        print('Failed to load files');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Instead of uploading the file, it will now send the filename to the new backend endpoint for processing.
  Future<void> _processFile(String fileName) async {
    // var uri = Uri.parse('http://192.168.1.22:3000/process-file');
    var uri = Uri.parse('http://10.31.8.26:3000/process-file');
    try {
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'fileName': fileName}));
      if (response.statusCode == 200) {
        print('File processed successfully');
        setState(() {
          _showPredictions = true; // Show predictions after processing
        });
      } else {
        print('Failed to process file');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // This uploads the file to Node server
  Future<void> _uploadFile(String filePath) async {
    // var uri = Uri.parse('http://192.168.1.22:3000/predict');
    var uri = Uri.parse('http://10.31.8.26:3000/predict');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed');
    }
  }

  Future<List<Prediction>> _fetchPredictions() async {
    // var uri = Uri.parse('http://192.168.1.22:3000/predictions');
    var uri = Uri.parse('http://10.31.8.26:3000/predictions');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Prediction.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        buttonTheme: ButtonThemeData(buttonColor: Colors.blueAccent),
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.blueGrey[900])),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('FishWhere Prediction'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            // Added to ensure the view scrolls if content exceeds screen size
            child: Column(
              children: <Widget>[
                // // Beginning of form widgets
                // TextFormField(
                //   controller: _dateController,
                //   decoration: InputDecoration(labelText: 'Date'),
                //   readOnly: true,
                //   // onTap: _pickDate,
                // ),
                // TextFormField(
                //   controller: _lonController,
                //   decoration: InputDecoration(labelText: 'Longitude'),
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                // ),
                // TextFormField(
                //   controller: _latController,
                //   decoration: InputDecoration(labelText: 'Latitude'),
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                // ),
                // TextFormField(
                //   controller: _weightController,
                //   decoration: InputDecoration(labelText: 'Weight (kg)'),
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                // ),
                // ElevatedButton(
                //   onPressed: _addRecord,
                //   child: Text('Add Record'),
                // ),
                // End of form widgets
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Select a CSV file'),
                    value: _selectedFile,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFile = newValue!;
                      });
                    },
                    items: _files.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.split('/').last),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.cloud_upload),
                  label: Text('Predict'),
                  onPressed: () {
                    print("Button is working!");
                    if (_selectedFile != null) {
                      _processFile(_selectedFile!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
                _showPredictions
                    ? Expanded(
                        child: FutureBuilder<List<Prediction>>(
                          future: _fetchPredictions(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        'Longitude: ${snapshot.data![index].lon}, Latitude: ${snapshot.data![index].lat}'),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
