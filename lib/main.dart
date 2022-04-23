import 'package:flutter/material.dart';
import 'package:pendulum/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pêndulo',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
