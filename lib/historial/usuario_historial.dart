import 'package:flutter/material.dart';

class usuarioHitorial extends StatefulWidget {
  const usuarioHitorial({key, required this.title});

  final String title;

  @override
  State<usuarioHitorial> createState() => _usuarioHitorialState();
}

class _usuarioHitorialState extends State<usuarioHitorial> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    width: 150.0,
                    height: 120.0,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 150.0,
                    height: 120.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'USUARIO: ',
                          style: TextStyle(color: Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text('Historial',
                                style: TextStyle(color: Colors.black)),
                            Text(
                              '   Pedidos',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: CustomPaint(
                size: Size(width, 0),
                painter: Linea(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Container(
                    width: 200,
                    height: 200,
                    margin: const EdgeInsets.only(top: 20),
                    child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/2728/2728381.png'))
              ],
            ),
            Container(
              width: width,
              height: 35,
              margin: const EdgeInsets.only(top: 20),
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "historial de pedidos",
                ),
              ),
            )
          ],
        ));
  }
}

class Linea extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final p1 = Offset(0, 0);
    final p2 = Offset(size.width, 0);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
