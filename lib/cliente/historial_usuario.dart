import 'package:flutter/material.dart';
import 'package:mandaditos_express/cliente/dashboard_cliente.dart';
import 'package:mandaditos_express/models/pedidoclienteinfo.dart';
import 'package:mandaditos_express/models/repartidorinfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';

//SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mandaditos_express/cliente/monitoreo/pedido_monitoreo_user.dart';

AlertDialog getAlertDialog(title, content, ctx) {
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
      TextButton(
        child: const Text('Cerrar'),
        onPressed: () {
          Navigator.of(ctx).pop();
        },
      ),
    ],
  );
}

class HistorialUsuario extends StatefulWidget {
  final User userInfo;
  const HistorialUsuario({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<HistorialUsuario> createState() => _HistorialUsuarioState();
}

RepartidorInfo? repartidorInfo;

Future<RepartidorInfo> datosRepartidor(int idRepartidor) async {
  var url = Uri.parse('http://54.163.243.254:81/users/getRepartidor');
  var reqBody = {};
  reqBody['id'] = idRepartidor;
  var response = await http.post(url,
      headers: {'Content-Type': 'application/json'}, body: jsonEncode(reqBody));
  repartidorInfo = RepartidorInfo.fromJson(json.decode(response.body));
  return repartidorInfo!;
}

class _HistorialUsuarioState extends State<HistorialUsuario> {
  bool botonSeleccionado = false;
  PedidoCliente pedidosCliente = PedidoCliente(pedidos: []);

  Future<PedidoCliente> verMandadosCliente() async {
    var url = Uri.parse('http://54.163.243.254:81/users/mandadosCliente');
    var reqBody = {};
    reqBody['id'] = widget.userInfo.datatype[0].id;
    var response = await http.post(url, body: jsonEncode(reqBody));
    pedidosCliente = PedidoCliente.fromJson(json.decode(response.body));
    return pedidosCliente;
  }

  @override
  void initState() {
    botonSeleccionado = false;
    verMandadosCliente();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leading: TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Dashboard(userInfo: widget.userInfo)));
          },
          child: Image.asset('assets/images/icon_back_arrow.png', scale: .8),
        ),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * .8,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('assets/images/Logo.png', scale: .8),
                Row(
                  children: [
                    SizedBox(
                      height: 25,
                      width: 90,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            botonSeleccionado = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: !botonSeleccionado
                                ? const Color(0xffD9D9D9)
                                : Colors.transparent,
                            elevation: 0,
                            side: !botonSeleccionado
                                ? const BorderSide(
                                    color: Color(0xffD9D9D9), width: 1)
                                : BorderSide.none),
                        child: const Text(
                          'Historial',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      width: 90,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            botonSeleccionado = true;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: botonSeleccionado
                              ? const Color(0xffD9D9D9)
                              : Colors.transparent,
                          elevation: 0,
                          side: botonSeleccionado
                              ? const BorderSide(
                                  color: Color(0xffD9D9D9), width: 1)
                              : BorderSide.none,
                        ),
                        child: const Center(
                          child: Text(
                            'Activas',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 3),
                child: const Divider(
                    color: Colors.black, height: 1, thickness: 2)),
            SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Image.asset('assets/images/icon_pedidos.png',
                    fit: BoxFit.fitHeight),
              ),
            ),
            Container(
              color: Colors.blue,
              height: 35,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Text(
                  'Tus pedidos',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                  future: verMandadosCliente(),
                  builder: (BuildContext context,
                      AsyncSnapshot<PedidoCliente> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (botonSeleccionado == false) {
                        return ListView.builder(
                          itemCount: snapshot.data!.pedidos.length,
                          itemBuilder: (BuildContext context, int index) {
                            int total = int.parse(
                                    snapshot.data!.pedidos[index].subtotal) +
                                int.parse(snapshot
                                    .data!.pedidos[index].item.precioProducto);
                            return MuestraPedidos(
                              tipoProducto: snapshot
                                  .data!.pedidos[index].item.tipoProducto,
                              descripcion: snapshot
                                  .data!.pedidos[index].item.descripcion,
                              image: (snapshot.data!.pedidos[index].item
                                          .tipoProducto ==
                                      'Comida / Consumible')
                                  ? 'assets/images/comida.png'
                                  : 'assets/images/pedido_personal.png',
                              subtotal: total.toString(),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.pedidos.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data!.pedidos[index].horaEntregada ==
                                null) {
                              return PedidosActivos(
                                tipoProducto: snapshot
                                    .data!.pedidos[index].item.tipoProducto,
                                descripcion: snapshot
                                    .data!.pedidos[index].item.descripcion,
                                image: (snapshot.data!.pedidos[index].item
                                            .tipoProducto ==
                                        'Comida / Consumible')
                                    ? 'assets/images/comida.png'
                                    : 'assets/images/pedido_personal.png',
                                subtotal:
                                    snapshot.data!.pedidos[index].subtotal,
                                pedidos: snapshot.data!.pedidos[index],
                                userInfo: widget.userInfo,
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PedidosActivos extends StatelessWidget {
  final String tipoProducto, descripcion, image, subtotal;
  final Pedido pedidos;
  final User userInfo;
  const PedidosActivos({
    Key? key,
    required this.tipoProducto,
    required this.descripcion,
    required this.image,
    required this.subtotal,
    required this.pedidos,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(image),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipoProducto,
                        style:
                            const TextStyle(color: Colors.green, fontSize: 18),
                      ),
                      Text(
                        descripcion,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$$subtotal.00',
                  style:
                      const TextStyle(color: Color(0xff00D1FF), fontSize: 25),
                )
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            height: 30,
            child: OutlinedButton(
              onPressed: () {
                if (pedidos.deliveryId == null) {
                  showDialog(
                    context: context,
                    builder: (ctx) => getAlertDialog(
                        "Oops!",
                        'Aún ningun repartidor ha aceptado en relizar su mandado, vuelva a intentarlo en unos minutos',
                        ctx),
                  );
                } else {
                  datosRepartidor(int.parse(pedidos.deliveryId.toString()));
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PedidoMonitoreo(
                            pedidoInfo: pedidos,
                            userInfo: userInfo,
                            repartidor: repartidorInfo!),
                      ),
                    );
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: const Text(
                'Ver seguimiento',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const Expanded(
            child: Divider(color: Colors.black, height: 1, thickness: 2),
          )
        ],
      ),
    );
  }
}

class MuestraPedidos extends StatelessWidget {
  final String tipoProducto, descripcion, image, subtotal;
  const MuestraPedidos({
    Key? key,
    required this.tipoProducto,
    required this.descripcion,
    required this.image,
    required this.subtotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(image),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipoProducto,
                        style:
                            const TextStyle(color: Colors.green, fontSize: 18),
                      ),
                      Text(
                        descripcion,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$$subtotal.00',
                  style:
                      const TextStyle(color: Color(0xff00D1FF), fontSize: 25),
                )
              ],
            ),
          ),
          const Expanded(
            child: Divider(color: Colors.black, height: 1, thickness: 3),
          )
        ],
      ),
    );
  }
}
