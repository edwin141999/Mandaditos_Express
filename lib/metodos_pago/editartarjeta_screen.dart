import 'package:flutter/material.dart';
import 'package:mandaditos_express/metodos_pago/desencriptar.dart';
import 'package:mandaditos_express/models/tarjetasinfo.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mandaditos_express/models/userinfo.dart';

class EditarTarjeta extends StatefulWidget {
  // final Color colorTarjeta;
  // final String imageTarjeta;
  // final Tarjeta tarjeta;
  // final User userInfo;
  // const EditarTarjeta(
  //     {Key? key,
  //     required this.colorTarjeta,
  //     required this.imageTarjeta,
  //     required this.tarjeta,
  //     required this.userInfo})
  //     : super(key: key);
  const EditarTarjeta({Key? key}) : super(key: key);

  @override
  State<EditarTarjeta> createState() => _EditarTarjetaState();
}

class _EditTarjetaData {
  String nombreCompleto = '';
  String mes = '';
  String year = '';
}

class EditCard extends _EditTarjetaData {}

class _EditarTarjetaState extends State<EditarTarjeta> {
  var mesNumero = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  var yearNumero = [
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030'
  ];

  String mesValue = '';
  String yearValue = '';
  String last4Value = '';
  String nameValue = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void updateTarjeta() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      editarTarjeta();
    }
  }

  void eliminarTarjeta() {
    deleteTarjeta();
  }

  EditCard data = EditCard();

  Future<void> editarTarjeta() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final tarjeta = arguments['tarjeta'] as Tarjeta;
    final userInfo = arguments['user'] as User;
    var url = Uri.parse('http://3.88.123.192/users/updateTarjeta');
    var reqBody = {};
    reqBody["id"] = tarjeta.id;
    reqBody["nombre_tarjeta"] = data.nombreCompleto;
    reqBody["year_expiracion"] = data.year;
    reqBody["month_expiracion"] = data.mes;
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    if (resp.statusCode == 200) {
      Navigator.pushReplacementNamed(
        context,
        '/cliente/tarjetas',
        arguments: {'user': userInfo},
      );
    }
  }

  Future<void> deleteTarjeta() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final tarjeta = arguments['tarjeta'] as Tarjeta;
    final userInfo = arguments['user'] as User;
    var url = Uri.parse('http://3.88.123.192/users/deleteTarjeta');
    var reqBody = {};
    reqBody["id"] = tarjeta.id;
    final resp = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    if (resp.statusCode == 200) {
      Navigator.pushReplacementNamed(
        context,
        '/cliente/tarjetas',
        arguments: {'user': userInfo},
      );
    }
  }

  @override
  void didChangeDependencies() {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final tarjeta = arguments['tarjeta'] as Tarjeta;
    mesValue = desencriptar(tarjeta.monthExpiracion);
    yearValue = desencriptar(tarjeta.yearExpiracion);
    nameValue = tarjeta.nombreTarjeta;
    List reversed = desencriptar(tarjeta.numeroTarjeta)
        .replaceAll(" ", "")
        .split('')
        .reversed
        .toList();
    var list = reversed.sublist(0, 4).reversed.toList();
    last4Value = list.join();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    final colorTarjeta = arguments['colorTarjeta'] as Color;
    final imageTarjeta = arguments['imageTarjeta'] as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarjeta',
            style: TextStyle(fontWeight: FontWeight.w400)),
        backgroundColor: const Color(0xff265C7E),
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset('assets/images/icon_back_arrow.png',
                scale: .8, color: Colors.white),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pushReplacementNamed(
                context,
                '/cliente/tarjetas',
                arguments: {'user': userInfo},
              );
            }),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
            child: Stack(
          children: [
            const FondoAzul(),
            const FondoBlanco(),
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: MediaQuery.of(context).size.height * 0.26,
                        decoration: BoxDecoration(
                          color: colorTarjeta,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: colorTarjeta.withOpacity(0.5),
                              offset: const Offset(0, 7),
                              blurRadius: 10,
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(imageTarjeta),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '****$last4Value',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Container(
                              height: 40,
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              child: TextFormField(
                                onSaved: (value) {
                                  data.nombreCompleto = value!;
                                },
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000),
                                ),
                                controller:
                                    TextEditingController(text: nameValue),
                                onChanged: (value) {
                                  nameValue = value;
                                },
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  fillColor: Color(0xffEEEEEE),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      margin: const EdgeInsets.only(bottom: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: 100,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffEEEEEE),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: DropdownButtonFormField(
                                                items: mesNumero.map(
                                                  (e) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                        e,
                                                        style: const TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      value: e,
                                                    );
                                                  },
                                                ).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    mesValue = value.toString();
                                                  });
                                                },
                                                value: mesValue,
                                                onSaved: (value) {
                                                  data.mes = value.toString();
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 2),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none),
                                                ),
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffEEEEEE),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: DropdownButtonFormField(
                                                items: yearNumero.map((e) {
                                                  return DropdownMenuItem(
                                                    child: Text(
                                                      e,
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    value: e,
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    yearValue =
                                                        value.toString();
                                                  });
                                                },
                                                onSaved: (value) {
                                                  data.year = value.toString();
                                                },
                                                value: yearValue,
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 2),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none),
                                                ),
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 220,
                        margin: const EdgeInsets.only(top: 50),
                        decoration: const BoxDecoration(
                          color: Color(0xff265C7E),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            updateTarjeta();
                          },
                          child: const Center(
                            child: Text(
                              'Actualizar Tarjeta',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 220,
                        margin: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                          color: Color(0xffF55151),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            eliminarTarjeta();
                          },
                          child: const Center(
                            child: Text(
                              'Eliminar Tarjeta',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.848,
      width: double.infinity,
      color: const Color(0xff265C7E),
    );
  }
}

class FondoBlanco extends StatelessWidget {
  const FondoBlanco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 155),
      decoration: const BoxDecoration(
        color: Color(0xffFBFBFB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }
}
