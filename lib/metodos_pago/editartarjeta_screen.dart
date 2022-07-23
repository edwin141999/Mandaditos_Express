import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mandaditos_express/metodos_pago/desencriptar.dart';
import 'package:mandaditos_express/metodos_pago/metodospago_screen.dart';
import 'package:mandaditos_express/models/tarjetasInfo.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mandaditos_express/models/userinfo.dart';

class EditarTarjeta extends StatefulWidget {
  final Color colorTarjeta;
  final String imageTarjeta;
  final Tarjeta tarjeta;
  final User userInfo;
  const EditarTarjeta(
      {Key? key,
      required this.colorTarjeta,
      required this.imageTarjeta,
      required this.tarjeta,
      required this.userInfo})
      : super(key: key);

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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MetodosPagoScreen(userInfo: widget.userInfo)));
    }
  }

  void eliminarTarjeta() {
    deleteTarjeta();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MetodosPagoScreen(userInfo: widget.userInfo)));
  }

  EditCard data = EditCard();

  Future<void> editarTarjeta() async {
    var url = Uri.parse('http://54.163.243.254:83/users/updateTarjeta');
    var reqBody = {};
    reqBody["id"] = widget.tarjeta.id;
    reqBody["nombre_tarjeta"] = data.nombreCompleto;
    reqBody["year_expiracion"] = data.year;
    reqBody["month_expiracion"] = data.mes;
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    log(resp.body);
  }

  Future<void> deleteTarjeta() async {
    var url = Uri.parse('http://54.163.243.254:83/users/deleteTarjeta');
    var reqBody = {};
    reqBody["id"] = widget.tarjeta.id;
    final resp = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    log(resp.body);
  }

  @override
  void initState() {
    mesValue = desencriptar(widget.tarjeta.monthExpiracion);
    yearValue = desencriptar(widget.tarjeta.yearExpiracion);
    nameValue = widget.tarjeta.nombreTarjeta;
    List reversed = desencriptar(widget.tarjeta.numeroTarjeta)
        .replaceAll(" ", "")
        .split('')
        .reversed
        .toList();
    var list = reversed.sublist(0, 4).reversed.toList();
    last4Value = list.join();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MetodosPagoScreen(
                            userInfo: widget.userInfo,
                          )));
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
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      height: 140,
                      width: MediaQuery.of(context).size.height * 0.26,
                      decoration: BoxDecoration(
                        color: widget.colorTarjeta,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: widget.colorTarjeta.withOpacity(0.5),
                            offset: const Offset(0, 7),
                            blurRadius: 10,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(widget.imageTarjeta),
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
                            margin: const EdgeInsets.only(top: 10, bottom: 30),
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
                                        0.82,
                                    margin: const EdgeInsets.only(bottom: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 150,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: DropdownButtonFormField(
                                              items: mesNumero.map((e) {
                                                return DropdownMenuItem(
                                                  child: Text(
                                                    e,
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  value: e,
                                                  // onTap: () {
                                                  //   mesValue = e;
                                                  // },
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  mesValue = value.toString();
                                                });
                                              },
                                              value: mesValue,
                                              onSaved: (value) {
                                                data.mes = value.toString();
                                              },
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              icon: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 70),
                                                child: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
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
                                                  yearValue = value.toString();
                                                });
                                              },
                                              onSaved: (value) {
                                                data.year = value.toString();
                                              },
                                              value: yearValue,
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              icon: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 50),
                                                child: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
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
