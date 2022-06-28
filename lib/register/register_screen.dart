import 'package:flutter/material.dart';
import 'package:mandaditos_express/login/login_screen.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;

  List<String> types = ['Cliente', 'Repartidor'];
  String typeValue = 'Cliente';

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                      child: Image.asset('assets/images/Logo.png', height: 70)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Soy', style: TextStyle(fontSize: 15)),
                      Container(
                        height: 25,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: ColorSelect.kColorDropdown, width: 0),
                            color: ColorSelect.kColorDropdown),
                        child: DropdownButton(
                          value: typeValue,
                          items: types.map((items) {
                            return DropdownMenuItem(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * .7,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    items,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: ColorSelect.kTextDropdown,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              value: items,
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              typeValue = value!;
                            });
                          },
                          underline: Container(),
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
                    children: const [
                      Text(
                        'Nombre',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(
                        height: 25,
                        child: TextField(
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
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
                    children: const [
                      Text(
                        'Apellido',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(
                        height: 25,
                        child: TextField(
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
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
                (typeValue == 'Cliente')
                    ? SizedBox(
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              'Direccion',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(
                              height: 25,
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
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
                      )
                    : SizedBox(
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              'Ciudad donde conduciras',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(
                              height: 27,
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Ej. Tuxtla Gutierrez',
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
