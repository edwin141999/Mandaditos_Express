import 'package:flutter/material.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class Dashboard extends StatefulWidget {
  final User userInfo;
  const Dashboard({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var calles = [
    'Calle 10 9',
    'Calle 11 9',
    'Calle 12 9',
    'Calle 13 9',
    'Calle 14 9',
  ];

  String callesValue = 'Calle 10 9';
  var textUp = ['Ver puntos de interes', 'Solicitar un mandadito', ''];
  var textDown = ['Productos registrados', 'Historial de pedidos', ''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Text(
                        'Hola ${widget.userInfo.user.firstName}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      DropdownButton(
                        items: calles.map((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            callesValue = value!;
                          });
                        },
                        value: callesValue,
                        underline: Container(),
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                SizedBox(
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '¿Desea algo?',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 20,
                              width: MediaQuery.of(context).size.width,
                              child: const TextField(
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontSize: 17,
                                      color: Color.fromRGBO(139, 139, 139, 1)),
                                ),
                              ),
                            ),
                          ),
                          Image.asset('assets/images/search.png'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 460,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          itemCount: textUp.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 7),
                              width: 150,
                              color: ColorSelect.kContainerBackground,
                              child: Center(
                                  child: Text(
                                textUp[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 22),
                              )),
                            );
                          },
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          itemCount: textDown.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 7),
                              width: 150,
                              color: ColorSelect.kContainerBackground,
                              child: Center(
                                  child: Text(
                                textDown[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20),
                              )),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const ButtonBar(),
    );
  }
}

class ButtonBar extends StatefulWidget {
  const ButtonBar({
    Key? key,
  }) : super(key: key);

  @override
  State<ButtonBar> createState() => _ButtonBarState();
}

class _ButtonBarState extends State<ButtonBar> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.101,
      child: Column(
        children: [
          const Divider(color: Colors.black),
          BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_arrow_back.png'),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_plus.png'), label: ''),
              BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_shopping.png'),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Image.asset('assets/images/icon_ubicacion.png'),
                  label: ''),
            ],
            currentIndex: selectedPage,
            elevation: 0,
            onTap: (int index) {
              setState(() {
                selectedPage = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
