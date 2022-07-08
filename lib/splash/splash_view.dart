import 'package:flutter/material.dart';
import 'package:mandaditos_express/login/login_screen.dart';
import 'dart:async';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _toOnboarding();
  }

  _toOnboarding() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset('assets/images/Logo.png')),
      ),
    );
  }
}
