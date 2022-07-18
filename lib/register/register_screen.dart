import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mandaditos_express/login/login_screen.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

// SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

AlertDialog getAlertDialog(title, content, ctx) {
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
      TextButton(
        child: const Text('Cerrar'),
        onPressed: () {
          Navigator.of(ctx).pop();
        },
      ),
    ],
  );
}

class _RegisterData {
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String phoneNumber = '';
  String userType = '';
  String address = '';
  String latitud = '';
  String longitud = '';
  String cityDrive = '';
}

class UserData extends _RegisterData {}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserData userData = UserData();

  List<String> types = ['Cliente', 'Repartidor'];
  String typeValue = 'Cliente';

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      register();
    }
  }

  void inicializarUbicacion() async {
    Position position = await _getGeoLocationPosition();
    getAddressFromLatLong(position);
  }

  late Timer timer;

  @override
  void initState() {
    // inicializarUbicacion();
    _passwordVisible = false;
    super.initState();
    // timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
    log('Getting location...');
    inicializarUbicacion();
    // });
  }

  // @override
  // void dispose() {
  //   timer.cancel();
  //   super.dispose();
  // }

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

  String address = 'search';
  String location = 'Null';

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    log('UBICACION');
    // log(placemarks.toString());
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    location = 'Lat: ${position.latitude} - Long: ${position.longitude}';
    userData.latitud = position.latitude.toString();
    userData.longitud = position.longitude.toString();
    userData.address = place.street.toString();
    userData.cityDrive = place.locality.toString();
    setState(() {
      log(address);
      log(location);
    });
  }

  Future<void> register() async {
    var url = Uri.parse('http://54.163.243.254/users/register');
    var reqBody = {};
    reqBody['first_name'] = userData.firstName;
    reqBody['last_name'] = userData.lastName;
    reqBody['email'] = userData.email;
    reqBody['password'] = userData.password;
    reqBody['phone_number'] = userData.phoneNumber;
    reqBody['user_type'] = userData.userType;
    reqBody['direccion'] = userData.address;
    reqBody['latitud'] = userData.latitud;
    reqBody['longitud'] = userData.longitud;
    reqBody['city_drive'] = userData.cityDrive;
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody));
    try {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.greenAccent[200],
            elevation: 1,
            content: const Text(
              'You are Signed Up!',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return getAlertDialog('Error', 'Error al registrarse', context);
          },
        );
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) =>
              getAlertDialog('Error', 'Server error', context));
    }
    log(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child:
                            Image.asset('assets/images/Logo.png', height: 70)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Soy', style: TextStyle(fontSize: 18)),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.75,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ColorSelect.kColorDropdown),
                            child: DropdownButtonFormField(
                              value: typeValue,
                              items: types.map((items) {
                                return DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      items,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: ColorSelect.kTextDropdown,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  value: items,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  typeValue = value.toString();
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  userData.userType = value.toString();
                                });
                              },
                              decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                              dropdownColor: ColorSelect.kColorDropdown,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: ColorSelect.kTextDropdown, size: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Nombre',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          SizedBox(
                            height: 25,
                            child: TextFormField(
                              onSaved: (value) {
                                userData.firstName = value!;
                              },
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Ej. Juan',
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(139, 139, 139, 1),
                                ),
                                contentPadding: EdgeInsets.only(bottom: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Apellido',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          SizedBox(
                            height: 24,
                            child: TextFormField(
                              onSaved: (value) {
                                userData.lastName = value!;
                              },
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Ej. Perez Aguirre',
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(139, 139, 139, 1),
                                ),
                                contentPadding: EdgeInsets.only(bottom: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Correo electronico',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          SizedBox(
                            height: 27,
                            child: TextFormField(
                              onSaved: (value) {
                                final bool _isValid =
                                    EmailValidator.validate(value!);
                                if (_isValid) {
                                  userData.email = value;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                      elevation: 1,
                                      content: Text(
                                        'Introduce un correo correcto!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Ej. test@test.com',
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(139, 139, 139, 1),
                                ),
                                contentPadding: EdgeInsets.only(bottom: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Contraseña',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              const Padding(padding: EdgeInsets.only(right: 5)),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => getAlertDialog(
                                          "Requisitos Minimos",
                                          "1 Mayuscula,\n1 Minuscula,\n1 Numero,\n1 caracter especial",
                                          ctx));
                                },
                                child: Image.asset('assets/images/info_svg.png',
                                    height: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              onSaved: (value) {
                                RegExp regex = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                if (regex.hasMatch(value!)) {
                                  userData.password = value;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                      elevation: 1,
                                      content: Text(
                                        'Introduce una contraseña correcta!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }
                              },
                              obscureText: !_passwordVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              decoration: InputDecoration(
                                hintText: '*' * 8,
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(139, 139, 139, 1),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(bottom: 0),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  alignment: Alignment.centerRight,
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Numero Telefonico',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          SizedBox(
                            height: 27,
                            child: TextFormField(
                              onSaved: (value) {
                                userData.phoneNumber = value!;
                              },
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              decoration: const InputDecoration(
                                counterText: '',
                                hintText: 'Ej. 961253480',
                                hintStyle: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(139, 139, 139, 1),
                                ),
                                contentPadding: EdgeInsets.only(bottom: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (typeValue == 'Cliente')
                        ? SizedBox(
                            height: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Direccion',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 25,
                                  child: TextFormField(
                                    onSaved: (value) {
                                      userData.address = value!;
                                    },
                                    controller: TextEditingController(
                                        text: userData.address),
                                    onChanged: (value) {
                                      userData.address = value;
                                    },
                                    enabled: false,
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: 'Ej. Lib Norte',
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: Color.fromRGBO(139, 139, 139, 1),
                                      ),
                                      contentPadding:
                                          EdgeInsets.only(bottom: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Ciudad donde conduciras',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 27,
                                  child: TextFormField(
                                    onSaved: (value) {
                                      userData.cityDrive = value!;
                                    },
                                    controller: TextEditingController(
                                        text: userData.cityDrive),
                                    onChanged: (value) {
                                      userData.cityDrive = value;
                                    },
                                    enabled: false,
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.black),
                                    decoration: const InputDecoration(
                                      hintText: 'Ej. Tuxtla Gutierrez',
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: Color.fromRGBO(139, 139, 139, 1),
                                      ),
                                      contentPadding:
                                          EdgeInsets.only(bottom: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Al aceptar ', style: TextStyle(fontSize: 15)),
                        Text(
                          'Terminos y Condiciones',
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            submit();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Registrarse',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
