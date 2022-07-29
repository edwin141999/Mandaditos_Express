import 'package:flutter/material.dart';
import 'package:mandaditos_express/models/userinfo.dart';

class PerfilCliente extends StatefulWidget {
  const PerfilCliente({Key? key}) : super(key: key);

  @override
  State<PerfilCliente> createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
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
        flexibleSpace: SafeArea(
          child: Image.asset('assets/images/profile_logo.png',
              fit: BoxFit.contain),
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
                    Navigator.pushReplacementNamed(
                      context,
                      '/cliente/dashboard',
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
              height: MediaQuery.of(context).size.height * 0.55,
              child: Column(
                children: [
                  OpcionesPerfil(
                    widget: widget,
                    image: 'assets/images/icon_tarjeta.png',
                    title: 'Metodos de pago',
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      '/cliente/tarjetas',
                      arguments: {'user': userInfo},
                    ),
                  ),
                  const SizedBox(height: 30),
                  OpcionesPerfil(
                    widget: widget,
                    image: 'assets/images/icon_cerrar_sesion.png',
                    title: 'Cerrar sesión',
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
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

  final PerfilCliente widget;
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
