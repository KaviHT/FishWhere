import 'package:flutter/material.dart';
import '../widgets/file_dorpdown.dart';
import '../services/file_service.dart';
import '../views/record_form_page.dart';
import '../services/prediction_service.dart';
import '../widgets/prediction_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedFile;
  List<String> _files = [];
  bool _showPredictions = false;

  @override
  void initState() {
    super.initState();
    _listInputFiles();
  }

  Future<void> _listInputFiles() async {
    _files = await FileService.listInputFiles();
    setState(() {});
  }

  Future<void> _processFile(String fileName) async {
    bool success = await PredictionService.processFile(fileName);
    if (success) {
      setState(() {
        _showPredictions = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FishWhere Prediction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            FileDropdown(
                files: _files,
                onChanged: (value) => setState(() => _selectedFile = value),
                selectedFile: _selectedFile),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.cloud_upload),
              label: Text('Predict'),
              onPressed: _selectedFile != null
                  ? () => _processFile(_selectedFile!)
                  : null,
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecordFormPage())),
              child: Text('Go to Add Record Page'),
            ),
            Expanded(
              child: _showPredictions ? PredictionList() : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
