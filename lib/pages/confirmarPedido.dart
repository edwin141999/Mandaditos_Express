import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/iteminfo.dart';

class ConfirmarPedido extends StatefulWidget {
  const ConfirmarPedido({Key? key}) : super(key: key);

  @override
  State<ConfirmarPedido> createState() => _ConfirmarPedido();
}

class _ConfirmarPedido extends State<ConfirmarPedido> {
  // late Future item;
  /*
  @override
  void initState() {
    super.initState();
    item = getItems();
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
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32)
              ),
              Text(
                'Tu pedido', 
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          )
        ),
      ),
      // Cuerpo
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 4),
              height: 80,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 7, top: 15),
                    child: const Text('Direccion de Entrega: Actual')
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 5, top: 35),
                    width: 312,
                    height: 35,
                    color: Colors.grey.withOpacity(0.5),
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, top: 10),
                      child: const Text(
                        'Campamento CFE, Primera Etapa #38'
                      )
                    )
                  ),
                ],
              ) 
            ),

            Container(
              height: 260,
              child: Stack(
                children: [
                  Container(
                    width: 312,
                    height: 25,
                    child: Container(
                      margin: const EdgeInsets.only(left: 7.5, top: 5),
                      child: const Text(
                        'Tus Productos y Pedidos Personales'
                      )
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    width: 312,
                    height: 235,
                    color: Colors.grey.withOpacity(0.5),
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, top: 10),
                      child: Stack(
                        children: [
                          // Texto
                          Container(
                            width: 302,
                            height: 18,
                            child: const Text(
                              '4 Productos en Espera'
                            )
                          ),
                          // Divisor
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            width: 302,
                            height: 2,
                            child: const Divider (
                              color: Colors.black,
                            )
                          ),
                          // Tabla
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 302,
                            height: 175,
                            child: Center(
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
                                              'Precio',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                                            ),
                                          ]
                                        ),
                                        /*
                                        FutureBuilder(
                                          future: getItems(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const Center(
                                                child: CircularProgressIndicator()
                                              );
                                            }
                                            else {
                                              return ListView.builder(
                                                itemCount: 1,
                                                itemBuilder: (BuildContext context, int i) => TableRow(
                                                  decoration: BoxDecoration(color: Colors.white),
                                                  children: const [
                                                    Text('snapshot.data[1]', textAlign: TextAlign.center),
                                                    Text('snapshot.data[4]', textAlign: TextAlign.center),
                                                  ]
                                                )
                                              );
                                            }
                                          }
                                        )
                                        */
                                      ],
                                    )
                                  )
                                ],
                              )
                            )
                          ),
                          // Divisor
                          Container(
                            margin: const EdgeInsets.only(top: 195),
                            width: 302,
                            height: 2,
                            child: const Divider (
                              color: Colors.black,
                            )
                          ),
                          // Fila con Textos.
                          Container(
                            margin: const EdgeInsets.only(top: 200),
                            width: 302,
                            height: 18,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Entrega Estimada:'
                                ),
                                Text(
                                  '30 Minutos'
                                ),  
                              ],
                            ),
                          ),
                        ],
                      )
                    )
                  ),
                ],
              ) 
            ),

            Container(
              margin: const EdgeInsets.only(left: 4),
              height: 100,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Metodo de Pago'
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10)
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '');
                        },
                        child: const Text(
                          'Cambiar',
                          style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 22, 87, 199)),
                        )
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 35),
                    width: 312,
                    height: 55,
                    color: Colors.grey.withOpacity(0.5),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/tarjeta.png'),
                              fit: BoxFit.fill
                            )
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5)
                        ),
                        const Text(
                          'Tarjeta de Credito',
                          style: TextStyle(
                            fontSize: 12
                          )
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15)
                        ),
                        const Text(
                          'Termina en (3284)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ],
                    )
                  ),
                ],
              ) 
            ),

            Container(
              margin: const EdgeInsets.only(top: 5),
              width: 312,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    /*
                    Container(
                      width: 35,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: const Center(
                        child: const Text('4')
                      )
                    ),
                    */
                    Text(
                      "Confirmar Pedido",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                      ),
                    ),
                    /*
                    const Text(
                      "\$200.00",
                      style: TextStyle(
                        fontSize: 14
                      ),
                    ),
                    */
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(312, 52),
                  primary: const Color.fromARGB(255, 22, 87, 199),
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                ), 
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>  AlertDialog(
                      insetPadding: const EdgeInsets.only(left: 30, right: 30, top: 120, bottom: 120),
                      content: Container(
                        child: Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical:10)
                            ),
                            Text(
                              'Tu pedido fue solicitado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical:15)
                            ),
                            Text('Los repartidores cercanos podran aceptar tu solicitud de pedido, podras cancelar tu pedido antes de tiempo para reclamar un rembolso.'),
                            Text('\nVea el mapa para localizar su posible repartidor.'),
                          ],
                        )
                      ), 
                      actions: [
                        /*
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '');
                          },
                          child: const Text(
                            'Ver Recibo',
                            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 22, 87, 199)),
                          )
                        ),
                        */
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '');
                          },
                          child: const Text('Ver Recibo'), // Era originalmente ver mapa...
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(165, 40),
                            primary: const Color.fromARGB(255, 22, 87, 199),
                            onPrimary: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25)
                        ),
                      ],
                    ),
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}

Future<Item> getItems() async {
  var url = Uri.parse('http://54.163.243.254:81/users/mostrarItem');
  final resp = await http.post(url, headers: {'Content-Type': 'application/json'});
  return itemFromJson(resp.body);
}