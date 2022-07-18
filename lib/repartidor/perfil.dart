import 'package:flutter/material.dart';
import 'package:mandaditos_express/login/login_screen.dart';
import 'package:mandaditos_express/models/userinfo.dart';

class Perfil extends StatefulWidget {
  //final User userInfo;
  //const Perfil({Key? key, required this.userInfo}) : super(key: key);
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        toolbarHeight: 225,
        automaticallyImplyLeading: false,
        flexibleSpace: Image.asset(
          'assets/images/icon_profile.png',
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
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'usuario: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                // Text(
                //   widget.userInfo.user.firstName +
                //       ' ' +
                //       widget.userInfo.user.lastName,
                //   style: const TextStyle(
                //       color: Colors.black,
                //       fontSize: 22,
                //       fontWeight: FontWeight.bold),
                // ),
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
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/ubicacion 1.png'),
                      const SizedBox(width: 30),
                      GestureDetector(
                        child: const Text('Ciudades',
                            style: TextStyle(color: Colors.blue, fontSize: 20)),
                        // onTap: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const LoginScreen()),
                        // ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Image.asset(
                          'assets/images/icon_cerrar_sesion.png',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20, left: 30),
                        child: GestureDetector(
                          child: const Text('Cerrar sesión',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20)),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          ),
                        ),
                      ),
                    ],
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
