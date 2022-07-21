import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mandaditos_express/dashboard/dashboard_screen.dart';
import 'package:mandaditos_express/register/register_screen.dart';
import 'package:mandaditos_express/repartidor/menu.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter/cupertino.dart';

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
  // Map<String, dynamic>? _userData;
  // AccessToken? _accessToken;
  // bool _checking = false;

  bool _passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserData userData = UserData();

  bool _isLoggedIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      loginwithDB();
    }
  }

  loginwithGoogle() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err) {
      rethrow;
    }
  }

  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  // _checkIfisLoggedIn() async {
  // final accessToken = await FacebookAuth.instance.accessToken;
  // setState(() {
  //   _checking = false;
  // });

  // if (accessToken != null) {
  //   print(accessToken.toJson());
  //   final userData = await FacebookAuth.instance.getUserData();
  //   _accessToken = accessToken;
  //   setState(() {
  //     _userData = userData;
  //   });
  // } else {
  //   _loginFB();
  // }
  // }

  // _loginFB() async {
  // final LoginResult result = await FacebookAuth.instance.login();
  // if (result.status == LoginStatus.success) {
  //   _accessToken = result.accessToken;

  //   final userData = await FacebookAuth.instance.getUserData();
  //   _userData = userData;
  // } else {
  //   print(result.status);
  //   print(result.message);
  // }
  //   setState(() {
  //     _checking = false;
  //   });
  // }

  // _logoutFB() async {
  // await FacebookAuth.instance.logOut();
  // _accessToken = null;
  //   _userData = null;
  //   setState(() {});
  // }

  Future<void> loginwithDB() async {
    var url = Uri.parse('http://54.163.243.254/users/login');
    return await Future.delayed(
        const Duration(seconds: 2),
        () => {
              http.post(
                url,
                body: {
                  'email': userData.email,
                  'password': userData.password,
                },
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Dashboard(
                              userInfo: userFromJson(response.body));
                        },
                      ),
                    );
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return menuM(userInfo: userFromJson(response.body));
                    }));
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
                    builder: (ctx) =>
                        getAlertDialog("Error", "Server error", ctx));
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .92,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/images/Logo.png', height: 137),
                  SizedBox(
                    height: 450,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Correo electronico',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
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
                                                  : Icons.visibility_off)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // const Padding(
                                //     padding: EdgeInsets.only(top: 10)),
                                // const SizedBox(
                                //   width: double.infinity,
                                //   child: Text('Recuperar contraseña',
                                //       style: TextStyle(
                                //         fontSize: 15,
                                //         color: ColorSelect.kSecondaryColor,
                                //       ),
                                //       textAlign: TextAlign.end),
                                // ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 85,
                          //   child: Column(
                          //     children: [
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceAround,
                          //         children: [
                          //           Container(
                          //             height: 45,
                          //             decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(50),
                          //                 color: ColorSelect.kFacebookColor),
                          //             child: _checking
                          //                 ? Center(
                          //                     child: Column(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment.center,
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.center,
                          //                     children: [
                          //                       _userData != null
                          //                           ? Text(
                          //                               'name: ${_userData!['name']}')
                          //                           : Container(),
                          //                       _userData != null
                          //                           ? Text(
                          //                               'email: ${_userData!['email']}')
                          //                           : Container(),
                          //                       _userData != null
                          //                           ? Container(
                          //                               child: Image.network(
                          //                                   _userData![
                          //                                           'picture'][
                          //                                       'data']['url']),
                          //                             )
                          //                           : Container(),
                          //                       const SizedBox(
                          //                         height: 20,
                          //                       ),
                          //                       CupertinoButton(
                          //                           color: Colors.blue,
                          //                           child: Text(
                          //                             _userData != null
                          //                                 ? 'LOGOUT'
                          //                                 : 'LOGIN',
                          //                             style: const TextStyle(
                          //                                 color: Colors.white),
                          //                           ),
                          //                           onPressed: _userData != null
                          //                               ? _logoutFB
                          //                               : _loginFB)
                          //                     ],
                          //                   ))
                          //                 : IconButton(
                          //                     onPressed: () {
                          //                       _checkIfisLoggedIn();
                          //                     },
                          //                     icon: Image.asset(
                          //                         'assets/images/fb_logo.png',
                          //                         height: 45)),
                          //           ),
                          //           Container(
                          //             height: 45,
                          //             decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(50),
                          //                 color: Colors.red),
                          //             child: _isLoggedIn
                          //                 ? Column(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment.center,
                          //                     children: <Widget>[
                          //                       Image.network(
                          //                         _googleSignIn
                          //                             .currentUser!.photoUrl
                          //                             .toString(),
                          //                         height: 50,
                          //                         width: 50,
                          //                       ),
                          //                       Text(_googleSignIn
                          //                           .currentUser!.displayName
                          //                           .toString()),
                          //                       Text(_googleSignIn
                          //                           .currentUser!.email
                          //                           .toString()),
                          //                       OutlinedButton(
                          //                         child: const Text("Logout"),
                          //                         onPressed: () {
                          //                           _logout();
                          //                         },
                          //                       )
                          //                     ],
                          //                   )
                          //                 : IconButton(
                          //                     onPressed: () {
                          //                       setState(() {
                          //                         _passwordVisible =
                          //                             !_passwordVisible;
                          //                       });
                          //                     },
                          //                     alignment: Alignment.topCenter,
                          //                     icon: Icon(_passwordVisible
                          //                         ? Icons.visibility
                          //                         : Icons.visibility_off)),
                          //           ),
                          //           // ),
                          //           // ),
                          //         ],
                          //       ),
                          //       const Padding(
                          //           padding: EdgeInsets.only(top: 10)),
                          //       const SizedBox(
                          //         width: double.infinity,
                          //         child: Text('Recuperar contraseña',
                          //             style: TextStyle(
                          //               fontSize: 15,
                          //               color: ColorSelect.kSecondaryColor,
                          //             ),
                          //             textAlign: TextAlign.end),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('O Inicia Sesion con',
                                    style: TextStyle(fontSize: 17)),
                                SizedBox(
                                  width: 120,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: ColorSelect.kFacebookColor),
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Image.asset(
                                                'assets/images/fb_logo.png',
                                                height: 25)),
                                      ),
                                      Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.red),
                                        child: _isLoggedIn
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.network(
                                                    _googleSignIn
                                                        .currentUser!.photoUrl
                                                        .toString(),
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                  Text(_googleSignIn
                                                      .currentUser!.displayName
                                                      .toString()),
                                                  Text(_googleSignIn
                                                      .currentUser!.email
                                                      .toString()),
                                                  OutlinedButton(
                                                    child: const Text("Logout"),
                                                    onPressed: () {
                                                      _logout();
                                                    },
                                                  )
                                                ],
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  loginwithGoogle();
                                                },
                                                icon: Image.asset(
                                                    'assets/images/google_logo.png',
                                                    height: 45)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                                          ..onTap = () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterScreen())),
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
