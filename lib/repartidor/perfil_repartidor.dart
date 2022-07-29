import 'package:flutter/material.dart';
import 'package:mandaditos_express/models/userinfo.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PerfilRepartidor extends StatefulWidget {
  const PerfilRepartidor({Key? key}) : super(key: key);

  @override
  State<PerfilRepartidor> createState() => _PerfilRepartidorState();
}

class _PerfilRepartidorState extends State<PerfilRepartidor> {
  Future<void> actualizarEstado() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    var url = Uri.parse('http://34.193.105.11/users/cambiarEstado');
    var reqBody = {};
    reqBody['id'] = userInfo.datatype[0].id;
    reqBody['estado'] = 'No Disponible';
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reqBody),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
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
                    Navigator.pushReplacementNamed(
                      context,
                      '/repartidor/dashboard',
                      arguments: {'user': userInfo},
                    );
                  },
                ),
                Text(
                  userInfo.user.firstName + ' ' + userInfo.user.lastName,
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
                      Navigator.pushReplacementNamed(context, '/login'),
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
