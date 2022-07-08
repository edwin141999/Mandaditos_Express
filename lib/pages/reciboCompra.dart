import 'package:flutter/material.dart';
import 'package:vistaproyecto/Styles/colors_view.dart';

class reciboCompra extends StatefulWidget {
  const reciboCompra({Key? key}) : super(key: key);

  @override
  State<reciboCompra> createState() => _reciboCompraState();
}

class _reciboCompraState extends State<reciboCompra> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //preferredSize: Size.fromHeight(100),

        // automaticallyImplyLeading: false,

        // iconTheme: const IconThemeData(color: ColorSelect.paginatorNext),
        leading: Container(
          //padding: const EdgeInsets.only()),
          child: Image.asset(
            'assets/images/logoM.png',
            height: 40,
            width: 40,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Pedido #',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: ColorSelect.paginator,
        actions: [
          Container(
            //width: 150,

            //padding: const EdgeInsets.only(left: 20),
            child: Image.asset(
              'assets/images/cuenta.png',
            ),
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Container(
            padding: const EdgeInsets.only(right: 350),
            child: IconButton(
              onPressed: () {
                // Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            )),
        Row(children: [
          Container(
            padding: const EdgeInsets.only(left: 150, bottom: 110),
            child: const Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 50),
            child: const Text(
              'Usuario: Juan Jose\n'
              'Ave.Central.Ote\n'
              'Entre 4ta y 5ta Oriente\n'
              'Suchiapa, Chiapas',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ]),
        Padding(
          //padding: const EdgeInsets.all(0),
          padding: const EdgeInsets.only(bottom: 50),

          //
          child: Table(
//          defaultColumnWidth:
//              FixedColumnWidth(MediaQuery.of(context).size.width / 3),
            // border: TableBorder.all(
            //     color: Colors.black26, width: 1, style: BorderStyle.none),
            children: [
              TableRow(children: [
                TableCell(
                    child: Center(
                  child: Text(
                    '                      \n'
                    '   Producto     \n'
                    '                         \n',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.blue),
                  ),
                )),
                TableCell(
                  child: Center(
                      child: Text(
                    '                      \n'
                    '    Cantidad    \n'
                    '                      \n',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.blue),
                  )),
                ),
                TableCell(
                    child: Center(
                        child: Text(
                  '                      \n'
                  '     Precio      \n'
                  '                      \n',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.blue),
                ))),
                TableCell(
                    child: Center(
                        child: Text(
                  '                      \n'
                  '   Subtotal    \n'
                  '                      \n',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.blue),
                ))),
              ]),
              TableRow(children: [
                TableCell(
                  child: Center(
                      child: Text(
                    '1. Producto_01\n',
                  )),
                  //verticalAlignment: TableCellVerticalAlignment.bottom,
                ),
                TableCell(
                  //verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Center(child: Text('1')),
                ),
                TableCell(
                  //verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Center(child: Text('10.00')),
                ),
                TableCell(
                  child: Center(child: Text('10.00')),
                  //verticalAlignment: TableCellVerticalAlignment.top,
                ),
              ]),
              TableRow(children: [
                TableCell(child: Center(child: Text('2. Producto_02\n'))),
                TableCell(
                  child: Center(child: Text('1')),
                ),
                TableCell(child: Center(child: Text('20.00'))),
                TableCell(child: Center(child: Text('20.00'))),
              ]),
              TableRow(children: [
                TableCell(child: Center(child: Text('3. Producto_03\n'))),
                TableCell(
                  child: Center(child: Text('1')),
                ),
                TableCell(child: Center(child: Text('30.00'))),
                TableCell(child: Center(child: Text('30.00'))),
              ]),
              TableRow(children: [
                TableCell(child: Center(child: Text('4. Producto_04\n'))),
                TableCell(
                  child: Center(child: Text('1')),
                ),
                TableCell(child: Center(child: Text('40.00'))),
                TableCell(child: Center(child: Text('40.00'))),
              ]),
              TableRow(children: [
                TableCell(child: Center(child: Text('5. Producto_05\n'))),
                TableCell(
                  child: Center(child: Text('1')),
                ),
                TableCell(child: Center(child: Text('50.00'))),
                TableCell(child: Center(child: Text('50.00'))),
              ])
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: ColorSelect.txtBoSubHe,
        ),
        Container(
          padding: const EdgeInsets.only(left: 200, top: 20),
          child: const Text(
            '  Total: 150.00      ',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.blue),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 150, top: 50),
          child: const Text(
            'Repartidor: Manuel de Jesus\n'
            'Fecha: 29 de Junio de 2022',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,

              //backgroundColor: Colors.blue
            ),
          ),
        )
      ]),
    );
  }
}
