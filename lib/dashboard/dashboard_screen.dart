import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mandaditos_express/historial/usuario_historial.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/pages/solicitar_pedido.dart';
import 'package:mandaditos_express/profile/profile.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class Dashboard extends StatefulWidget {
  final User userInfo;
  const Dashboard({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var calles = [];

  String callesValue = '';
  var textInfo = ['Solicitar un mandadito', 'Historial de pedidos'];
  var imgInfo = [
    'assets/images/icon_solicitar.png',
    'assets/images/icon_pedidos.png'
  ];
  var colorInfo = [ColorSelect.kContainerGreen, ColorSelect.kContainerPink];

    Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void inicializarUbicacion() async {
    await _getGeoLocationPosition();
  }

  @override
  void initState() {
    setState(() {
      inicializarUbicacion();
    });
    for (var item in widget.userInfo.datatype) {
      calles.add(item.direccion);
    }
    callesValue = widget.userInfo.datatype[0].direccion;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                child: Image.asset('assets/images/icon_profile.png',
                    color: Colors.black),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen(userInfo: widget.userInfo);
                  }));
                },
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
                        'Hola ${widget.userInfo.user.firstName}!',
                        style: const TextStyle(fontSize: 22),
                      ),
                      Row(
                        children: [
                          const Text('Tu Direccion Actual: ',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                          Text('${widget.userInfo.datatype[0].direccion}',
                              style: const TextStyle(fontSize: 17)),
                        ],
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
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AccionesContainer(
                              image: imgInfo[0],
                              text: textInfo[0],
                              colorContainer: colorInfo[0],
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SolicitarPedido(
                                      userInfo: widget.userInfo);
                                }));
                              },
                            ),
                            AccionesContainer(
                              image: imgInfo[1],
                              text: textInfo[1],
                              colorContainer: colorInfo[1],
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UsuarioHitorial(userInfo: widget.userInfo);
                                }));
                              },
                            ),
                          ],
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
  final Function() onTap;
  const AccionesContainer({
    Key? key,
    required this.image,
    required this.text,
    required this.colorContainer,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 160,
            height: 123,
            decoration: BoxDecoration(
              color: colorContainer.withOpacity(.42),
              borderRadius: BorderRadius.circular(17),
              image: DecorationImage(image: AssetImage(image), scale: .8),
            ),
          ),
        ),
        Container(
          width: 140,
          margin: const EdgeInsets.only(bottom: 30, top: 10),
          child: Text(text,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
