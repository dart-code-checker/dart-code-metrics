import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boolean = MediaQuery.of(context).size.width > 300;
    final aLocalColor = boolean ? Colors.red : Colors.black;

    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          border: Border.all(color: aLocalColor),
        ),
      ),
    );
  }
}
