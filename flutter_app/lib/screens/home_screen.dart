import 'package:flutter/material.dart';
import '../services/files_service.dart';
import '../services/file_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FilesService _filesService = FilesService();
  final FileService _fileService = FileService();
  List<String> _fileNames = [];
  String? _selectedFile;

  @override
  void initState() {
    super.initState();
    _fetchFileNames();
  }

  _fetchFileNames() async {
    try {
      List<String> fileNames = await _filesService.fetchCsvFilenames();
      setState(() {
        _fileNames = fileNames;
      });
    } catch (e) {
      // Handle exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select CSV File'),
      ),
      body: Center(
        child: DropdownButton<String>(
          hint: Text("Select a file"),
          value: _selectedFile,
          onChanged: (String? newValue) {
            setState(() {
              _selectedFile = newValue!;
              // Trigger the prediction request for the selected file here
            });
          },
          items: _fileNames.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
