import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandaditos Express',
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.blue,
        child: const Center(
          child: Text(
            'Hola mundo',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
