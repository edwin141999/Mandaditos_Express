import 'package:flutter/material.dart';
import 'package:mandaditos_express/dashboard/dashboard_screen.dart';
import 'package:mandaditos_express/login/login_screen.dart';
import 'package:mandaditos_express/metodos_pago/metodospago_screen.dart';
import 'package:mandaditos_express/models/userinfo.dart';

class ProfileScreen extends StatefulWidget {
  final User userInfo;
  const ProfileScreen({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 223,
        automaticallyImplyLeading: false,
        flexibleSpace: Image.asset(
          'assets/images/profile_logo.png',
          fit: BoxFit.contain,
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Image.asset('assets/images/icon_back_arrow.png',
                      scale: .8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Dashboard(userInfo: widget.userInfo),
                      ),
                    );
                  },
                ),
                Text(
                  widget.userInfo.user.firstName +
                      ' ' +
                      widget.userInfo.user.lastName,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
        // title:
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Column(
                children: [
                  OpcionesPerfil(
                    widget: widget,
                    image: 'assets/images/icon_tarjeta.png',
                    title: 'Metodos de pago',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MetodosPagoScreen(userInfo: widget.userInfo)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  OpcionesPerfil(
                    widget: widget,
                    image: 'assets/images/icon_cerrar_sesion.png',
                    title: 'Cerrar sesión',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OpcionesPerfil extends StatelessWidget {
  const OpcionesPerfil(
      {Key? key,
      required this.widget,
      required this.image,
      required this.title,
      required this.onTap})
      : super(key: key);

  final ProfileScreen widget;
  final String image, title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(image),
        const SizedBox(width: 30),
        GestureDetector(
            child: Text(title,
                style: const TextStyle(color: Colors.blue, fontSize: 20)),
            onTap: onTap),
      ],
    );
  }
}
