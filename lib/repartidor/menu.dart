import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/repartidor/pedidosP.dart';
import 'package:mandaditos_express/repartidor/perfil.dart';

import 'package:mandaditos_express/styles/colors/colors_view.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class menuM extends StatefulWidget {
  final User userInfo;
  const menuM({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<menuM> createState() => _menuMState();
}

class _menuMState extends State<menuM> {
  var estado = '';
  Future<void> actualizarEstado() async {
    var url = Uri.parse('http://54.163.243.254:81/users/cambiarEstado');
    var reqBody = {};
    reqBody['id'] = widget.userInfo.datatype[0].id;
    reqBody['estado'] = 'Disponible';
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reqBody),
    );
    Map<String, dynamic> respBody = json.decode(resp.body);
    // log(respBody['update']['estado'].toString());
    estado = respBody['update']['estado'];
    // log(resp.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: 35,
              child: GestureDetector(
                child: Image.asset(
                  'assets/images/icon_profile.png',
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    // return ProfileScreen(userInfo: widget.userInfo);
                    return const Perfil();
                  }));
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola ${widget.userInfo.user.firstName}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      Text(
                        'Usted esta en: ${widget.userInfo.datatype[0].cityDrive}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xff28FB24),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                          ),
                          FutureBuilder(
                            future: actualizarEstado(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Text(
                                  'Estado: $estado',
                                  style: const TextStyle(fontSize: 16),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: AccionesContainer(
                          text: 'Mandados disponibles',
                          image: 'assets/images/icon_solicitar.png',
                          colorContainer: ColorSelect.kContainerGreen,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return  pedidosP(userInfo: widget.userInfo);
                            }));
                          },
                        ),
                        // child: ListView.builder(
                        //   itemCount: textInfo.length,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return AccionesContainer(
                        //       image: imgInfo[index],
                        //       text: textInfo[index],
                        //       colorContainer: colorInfo[index],
                        //       onTap: () {
                        //         Navigator.push(context,
                        //             MaterialPageRoute(builder: (context) {
                        //           return const pedidosP();
                        //         }));
                        //       },
                        //     );
                        //   },
                        // ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccionesContainer extends StatelessWidget {
  final String image, text;
  final Color colorContainer;
  final Function() onTap;
  const AccionesContainer({
    Key? key,
    required this.image,
    required this.text,
    required this.colorContainer,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            key: UniqueKey(),
            child: Container(
              width: 160,
              height: 130,
              decoration: BoxDecoration(
                color: colorContainer.withOpacity(.42),
                borderRadius: BorderRadius.circular(17),
                image: DecorationImage(image: AssetImage(image), scale: .8),
              ),
            ),
            onTap: onTap),
        Container(
          width: 140,
          margin: const EdgeInsets.only(bottom: 30),
          child: Text(text,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
