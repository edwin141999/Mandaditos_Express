import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mandaditos_express/models/iteminfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/cliente/mandados/googlemaps_controller.dart';

//SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mandaditos_express/styles/colors/colors_view.dart';

class _ItemData {
  String tipoProducto = '';
  String recogerUbicacion = '';
  String descripcion = '';
  String precioProducto = '';
  String latitud = '';
  String longitud = '';
}

class Item extends _ItemData {}

class SolicitarPedido extends StatefulWidget {
  const SolicitarPedido({Key? key}) : super(key: key);

  @override
  State<SolicitarPedido> createState() => _SolicitarPedido();
}

class _SolicitarPedido extends State<SolicitarPedido> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Item itemData = Item();

  List<String> productType = ['Comida / Consumible', 'Pedido Personal'];
  String productValue = "Comida / Consumible";

  void submitItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      generarItem();
    }
  }

  Future<void> generarItem() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    var url = Uri.parse('http://34.193.105.11/users/item');
    var reqBody = {};
    if (itemData.recogerUbicacion != '' && itemData.descripcion != '') {
      reqBody['recoger_ubicacion'] = itemData.recogerUbicacion;
      reqBody['descripcion'] = itemData.descripcion;
      reqBody['latitud'] = itemData.latitud;
      reqBody['longitud'] = itemData.longitud;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          elevation: 1,
          content: Text(
            '¡Algunos campos estan vacios!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (itemData.tipoProducto == 'Comida / Consumible' &&
        itemData.precioProducto == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          elevation: 1,
          content: Text(
            '¡Algunos campos estan vacios!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      reqBody['tipo_producto'] = itemData.tipoProducto;
    }

    reqBody['precio_producto'] = itemData.precioProducto;
    final resp = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody));
    if (resp.statusCode == 200) {
      Navigator.pushReplacementNamed(
        context,
        '/cliente/confirmarMandado',
        arguments: {
          'user': userInfo,
          'item': itemInfoFromJson(resp.body),
        },
        // MaterialPageRoute(
        //   builder: (context) => ConfirmarPedido(
        //       item: itemInfoFromJson(resp.body), userInfo: userInfo),
        // ),
      );
    }
  }

  final Completer<GoogleMapController> _controller = Completer();

  Future<void> _disposeController() async {
    _controller.future.then((GoogleMapController controller) {
      controller.dispose();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  final _controllerMap = GoogleMapsController();

  String address = 'search';
  String location = 'Null';

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    location = 'Lat: $latitude - Long: $longitude';
    itemData.recogerUbicacion = place.street.toString();
    itemData.latitud = latitude.toString();
    itemData.longitud = longitude.toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controllerMap.addListener(() {
      setState(() {
        for (var marker in _controllerMap.markers) {
          getAddressFromLatLong(
              marker.position.latitude, marker.position.longitude);
        }
      });
    });
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacementNamed(
              context,
              '/cliente/dashboard',
              arguments: {'user': userInfo},
            );
          },
          child: Image.asset('assets/images/icon_back_arrow.png', scale: .8),
        ),
        title: const Text(
          'Solicitar un mandado',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // Cuerpo
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tipo de Producto',
                          style: TextStyle(fontSize: 18)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: const EdgeInsets.only(top: 18, bottom: 40),
                        decoration: BoxDecoration(
                            color: ColorSelect.kColorDropdown,
                            borderRadius: BorderRadius.circular(50)),
                        child: DropdownButtonFormField(
                          value: productValue,
                          items: productType.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: ColorSelect.kTextDropdown,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              productValue = value.toString();
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              itemData.tipoProducto = value.toString();
                            });
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          dropdownColor: ColorSelect.kColorDropdown,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: ColorSelect.kTextDropdown, size: 15),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Descripcion', style: TextStyle(fontSize: 18)),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 25),
                        child: TextFormField(
                          onSaved: (text) {
                            itemData.descripcion = text!;
                          },
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black))),
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ),
                  (productValue == 'Comida / Consumible')
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Precio del los productos',
                                style: TextStyle(fontSize: 18)),
                            Container(
                                height: 25,
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                child: TextFormField(
                                  onSaved: (text) {
                                    itemData.precioProducto = text!;
                                  },
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.black),
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(bottom: 14),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black))),
                                )),
                          ],
                        )
                      : Container(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('¿Donde lo podemos obtener?',
                          style: TextStyle(fontSize: 18)),
                      Container(
                          height: 25,
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFormField(
                            onChanged: (text) {
                              itemData.recogerUbicacion = text;
                            },
                            controller: TextEditingController(
                                text: itemData.recogerUbicacion),
                            onSaved: (text) {
                              itemData.recogerUbicacion = text!;
                            },
                            enabled: false,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 14),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: GoogleMap(
                      markers: _controllerMap.markers,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition:
                          _controllerMap.initialCameraPosition,
                      myLocationButtonEnabled: false,
                      onTap: _controllerMap.onTap,
                      gestureRecognizers: <
                          Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        )
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        submitItem();
                      },
                      child: const Text('Solicitar Pedido',
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
