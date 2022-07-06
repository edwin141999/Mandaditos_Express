import 'package:flutter/material.dart';
import 'package:mandaditos_express/register/register_client.dart';
import 'package:mandaditos_express/register/register_delivery.dart';
import 'package:mandaditos_express/register/register_restaurant.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class RegisterChoose extends StatefulWidget {
  const RegisterChoose({Key? key}) : super(key: key);

  @override
  State<RegisterChoose> createState() => _RegisterChooseState();
}

class _RegisterChooseState extends State<RegisterChoose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Image.asset('assets/images/Logo.png', height: 137),
              ),
              SizedBox(
                height: 270,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const RegisterDelivery()));
                        },
                        child: const Text('Registrarse como repartidor',
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
                      height: 55,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => const RegisterCliente()));
                        },
                        child: const Text('Registrarse como cliente',
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
                      height: 55,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      const RegisterRestaurant()));
                        },
                        child: const Text('Registrarse como negocio',
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
            ],
          ),
        ),
      ),
    ));
  }
}
