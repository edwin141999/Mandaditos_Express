import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mandaditos_express/models/userinfo.dart';

import 'package:mandaditos_express/styles/colors/colors_view.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DashboardRepartidor extends StatefulWidget {
  const DashboardRepartidor({Key? key}) : super(key: key);

  @override
  State<DashboardRepartidor> createState() => _DashboardRepartidorState();
}

class _DashboardRepartidorState extends State<DashboardRepartidor> {
  var estado = '';
  Future<void> actualizarEstado() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    var url = Uri.parse('http://34.193.105.11/users/cambiarEstado');
    var reqBody = {};
    reqBody['id'] = userInfo.datatype[0].id;
    reqBody['estado'] = 'Disponible';
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reqBody),
    );
    Map<String, dynamic> respBody = json.decode(resp.body);
    estado = respBody['update']['estado'];
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void inicializarUbicacion() async {
    await _getGeoLocationPosition();
  }

  @override
  void initState() {
    setState(() {
      inicializarUbicacion();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
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
                  Navigator.pushReplacementNamed(
                    context,
                    '/repartidor/perfil',
                    arguments: {'user': userInfo},
                  );
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
                        'Hola ${userInfo.user.firstName}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      Text(
                        'Usted esta en: ${userInfo.datatype[0].cityDrive}',
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
                Container(
                  height: MediaQuery.of(context).size.height * .751,
                  alignment: Alignment.center,
                  child: AccionesContainer(
                    text: 'Mandados disponibles',
                    image: 'assets/images/icon_solicitar.png',
                    colorContainer: ColorSelect.kContainerGreen,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/repartidor/mandadosDisponibles',
                        arguments: {'user': userInfo},
                      );
                    },
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
    return SizedBox(
      height: 200,
      child: Column(
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
          SizedBox(
            width: 140,
            child: Text(text,
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
