import 'package:flutter/material.dart';
import 'package:mandaditos_express/models/iteminfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

//SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConfirmarPedido extends StatefulWidget {
  // final ItemInfo item;
  // final User userInfo;
  // const ConfirmarPedido({
  //   Key? key,
  //   required this.item,
  //   required this.userInfo,
  // }) : super(key: key);
  const ConfirmarPedido({Key? key}) : super(key: key);

  @override
  State<ConfirmarPedido> createState() => _ConfirmarPedido();
}

class _ConfirmarPedido extends State<ConfirmarPedido> {
  Future<void> generarPedido() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final item = arguments['item'] as ItemInfo;
    final userInfo = arguments['user'] as User;
    var url = Uri.parse('http://34.193.105.11/users/mandadito');
    var reqBody = {};
    reqBody['envio_id'] = item.item.id;
    reqBody['cliente_id'] = userInfo.datatype[0].id;
    reqBody['entrega_estimada'] = 30;
    reqBody['metodo_pago'] = '${userInfo.metodoPago![0].id}';
    reqBody['subtotal'] = '50';
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reqBody),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final item = arguments['item'] as ItemInfo;
    final userInfo = arguments['user'] as User;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/images/icon_back_arrow.png', scale: .8),
        ),
        title: const Text('Tu pedido', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Direccion de Entrega',
                          style: TextStyle(fontSize: 18)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        decoration: BoxDecoration(
                          color: ColorSelect.kColorDropdown,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, top: 10),
                          child: Text(userInfo.datatype[0].direccion,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tus Productos y Pedidos Personales',
                          style: TextStyle(fontSize: 18)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 235,
                        decoration: BoxDecoration(
                          color: ColorSelect.kColorDropdown,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(top: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Producto en Espera',
                                  style: TextStyle(fontSize: 16)),
                              const Divider(color: Colors.black, height: 5),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                height: 160,
                                child: Column(
                                  children: [
                                    Table(
                                      border: TableBorder.symmetric(
                                          outside: BorderSide.none),
                                      children: [
                                        const TableRow(
                                          decoration: BoxDecoration(
                                              color: ColorSelect.kPrimaryColor),
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Text(
                                                'Producto',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Text(
                                                'Precio',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 10),
                                              child: Text(
                                                item.item.descripcion,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15, top: 10),
                                              child: Text(
                                                item.item.precioProducto +
                                                    ' \$',
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  const Divider(color: Colors.black, height: 5),
                                  SizedBox(
                                    height: 18,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text('Entrega Estimada:',
                                            style: TextStyle(fontSize: 16)),
                                        Text('30 Minutos',
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('Metodo de Pago',
                      style: TextStyle(fontSize: 18)),
                ),
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: ColorSelect.kColorDropdown,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  (userInfo.metodoPago![0].metodo == 'Debito')
                                      ? const AssetImage(
                                          'assets/images/tarjeta.png')
                                      : const AssetImage(
                                          'assets/images/billete.png'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Text(userInfo.metodoPago![0].metodo,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      (userInfo.metodoPago![0].metodo == 'Efectivo')
                          ? const Text('')
                          : const Text('Termina en (3284)',
                              style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Pago del servicio: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '50 \$',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    child: const Text('Confirmar Pedido',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: ColorSelect.kPrimaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      generarPedido();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 125),
                          content: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Tu pedido fue solicitado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                    'Los repartidores cercanos podran aceptar tu solicitud de pedido en unos minutos.'),
                                const Text(
                                    'Vea el mapa para localizar su posible repartidor en su historial de pedidos.'),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/cliente/historialUsuario',
                                      arguments: {'user': userInfo},
                                    );
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Ir al historial de pedidos',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width, 50),
                                    backgroundColor: ColorSelect.kPrimaryColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
