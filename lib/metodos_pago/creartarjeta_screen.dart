import 'package:flutter/material.dart';
import 'package:mandaditos_express/models/userinfo.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class CreaTarjetaScreen extends StatefulWidget {
  const CreaTarjetaScreen({Key? key}) : super(key: key);

  @override
  State<CreaTarjetaScreen> createState() => _CreaTarjetaScreenState();
}

class _TarjetaData {
  String nombreBanco = '';
  String numeroTarjeta = '';
  String mes = '';
  String year = '';
  String cvv = '';
  String nombreCompleto = '';
}

class CardData extends _TarjetaData {}

class _CreaTarjetaScreenState extends State<CreaTarjetaScreen> {
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

  var colorMuestra = const Color(0xffA1A1A1);
  var imagenMuestra = '';

  String mesValue = '01';
  String yearValue = '2022';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void guardarTarjeta() {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      crearTarjeta();
      Navigator.pushReplacementNamed(
        context,
        '/cliente/tarjetas',
        arguments: {'user': userInfo},
      );
    }
  }

  CardData data = CardData();

  Future<void> crearTarjeta() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    var url = Uri.parse('http://3.95.107.222/users/createTarjeta');
    var reqBody = {};
    reqBody['user_id'] = userInfo.user.id;
    reqBody['cvv'] = data.cvv;
    reqBody['month_expiracion'] = data.mes;
    reqBody['nombre_tarjeta'] = data.nombreCompleto;
    reqBody['numero_tarjeta'] = data.numeroTarjeta;
    reqBody['year_expiracion'] = data.year;
    reqBody['nombre_banco'] = data.nombreBanco;
    await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody));
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Tarjeta de Debito',
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
        child: SafeArea(
          child: Stack(
            children: [
              const FondoAzul(),
              const FondoBlanco(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ColorTarjeta(color: colorMuestra, image: imagenMuestra),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Numero de Tarjeta',
                              style: TextStyle(fontSize: 18)),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 10, bottom: 30),
                            child: TextFormField(
                              onSaved: (value) {
                                data.numeroTarjeta = value!;
                              },
                              onChanged: (value) {
                                if (value.startsWith('415231') ||
                                    value.startsWith('455549') ||
                                    value.startsWith('455528') ||
                                    value.startsWith('455548')) {
                                  setState(() {
                                    colorMuestra = coloresBanco[0];
                                    imagenMuestra = imagenesBanco[0];
                                    data.nombreBanco = 'Bancomer';
                                  });
                                } else if (value.startsWith('554492') ||
                                    value.startsWith('429522') ||
                                    value.startsWith('520698') ||
                                    value.startsWith('525678')) {
                                  setState(() {
                                    colorMuestra = coloresBanco[1];
                                    imagenMuestra = imagenesBanco[1];
                                    data.nombreBanco = 'Banamex';
                                  });
                                } else if (value.startsWith('557910') ||
                                    value.startsWith('557907') ||
                                    value.startsWith('557909') ||
                                    value.startsWith('475714') ||
                                    value.startsWith('471952')) {
                                  setState(() {
                                    colorMuestra = coloresBanco[2];
                                    imagenMuestra = imagenesBanco[2];
                                    data.nombreBanco = 'Santander';
                                  });
                                } else if (value.startsWith('491566')) {
                                  setState(() {
                                    colorMuestra = coloresBanco[3];
                                    imagenMuestra = imagenesBanco[3];
                                    data.nombreBanco = 'Banorte';
                                  });
                                } else if (value.startsWith('430967569') ||
                                    value.startsWith('49108935') ||
                                    value.startsWith('491089682') ||
                                    value.startsWith('491089630') ||
                                    value.startsWith('491089710') ||
                                    value.startsWith('491089921') ||
                                    value.startsWith('491089726') ||
                                    value.startsWith('49108902')) {
                                  setState(() {
                                    colorMuestra = coloresBanco[4];
                                    imagenMuestra = imagenesBanco[4];
                                    data.nombreBanco = 'HSBC';
                                  });
                                } else if (value.startsWith('557922') ||
                                    value.startsWith('557920')) {
                                  setState(() {
                                    colorMuestra = coloresBanco[5];
                                    imagenMuestra = imagenesBanco[5];
                                    data.nombreBanco = 'Scotiabank';
                                  });
                                } else {
                                  setState(() {
                                    colorMuestra = const Color(0xffA1A1A1);
                                    imagenMuestra = '';
                                  });
                                }
                              },
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000)),
                              keyboardType: TextInputType.number,
                              maxLength: 16,
                              decoration: const InputDecoration(
                                isDense: true,
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: '1234567890123456',
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
                                  const Text('Fecha de expiración',
                                      style: TextStyle(fontSize: 18)),
                                  Container(
                                    height: 40,
                                    width: 165,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 70,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Center(
                                            child: DropdownButtonFormField(
                                              items: mesNumero.map((e) {
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
                                                  mesValue = value.toString();
                                                });
                                              },
                                              onSaved: (value) {
                                                data.mes = value.toString();
                                              },
                                              value: mesValue,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              icon: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffEEEEEE),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Center(
                                            child: DropdownButtonFormField(
                                              items: yearNumero.map((e) {
                                                return DropdownMenuItem(
                                                  child: Text(
                                                    e,
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  value: e,
                                                  onTap: () {
                                                    setState(() {
                                                      data.year = e;
                                                    });
                                                  },
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
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                              icon: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                  size: 20,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('CVV',
                                      style: TextStyle(fontSize: 18)),
                                  Container(
                                    height: 40,
                                    width: 100,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 30),
                                    child: TextFormField(
                                      onSaved: (value) {
                                        data.cvv = value!;
                                      },
                                      keyboardType: TextInputType.number,
                                      maxLength: 3,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                      ),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        counterText: '',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        hintText: '123',
                                        fillColor: Color(0xffEEEEEE),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Text('Nombre', style: TextStyle(fontSize: 18)),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.only(top: 10, bottom: 5),
                            child: TextFormField(
                              onSaved: (value) {
                                data.nombreCompleto = value!;
                              },
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff000000),
                              ),
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: 'Nombre Completo',
                                fillColor: Color(0xffEEEEEE),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 220,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                        color: Color(0xff265C7E),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          guardarTarjeta();
                        },
                        child: const Center(
                          child: Text(
                            'Agregar Tarjeta',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ColorTarjeta extends StatelessWidget {
  final Color color;
  final String image;
  const ColorTarjeta({
    Key? key,
    required this.color,
    this.image = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      height: 140,
      width: MediaQuery.of(context).size.height * 0.26,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            offset: const Offset(0, 7),
            blurRadius: 10,
          ),
        ],
        image: image != '' ? DecorationImage(image: AssetImage(image)) : null,
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
