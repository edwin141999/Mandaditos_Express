import 'package:flutter/material.dart';
import 'package:mandaditos_express/metodos_pago/editartarjeta_screen.dart';

import 'creartarjeta_screen.dart';

class MetodosPagoScreen extends StatefulWidget {
  const MetodosPagoScreen({Key? key}) : super(key: key);

  @override
  State<MetodosPagoScreen> createState() => _MetodosPagoScreenState();
}

class _MetodosPagoScreenState extends State<MetodosPagoScreen> {
  var coloresBanco = [
    const Color(0xff143B6C),
    const Color(0xff056CAE),
    const Color(0xff056CAE),
    const Color(0xff83DC4E)
  ];
  var imagenesBanco = [
    'assets/images/bbva_logo.png',
    'assets/images/bbva_logo.png',
    'assets/images/banamex_logo.png',
    'assets/images/banamex_logo.png',
  ];

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
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const FondoAzul(),
            const FondoBlanco(),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  const BotonAgregar(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .758,
                    width: MediaQuery.of(context).size.height * 0.26,
                    child: ListView.builder(
                      itemCount: coloresBanco.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return BotonTarjeta(
                            color: coloresBanco[index],
                            image: imagenesBanco[index]);
                      },
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
  const BotonTarjeta({
    Key? key,
    required this.color,
    this.image = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditarTarjeta(colorTarjeta: color, imageTarjeta: image)),
        );
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
              blurRadius: 10,
            ),
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
  const BotonAgregar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CreaTarjetaScreen())),
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
