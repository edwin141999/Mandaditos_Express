import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:mandaditos_express/models/pedidoinfo.dart';
import 'package:http/http.dart' as http;
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class confirmarP extends StatefulWidget {
  final PedidoElement pedidoInfo;
  //const Perfil({Key? key, required this.userInfo}) : super(key: key);
  const confirmarP({Key? key, required this.pedidoInfo}) : super(key: key);

  @override
  State<confirmarP> createState() => _confirmarPState();
}

class _confirmarPState extends State<confirmarP> {
  Future<Pedido> getMandados() async {
    var url = Uri.parse('http://54.163.243.254:81/users/mostrarMandados');

    final resp =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    //pedidosInfo = Pedido.fromJson(jsonDecode(resp.body));

    return pedidoFromJson(resp.body);
    //return pedidosInfo;
  }

  @override
  Widget build(BuildContext context) {
    int sumaTotal = int.parse(widget.pedidoInfo.subtotal) +
        int.parse(widget.pedidoInfo.item.precioProducto);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Descripción del Mandado',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: SizedBox(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              GestureDetector(
                child:
                    Image.asset('assets/images/icon_back_arrow.png', scale: .8),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ])),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: ColorSelect.cardP,
              width: 400,
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                '\nProducto: ${widget.pedidoInfo.item.tipoProducto}\n'
                '\nDescripción: ${widget.pedidoInfo.item.descripcion}\n '
                '\nUbicación: ${widget.pedidoInfo.cliente.direccion}\n'
                '\nMetodo de Pago: ${widget.pedidoInfo.cliente.users.tipopago[0].metodo}\n'
                '\nTotal: \$ ${sumaTotal}\n',
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.green,
              width: 400,
              height: 300,
              //padding: const EdgeInsets.only(left: 30),
              child: const Center(
                child: Text(
                  'Falta el mapa ',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
              color: Colors.lightBlue,
              child: const Text('Tomar orden',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          )
        ],
      ),
    );
  }
}
