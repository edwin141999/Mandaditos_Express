import 'package:flutter/material.dart';

class EditarTarjeta extends StatefulWidget {
  final Color colorTarjeta;
  final String imageTarjeta;
  const EditarTarjeta(
      {Key? key, required this.colorTarjeta, required this.imageTarjeta})
      : super(key: key);

  @override
  State<EditarTarjeta> createState() => _EditarTarjetaState();
}

class _EditarTarjetaState extends State<EditarTarjeta> {
  var mesNumero = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  var yearNumero = [
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030'
  ];

  String mesValue = '01';
  String yearValue = '2020';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarjeta',
            style: TextStyle(fontWeight: FontWeight.w400)),
        backgroundColor: const Color(0xff265C7E),
        elevation: 0,
        automaticallyImplyLeading: false, // No back button
        centerTitle: true,
        leading: IconButton(
            icon: Image.asset('assets/images/icon_back_arrow.png',
                scale: .8, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Stack(
          children: [
            const FondoAzul(),
            const FondoBlanco(),
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    height: 140,
                    width: MediaQuery.of(context).size.height * 0.26,
                    decoration: BoxDecoration(
                      color: widget.colorTarjeta,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: widget.colorTarjeta.withOpacity(0.5),
                          offset: const Offset(0, 7),
                          blurRadius: 10,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(widget.imageTarjeta),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '****1234',
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: 10, bottom: 30),
                          child: const TextField(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff000000),
                            ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              fillColor: Color(0xffEEEEEE),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.82,
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffEEEEEE),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: DropdownButton(
                                            items: mesNumero.map((e) {
                                              return DropdownMenuItem(
                                                child: Text(
                                                  e,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                                value: e,
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                mesValue = value.toString();
                                              });
                                            },
                                            value: mesValue,
                                            underline: Container(),
                                            icon: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 70),
                                              child: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffEEEEEE),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: DropdownButton(
                                            items: yearNumero.map((e) {
                                              return DropdownMenuItem(
                                                child: Text(
                                                  e,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                                value: e,
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                yearValue = value.toString();
                                              });
                                            },
                                            value: yearValue,
                                            underline: Container(),
                                            icon: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 50),
                                              child: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 220,
                    margin: const EdgeInsets.only(top: 50),
                    decoration: const BoxDecoration(
                      color: Color(0xff265C7E),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: const Center(
                      child: Text(
                        'Actualizar Tarjeta',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 220,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xffF55151),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: const Center(
                      child: Text(
                        'Eliminar Tarjeta',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}

class FondoAzul extends StatelessWidget {
  const FondoAzul({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.848,
      width: double.infinity,
      color: const Color(0xff265C7E),
    );
  }
}

class FondoBlanco extends StatelessWidget {
  const FondoBlanco({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 155),
      decoration: const BoxDecoration(
        color: Color(0xffFBFBFB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }
}
