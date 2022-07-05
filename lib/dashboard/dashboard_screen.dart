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
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'QUE ONDA ${widget.userInfo.user.firstName}',
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
                Container(
                  width: 150,
                  height: 150,
                  color: ColorSelect.kContainerBackground,
                  child: const Center(
                      child: Text(
                    'Ver  puntos de interes',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
