import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/pedidoinfo.dart';
import 'dart:convert';


class reciboCompra extends StatefulWidget {
  const reciboCompra({Key? key}) : super(key: key);

  @override
  State<reciboCompra> createState() => _reciboCompraState();
}

class _reciboCompraState extends State<reciboCompra> {
  // Pedido pedidosInfo = Pedido(pedidos: []);

  /*
  Future<Pedido> getPedidos() async {
    var url = Uri.parse('http://54.163.243.254:81/users/mostrarMandados');
    final resp =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    pedidosInfo = Pedido.fromJson(jsonDecode(resp.body));
    return pedidoFromJson(resp.body);
  }
  */
  
  /*
  @override
  void initState() {
    getPedidos();
    super.initState();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black.withOpacity(0.7)
          ),
        ),
        title: Container(
          child: Row(
            children:  [
              Image.asset(
                'assets/images/Logo.png',
                height: 50,
                width: 50,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35)
              ),
              const Text(
                'Pedido: #1', 
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              
              Image.asset(
                'assets/images/cuenta.png',
                height: 50,
                width: 50,
              ),
            ],
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider (
              color: Colors.black,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 140),
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'Usuario: Juan Jose\n'
                      'Ave.Central.Ote\n'
                      'Entre 4ta y 5ta Oriente\n'
                      'Suchiapa, Chiapas',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ]
              ),
            ),
            // Tabla
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: 350,
              height: 225,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Table(
                        border: TableBorder.all(),
                        children: const [
                          TableRow(
                            decoration: BoxDecoration(color: Color.fromARGB(255, 22, 87, 199)),
                            children: [
                              Text(
                                'Producto',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                              Text(
                                'Cantidad',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                              Text(
                                'Precio',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                              Text(
                                'Subtotal',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                            ]
                          ),
                          TableRow(
                            decoration: BoxDecoration(color: Colors.white),
                            children: [
                              Text(
                                'Coca-cola',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '3',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '20',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '60',
                                textAlign: TextAlign.center
                              ),
                            ]
                          ),
                          TableRow(
                            decoration: BoxDecoration(color: Colors.white),
                            children: [
                              Text(
                                'Paquetaxo',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '2',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '15',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '30',
                                textAlign: TextAlign.center
                              ),
                            ]
                          ),
                          TableRow(
                            decoration: BoxDecoration(color: Colors.white),
                            children: [
                              Text(
                                'Clorex',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '1',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '0.50',
                                textAlign: TextAlign.center
                              ),
                              Text(
                                '0.50',
                                textAlign: TextAlign.center
                              ),
                            ]
                          ),
                          /*
                          pedidos.map((pedidos){
                            return TableRow(
                              decoration: const BoxDecoration(color: Colors.white),
                              children: [
                                Text(
                                  pedidos.nombre.toString(),
                                  textAlign: TextAlign.center
                                ),
                                Text(
                                  pedidos.cantidad.toString(),
                                  textAlign: TextAlign.center
                                ),
                                Text(
                                  pedidos.cantidad.toString(),
                                  textAlign: TextAlign.center
                                ),
                                Text(
                                  pedidos.precio.toString(),
                                  textAlign: TextAlign.center
                                ),
                              ] 
                            );
                          }).toList()
                          */
                        ],
                      )
                    )
                  ],
                )
              )
            ),
            const Divider (
              color: Colors.black,
            ),
            Container(
              margin: const EdgeInsets.only(left: 200),
              width: 125,
              height: 30,
              color: Color.fromARGB(255, 22, 87, 199),
              child: const Center(
                child: Text(
                  'Total: 91.50',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                  ),
                )
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 150, top: 25),
              child: const Text(
                'Repartidor: Manuel de Jesus\n\n'
                'Fecha: 29 de Junio de 2022',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}