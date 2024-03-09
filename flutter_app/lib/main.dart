import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishWhere Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        buttonTheme: ButtonThemeData(buttonColor: Colors.blueAccent),
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.blueGrey[900])),
      ),
      home: HomePage(),
    );
  }
}
