import 'package:flutter/material.dart';
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
        child: const Text('Close'),
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

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      register();
    }
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  Future<void> register() async {
    // var url = Uri.parse('http://192.168.100.13:3000/users/register');
    var url = Uri.parse(
        'http://ec2-54-174-241-22.compute-1.amazonaws.com/users/register');
    return await Future.delayed(
        const Duration(seconds: 2),
        () => {
              http.post(
                url,
                body: {
                  'first_name': userData.firstName,
                  'last_name': userData.lastName,
                  'email': userData.email,
                  'password': userData.password,
                  'phone_number': userData.phoneNumber,
                  'user_type': userData.userType,
                  'direccion': userData.address
                },
              ).then((response) {
                Map<String, dynamic> responseMap = json.decode(response.body);
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.greenAccent[200],
                      elevation: 1,
                      content: const Text(
                        'You are Signed Up!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else {
                  if (responseMap.containsKey("message")) {
                    showDialog(
                        context: context,
                        builder: (ctx) => getAlertDialog("Register failed",
                            '${responseMap["message"]}', ctx));
                  }
                }
              }).catchError((err) {
                showDialog(
                    context: context,
                    builder: (ctx) =>
                        getAlertDialog("Register failed", "Server error", ctx));
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                        child:
                            Image.asset('assets/images/Logo.png', height: 70)),
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
                                onTap: () {
                                  setState(() {
                                    userData.userType = items;
                                  });
                                },
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
                          height: 25,
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
                              userData.email = value!;
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5)),
                            Image.asset('assets/images/info_svg.png',
                                height: 20),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                          child: TextFormField(
                            onSaved: (value) {
                              userData.password = value!;
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
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black),
                            decoration: const InputDecoration(
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
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.black),
                                  decoration: const InputDecoration(
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
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.black),
                                  decoration: const InputDecoration(
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
    );
  }
}
