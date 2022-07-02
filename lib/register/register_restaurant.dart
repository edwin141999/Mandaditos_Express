import 'package:flutter/material.dart';
import 'package:mandaditos_express/login/login_screen.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class RegisterRestaurant extends StatefulWidget {
  const RegisterRestaurant({Key? key}) : super(key: key);

  @override
  State<RegisterRestaurant> createState() => _RegisterRestaurantState();
}

class _RegisterRestaurantState extends State<RegisterRestaurant> {
  bool _passwordVisible = false;

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
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                      child:
                          Image.asset('assets/images/Logo.png', height: 137)),
                ),
                SizedBox(
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text(
                        'Nombre del negocio',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(
                        height: 25,
                        child: TextField(
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Ej. Tienda 3 Hermanos',
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
                    children: const [
                      Text(
                        'Correo electronico',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(
                        height: 27,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
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
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          const Padding(padding: EdgeInsets.only(right: 5)),
                          Image.asset('assets/images/info_svg.png', height: 20),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                        child: TextField(
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
                            contentPadding: const EdgeInsets.only(bottom: 0),
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
                    children: const [
                      Text(
                        'Direccion',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(
                        height: 25,
                        child: TextField(
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Ej. Lib Norte',
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
                    children: const [
                      Text(
                        'Numero Telefonico',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(
                        height: 27,
                        child: TextField(
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
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
    );
  }
}
