import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:mandaditos_express/models/pedidoinfo.dart';
import 'package:http/http.dart' as http;
import 'package:mandaditos_express/repartidor/confirmarP.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class pedidosP extends StatefulWidget {
  //final User userInfo;
  //const Perfil({Key? key, required this.userInfo}) : super(key: key);
  const pedidosP({Key? key}) : super(key: key);

  @override
  State<pedidosP> createState() => _pedidosPState();
}

class _pedidosPState extends State<pedidosP> {
  Pedido pedidosInfo = Pedido(pedidos: []);

  Future<Pedido> getMandados() async {
    var url = Uri.parse('http://54.163.243.254:81/users/mostrarMandados');

    final resp =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    pedidosInfo = Pedido.fromJson(jsonDecode(resp.body));
    return pedidoFromJson(resp.body);
  }

  @override
  void initState() {
    getMandados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          child: Image.asset('assets/images/icon_back_arrow.png', scale: .8),
        ),
        title: const Text(
          'Mandados Disponibles',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getMandados(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _ListaPedidos(snapshot.data.pedidos);
          }
        },
      ),
    );
  }
}

class _ListaPedidos extends StatelessWidget {
  final List<PedidoElement> pe;
  const _ListaPedidos(this.pe);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pe.length,
      itemBuilder: (BuildContext context, int i) => Card(
        elevation: 1,
        margin: const EdgeInsets.all(15),
        color: ColorSelect.cardP,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10, left: 20),
              child: Image.asset('assets/images/notificacion.png'),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * .4,
              child: Text(
                '\n${pe[i].cliente.users.firstName} ${pe[i].cliente.users.lastName}\n'
                '\n${pe[i].item.tipoProducto}\n'
                '\n${pe[i].horaSolicitada.toString().substring(11, 16)} AM/PM\n'
                '\nTotal: \$ ${pe[i].subtotal}\n',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return confirmarP(pedidoInfo: pe[i]);
                      },
                    ),
                  );
                },
                color: Colors.lightBlue,
                child: const Text('Ver Detalles',
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
