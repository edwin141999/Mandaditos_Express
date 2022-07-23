import 'package:flutter/material.dart';
import 'package:mandaditos_express/login/login_screen.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/repartidor/menu.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Perfil extends StatefulWidget {
  final User userInfo;
  const Perfil({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Future<void> actualizarEstado() async {
    var url = Uri.parse('http://54.163.243.254:81/users/cambiarEstado');
    var reqBody = {};
    reqBody['id'] = widget.userInfo.datatype[0].id;
    reqBody['estado'] = 'No Disponible';
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reqBody),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 223,
        automaticallyImplyLeading: false,
        flexibleSpace:
            Image.asset('assets/images/profile_logo.png', fit: BoxFit.contain),
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                menuM(userInfo: widget.userInfo)));
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
              height: MediaQuery.of(context).size.height * .55,
              child: Column(
                children: [
                  OpcionesPerfil(
                    image: 'assets/images/icon_cerrar_sesion.png',
                    title: 'Cerrar sesión',
                    onTap: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      ),
                      actualizarEstado()
                    },
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
      {Key? key, required this.image, required this.title, required this.onTap})
      : super(key: key);

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
