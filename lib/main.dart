import 'package:flutter/material.dart';
import 'package:notes/pages/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF222939),
        buttonColor: Color(0xFF4d67c8),
      ),
      home: HomePage(),
    );
  }
}
