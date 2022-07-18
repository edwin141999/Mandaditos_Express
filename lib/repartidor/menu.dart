import 'package:flutter/material.dart';

import 'package:mandaditos_express/styles/colors/colors_view.dart';

class menuM extends StatefulWidget {
  //final User userInfo;
  //const Dashboard({Key? key, required this.userInfo}) : super(key: key);
  const menuM({Key? key}) : super(key: key);

  @override
  State<menuM> createState() => _menuMState();
}

class _menuMState extends State<menuM> {
  var calles = [];

  String callesValue = '';
  var textInfo = ['Mandados disponibles', 'Historial de Mandados'];
  var imgInfo = [
    'assets/images/icon_solicitar.png',
    'assets/images/icon_pedidos.png'
  ];
  var colorInfo = [ColorSelect.kContainerGreen, ColorSelect.kContainerPink];

  // @override
  // void initState() {
  //   for (var item in widget.userInfo.datatype) {
  //     calles.add(item.direccion);
  //   }
  //   callesValue = widget.userInfo.datatype[0].direccion;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: 35,
              child: GestureDetector(
                child: Image.asset(
                  'assets/images/icon_profile.png',
                  color: Colors.black,
                ),
                //
                // onTap: () {
                //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                //     return ProfileScreen(userInfo: widget.userInfo);
                //   }));
                // },
              ),
            ),
          ),
        ],
      ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola', // ${widget.userInfo.user.firstName}', //usuario
                        style: const TextStyle(fontSize: 22),
                      ),
                      DropdownButton(
                        items: calles.map((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            callesValue = value.toString();
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
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 410,
                        child: ListView.builder(
                          itemCount: textInfo.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AccionesContainer(
                                image: imgInfo[index],
                                text: textInfo[index],
                                colorContainer: colorInfo[index]);
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
    );
  }
}

class AccionesContainer extends StatelessWidget {
  final String image, text;
  final Color colorContainer;
  const AccionesContainer({
    Key? key,
    required this.image,
    required this.text,
    required this.colorContainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 130,
          decoration: BoxDecoration(
            color: colorContainer.withOpacity(.42),
            borderRadius: BorderRadius.circular(17),
            image: DecorationImage(image: AssetImage(image), scale: .8),
          ),
        ),
        Container(
          width: 140,
          margin: const EdgeInsets.only(bottom: 30),
          child: Text(text,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}