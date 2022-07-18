import 'package:flutter/material.dart';
import 'package:mandaditos_express/splash/splash_view.dart';
import 'package:mandaditos_express/monitoreo/pedido_monitoreo_user.dart';
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
        home: pedido_monitoreo_user(title: "monitoreo e pedido"));
  }
} 
