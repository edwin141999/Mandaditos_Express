import 'package:flutter/material.dart';
import 'package:mandaditos_express/splash/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Mandaditos Express',
        debugShowCheckedModeBanner: false,
        home: SplashView());
  }
}
