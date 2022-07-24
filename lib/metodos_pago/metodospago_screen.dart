import 'package:flutter/material.dart';
import 'package:mandaditos_express/metodos_pago/desencriptar.dart';
import 'package:mandaditos_express/metodos_pago/editartarjeta_screen.dart';
import 'package:mandaditos_express/models/tarjetasInfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/cliente/perfil_cliente.dart';
import 'creartarjeta_screen.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MetodosPagoScreen extends StatefulWidget {
  final User userInfo;
  const MetodosPagoScreen({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<MetodosPagoScreen> createState() => _MetodosPagoScreenState();
}

class _MetodosPagoScreenState extends State<MetodosPagoScreen> {
  var coloresBanco = [
    const Color(0xff143B6C),
    const Color(0xff056CAE),
    const Color(0xffE00000),
    const Color(0xffE00000),
    const Color(0xffF2F2F2),
    const Color(0xffF2F2F2),
  ];
  var imagenesBanco = [
    'assets/images/bbva_logo.png',
    'assets/images/banamex_logo.png',
    'assets/images/santander_blanco_logo.png',
    'assets/images/banorte_blanco_logo.png',
    'assets/images/hsbc_logo.png',
    'assets/images/scotiabank_logo.png',
  ];

  TarjetasInfo tarjetasCliente = TarjetasInfo(tarjetas: []);
  var nombreBanco = [];

  Future<TarjetasInfo> getTarjetasCliente() async {
    var url = Uri.parse('http://3.95.107.222/users/getTarjetas');
    var reqBody = {};
    reqBody['user_id'] = widget.userInfo.user.id;
    final resp = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody));

    tarjetasCliente = TarjetasInfo.fromJson(jsonDecode(resp.body));
    nombreBanco.clear();
    for (var tarjeta in tarjetasCliente.tarjetas) {
      if (tarjeta.nombreBanco != null) {
        nombreBanco.add(desencriptar(tarjeta.nombreBanco));
      } else {
        nombreBanco.add(tarjeta.nombreBanco);
      }
    }
    return tarjetasCliente;
  }

  @override
  void initState() {
    getTarjetasCliente();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metodos de Pago',
            style: TextStyle(fontWeight: FontWeight.w400)),
        backgroundColor: const Color(0xff265C7E),
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset('assets/images/icon_back_arrow.png',
                scale: .8, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PerfilCliente(
                            userInfo: widget.userInfo,
                          )));
            }),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const FondoAzul(),
            const FondoBlanco(),
            SizedBox(
              // height: MediaQuery.of(context).size.height,
              // height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  BotonAgregar(userInfo: widget.userInfo),
                  Expanded(
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * .758,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.height * 0.26,
                      child: FutureBuilder(
                        future: getTarjetasCliente(),
                        builder:
                            (context, AsyncSnapshot<TarjetasInfo> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                              itemCount: nombreBanco.length,
                              itemBuilder: (context, index) {
                                if (nombreBanco[index] == 'Bancomer') {
                                  return BotonTarjeta(
                                      color: coloresBanco[0],
                                      image: imagenesBanco[0],
                                      tarjeta: snapshot.data!.tarjetas[index],
                                      userInfo: widget.userInfo);
                                }
                                if (nombreBanco[index] == 'Banamex') {
                                  return BotonTarjeta(
                                    color: coloresBanco[1],
                                    image: imagenesBanco[1],
                                    tarjeta: snapshot.data!.tarjetas[index],
                                    userInfo: widget.userInfo,
                                  );
                                }
                                if (nombreBanco[index] == 'Santander') {
                                  return BotonTarjeta(
                                      color: coloresBanco[2],
                                      image: imagenesBanco[2],
                                      tarjeta: snapshot.data!.tarjetas[index],
                                      userInfo: widget.userInfo);
                                }
                                if (nombreBanco[index] == 'Banorte') {
                                  return BotonTarjeta(
                                      color: coloresBanco[3],
                                      image: imagenesBanco[3],
                                      tarjeta: snapshot.data!.tarjetas[index],
                                      userInfo: widget.userInfo);
                                }
                                if (nombreBanco[index] == 'HSBC') {
                                  return BotonTarjeta(
                                      color: coloresBanco[4],
                                      image: imagenesBanco[4],
                                      tarjeta: snapshot.data!.tarjetas[index],
                                      userInfo: widget.userInfo);
                                }
                                if (nombreBanco[index] == 'Scotiabank') {
                                  return BotonTarjeta(
                                      color: coloresBanco[5],
                                      image: imagenesBanco[5],
                                      tarjeta: snapshot.data!.tarjetas[index],
                                      userInfo: widget.userInfo);
                                } else {
                                  return const BotonTarjeta(
                                      color: Color(0xff83DC4E), image: '');
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FondoAzul extends StatelessWidget {
  const FondoAzul({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.848,
            width: double.infinity,
            color: const Color(0xff265C7E))
      ],
    );
  }
}

class BotonTarjeta extends StatelessWidget {
  final Color color;
  final String image;
  final dynamic tarjeta;
  final dynamic userInfo;
  const BotonTarjeta(
      {Key? key,
      required this.color,
      this.image = '',
      this.tarjeta,
      this.userInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        image != ''
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditarTarjeta(
                        colorTarjeta: color,
                        imageTarjeta: image,
                        tarjeta: tarjeta,
                        userInfo: userInfo)),
              )
            : null;
      },
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        height: 140,
        width: MediaQuery.of(context).size.height * 0.26,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.5),
                offset: const Offset(0, 7),
                blurRadius: 10),
          ],
          image: image != '' ? DecorationImage(image: AssetImage(image)) : null,
        ),
        child: image == ''
            ? const Center(
                child: Text('Efectivo',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white)))
            : null,
      ),
    );
  }
}

class FondoBlanco extends StatelessWidget {
  const FondoBlanco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xffFBFBFB),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
    );
  }
}

class BotonAgregar extends StatelessWidget {
  final User userInfo;
  const BotonAgregar({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreaTarjetaScreen(userInfo: userInfo))),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.4),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          size: 35,
          color: Color(0xff000000),
        ),
      ),
    );
  }
}
