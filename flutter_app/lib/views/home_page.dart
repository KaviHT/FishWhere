import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/file_dropdown.dart';
import '../services/file_service.dart';
import '../views/record_form_page.dart';
import '../services/prediction_service.dart';
import '../widgets/prediction_list.dart';
import '../models/prediction.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedFile;
  List<String> _files = [];
  bool _showPredictions = false;
  bool _isLoading = false;
  List<LatLng> _predictionPoints = [];

  Future<void> _updatePredictions() async {
    // Fetch new predictions and update the map
    List<Prediction> predictions = await PredictionService.fetchPredictions();
    setState(() {
      _predictionPoints = predictions.map((p) => p.toLatLng()).toList();
    });
  }

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
    setState(() {
      _isLoading = true;
    });
    bool success = await PredictionService.processFile(fileName);
    if (success) {
      setState(() {
        _showPredictions = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
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
              onPressed: _selectedFile != null && !_isLoading
                  ? () => _processFile(_selectedFile!)
                  : null, // Disable button when loading
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
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
