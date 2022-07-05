import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mandaditos_express/register/register_choose.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;

  bool _isLoggedIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    }
    catch(err) {
      print(err);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    height: 137,
                  ),
                ),
                SizedBox(
                  height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              'Correo electronico',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(
                              height: 27,
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Ingrese su correo electronico',
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
                        height: 75,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('Contraseña',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                                SizedBox(
                                  height: 30,
                                  child: TextField(
                                    obscureText: !_passwordVisible,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Ingrese su contraseña',
                                      hintStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromRGBO(139, 139, 139, 1),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 0),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
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
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            const SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Recuperar contraseña',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ColorSelect.kSecondaryColor,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {},
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
                      const Text('O Inicia Sesion usando',
                          style: TextStyle(fontSize: 15)),
                      SizedBox(
                        width: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: ColorSelect.kFacebookColor),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Image.asset('assets/images/fb_logo.png',
                                      height: 25)),
                            ),
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red
                              ),

                              child: _isLoggedIn
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget> [
                                    Image.network(
                                      _googleSignIn.currentUser!.photoUrl.toString(),
                                      height: 50,
                                      width: 50,
                                    ),
                                    Text(_googleSignIn.currentUser!.displayName.toString()),
                                    Text(_googleSignIn.currentUser!.email.toString()),
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
                                    _login();
                                  },
                                  icon: Image.asset(
                                    'assets/images/google_logo.png',
                                    height: 45
                                  )
                                ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Text('¿No tienes una cuenta?',
                              style: TextStyle(fontSize: 15)),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Registrate aqui',
                                  style: const TextStyle(
                                      color: ColorSelect.kSecondaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterChoose())),
                                )
                              ],
                            ),
                          ),
                        ],
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
