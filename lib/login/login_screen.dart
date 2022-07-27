import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:in_app_update/in_app_update.dart';

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
        child: const Text('Close'),
        onPressed: () {
          Navigator.of(ctx).pop();
        },
      ),
    ],
  );
}

class _LoginData {
  String email = '';
  String password = '';
}

class UserData extends _LoginData {
  String token = '';
  String username = '';
  late int id;

  void addData(Map<String, dynamic> responseMap) {
    id = responseMap['id'];
    username = responseMap['email'];
    token = responseMap['token'];
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserData userData = UserData();

  //UPDATE APP
  AppUpdateInfo? _updateInfo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final bool _flexibleUpdateAvailable = false;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate()
        .then((info) => {
              setState(() {
                _updateInfo = info;
              })
            })
        .catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      loginwithDB();
    }
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  Future<void> loginwithDB() async {
    var url = Uri.parse('http://35.171.142.223/users/login');
    return await Future.delayed(
        const Duration(seconds: 2),
        () => {
              http.post(
                url,
                body: {'email': userData.email, 'password': userData.password},
              ).then((response) {
                Map<String, dynamic> responseMap = json.decode(response.body);
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.green[400],
                      elevation: 1,
                      content: const Text(
                        '¡Haz iniciado Sesion!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                  if (responseMap['user']['user_type'] == 'Cliente') {
                    Navigator.pushReplacementNamed(
                      context,
                      '/cliente/dashboard',
                      arguments: {'user': userFromJson(response.body)},
                    );
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      '/repartidor/dashboard',
                      arguments: {'user': userFromJson(response.body)},
                    );
                  }
                } else {
                  if (responseMap.containsKey("message")) {
                    showDialog(
                        context: context,
                        builder: (ctx) => getAlertDialog(
                            "Error de Inicio de Sesion",
                            '${responseMap["message"]}',
                            ctx));
                  }
                }
              }).catchError((err) {
                showDialog(
                    context: context,
                    builder: (ctx) => getAlertDialog(
                        "Error", "Error dentro del servidor", ctx));
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .92,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/Logo.png', height: 137),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .7,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('Correo electronico',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                                SizedBox(
                                  height: 27,
                                  child: TextFormField(
                                    onSaved: (value) {
                                      userData.email = value!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Ingrese su correo electronico',
                                      hintStyle: const TextStyle(
                                          fontSize: 17,
                                          color: ColorSelect.kTextGrey),
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 10),
                                      suffixIcon: Image.asset(
                                          'assets/images/user_logo.png',
                                          color: ColorSelect.kTextGrey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text('Contraseña',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black)),
                                    SizedBox(
                                      height: 31,
                                      child: TextFormField(
                                        onSaved: (value) {
                                          userData.password = value!;
                                        },
                                        obscureText: !_passwordVisible,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.black),
                                        toolbarOptions:
                                            const ToolbarOptions(paste: false),
                                        decoration: InputDecoration(
                                          hintText: 'Ingrese su contraseña',
                                          hintStyle: const TextStyle(
                                              fontSize: 17,
                                              color: ColorSelect.kTextGrey),
                                          contentPadding:
                                              const EdgeInsets.only(bottom: 0),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                            alignment: Alignment.topCenter,
                                            icon: Icon(_passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: OutlinedButton(
                              onPressed: submit,
                              child: const Text('Iniciar Sesion',
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
                          SizedBox(
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('¿No tienes una cuenta?',
                                    style: TextStyle(fontSize: 17)),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 16),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Registrate aqui',
                                        style: const TextStyle(
                                            color: ColorSelect.kSecondaryColor,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () =>
                                              Navigator.pushReplacementNamed(
                                                context,
                                                '/register',
                                              ),
                                      )
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
