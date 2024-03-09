import 'package:flutter/material.dart';

class APIEndpoints {
  static const String baseUrl = 'http://192.168.1.22:3000';
  static const String listInputFiles = '$baseUrl/list-input-files';
  static const String processFile = '$baseUrl/process-file';
  static const String predict = '$baseUrl/predict';
  static const String predictions = '$baseUrl/predictions';
  static const String addRecord = '$baseUrl/add-record';
}

class AppTheme {
  static const primaryColor = Colors.blueGrey;
  static const accentColor = Colors.blueAccent;
}

class AppStrings {
  static const appName = 'FishWhere Prediction';
  static const selectFileHint = 'Select a CSV file';
  static const predictButtonLabel = 'Predict';
  static const addRecordButtonLabel = 'Add Record';
  static const goToAddRecordPageButtonLabel = 'Go to Add Record Page';
  static const predictionListTitle = 'Predictions';
}
