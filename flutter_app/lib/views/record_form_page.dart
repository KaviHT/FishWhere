import 'package:flutter/material.dart';
import '../services/record_service.dart';

class RecordFormPage extends StatefulWidget {
  @override
  _RecordFormPageState createState() => _RecordFormPageState();
}

class _RecordFormPageState extends State<RecordFormPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Future<void> _addRecord() async {
    bool success = await RecordService.addRecord(
      date: _dateController.text,
      lon: _lonController.text,
      lat: _latController.text,
      weight: _weightController.text,
    );
    if (success) {
      // Optionally, show a message or navigate back
      print('Record added successfully');
    } else {
      print('Failed to add record');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Record'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date')),
            TextFormField(
                controller: _lonController,
                decoration: InputDecoration(labelText: 'Longitude')),
            TextFormField(
                controller: _latController,
                decoration: InputDecoration(labelText: 'Latitude')),
            TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)')),
            ElevatedButton(onPressed: _addRecord, child: Text('Add Record')),
          ],
        ),
      ),
    );
  }
}
