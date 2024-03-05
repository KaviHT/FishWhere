import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _selectedFile;
  List<String> _files = [];

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
    var uri = Uri.parse('http://192.168.1.22:3000/list-input-files');
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
    var uri = Uri.parse('http://192.168.1.22:3000/process-file');
    try {
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'fileName': fileName}));
      if (response.statusCode == 200) {
        print('File processed successfully');
      } else {
        print('Failed to process file');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // This uploads the file to Node server
  Future<void> _uploadFile(String filePath) async {
    var uri = Uri.parse('http://192.168.1.22:3000/predict');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FishWhere Prediction'),
        ),
        body: Column(
          children: <Widget>[
            DropdownButton<String>(
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
            ElevatedButton(
              onPressed: () {
                print("Button is working!");
                if (_selectedFile != null) {
                  // _uploadFile(_selectedFile!);
                  _processFile(_selectedFile!);
                }
              },
              child: Text('Predict'),
            ),
          ],
        ),
      ),
    );
  }
}
