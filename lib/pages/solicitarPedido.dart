import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/pedidosService.dart';


class SolicitarPedido extends StatefulWidget {
  const SolicitarPedido({Key? key}) : super(key: key);

  @override
  State<SolicitarPedido> createState() => _SolicitarPedido();
}

class _SolicitarPedido extends State<SolicitarPedido> {
  String? tipoProducto = "Comida / Consumible";
  String? descripcion = "";
  String? lugar = "";
 
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
                padding: EdgeInsets.symmetric(horizontal: 8)
              ),
              Text(
                'Solicitar un mandado', 
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
              margin: const EdgeInsets.only(left: 20, top: 40),
              child: Stack(
                children: [
                  const Text(
                    'Tipo de Producto',
                    style: TextStyle(
                      fontSize: 12,
                      // color: Colors.black,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                                        
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: DropdownButton<String>(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: tipoProducto,
                      isExpanded: true,
                      style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      items: [
                        'Comida / Consumible',
                        'Pedido Personal',
                      ]
                      .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem(
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: value,
                        )
                      )
                      .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          tipoProducto = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: Stack(
                children: [
                  const Text(
                    'Descripcion',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                                        
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    width: 320,
                    height: 140,
                    child: TextField(
                      onChanged: (text) {
                        descripcion = text;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black ), 
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black)
                        )
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                    )
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: Stack(
                children: [
                  const Text(
                    '¿Donde lo podemos obtener?',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                                        
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 320,
                    child: TextField(
                      onChanged: (text) {
                        lugar = text;
                      },
                      decoration: const InputDecoration(   
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                        )
                      ),
                    )
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: ElevatedButton(
                child: const Text(
                  "Solicitar Pedido",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(312, 54),
                  primary: Color.fromARGB(255, 22, 87, 199),
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                ),
                onPressed: () {
                  insertarDatos(tipoProducto, lugar, descripcion);
                  // Navigator.pushNamed(context, '');
                },
              )
            )
          ],
        ),
      ), 
    );
  }
}