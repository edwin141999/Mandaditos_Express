import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:mandaditos_express/models/pedidoinfo.dart';
import 'package:http/http.dart' as http;

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Mandados Disponibles',
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
                  child: Image.asset('assets/images/icon_back_arrow.png',
                      scale: .8),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ])),
        ),
        body: FutureBuilder(
            future: getMandados(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                  itemCount: pedidosInfo.pedidos.length,
                  itemBuilder: (BuildContext context, int i) => Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          leading: SizedBox(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                GestureDetector(
                                  child: Image.asset(
                                    'assets/images/notificacion.png',
                                  ),
                                ),
                              ])),
                          title: Text(
                            pedidosInfo.pedidos[i].cliente.users.firstName +
                                ' ' +
                                pedidosInfo.pedidos[i].cliente.users.lastName,
                            textScaleFactor: 1.5,
                          ),
                          trailing: SizedBox(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                FloatingActionButton.extended(
                                  onPressed: () {},
                                  icon: const Icon(Icons.save),
                                  label: const Text("Detalles"),
                                ),
                              ])),
                          subtitle: Text(
                              '${pedidosInfo.pedidos[i].horaSolicitada.toString().substring(11, 16)} AM/PM \n'
                              '${pedidosInfo.pedidos[i].item.tipoProducto}\n'
                              'Total: ${pedidosInfo.pedidos[i].item.precioProducto} \$'),
                          selected: true,

                          // onTap: () {
                          //   setState(() {
                          //     txt='List Tile pressed';
                          //   });
                          // },
                        ),
                      ));
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const Center(child: CircularProgressIndicator());
              // } else {
              //   //return _ListaPedidos(snapshot.data.pedidos);

              // }
            }));
  }
}

// class _ListaPedidos extends StatelessWidget {
//   final List<PedidoClass> pe;

//   const _ListaPedidos(this.pe);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: pe.length,
//         itemBuilder: (BuildContext context, int i) {
//           final pedido = pe[i];
//           int idpedido = pedido.envioId;
//           return ListTile(
//             title: Text('${pedido.envioId}'),
//             subtitle: const Text('hh'),
//           );
//         });
//   }
// }
