// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User(
      {required this.token,
      required this.user,
      required this.datatype,
      this.metodoPago});

  String token;
  UserClass user;
  List<Datatype> datatype;
  List<MetodoPago>? metodoPago;

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token"],
        user: UserClass.fromJson(json["user"]),
        datatype: List<Datatype>.from(
            json["datatype"].map((x) => Datatype.fromJson(x))),
        // if metodoPago is null, then it will be null in the json
        metodoPago: json["metodoPago"] == null
            ? null
            : List<MetodoPago>.from(
                json["metodoPago"].map((x) => MetodoPago.fromJson(x))),
        // metodoPago: List<MetodoPago>.from(
        //     json["metodoPago"].map((x) => MetodoPago.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
        "datatype": List<dynamic>.from(datatype.map((x) => x.toJson())),
        "metodoPago": List<dynamic>.from(metodoPago!.map((x) => x.toJson())),
      };
}

class Datatype {
  Datatype({
    required this.id,
    required this.userId,
    this.direccion,
    // required this.direccion,
    required this.latitud,
    required this.longitud,
    this.cityDrive,
    this.estado,
  });

  int id;
  int userId;
  dynamic direccion;
  String latitud;
  String longitud;
  dynamic cityDrive;
  dynamic estado;

  factory Datatype.fromJson(Map<String, dynamic> json) => Datatype(
        id: json["id"],
        userId: json["user_id"],
        direccion: json["direccion"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        cityDrive: json["city_drive"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "direccion": direccion,
        "latitud": latitud,
        "longitud": longitud,
        "city_drive": cityDrive,
        "estado": estado,
      };
}

class MetodoPago {
  MetodoPago({
    required this.id,
    required this.userId,
    required this.metodo,
    this.cvv,
    this.monthExpiracion,
    this.nombreTarjeta,
    this.numeroTarjeta,
    this.yearExpiracion,
    this.nombreBanco,
  });

  int id;
  int userId;
  String metodo;
  dynamic cvv;
  dynamic monthExpiracion;
  dynamic nombreTarjeta;
  dynamic numeroTarjeta;
  dynamic yearExpiracion;
  dynamic nombreBanco;

  factory MetodoPago.fromJson(Map<String, dynamic> json) => MetodoPago(
        id: json["id"],
        userId: json["user_id"],
        metodo: json["metodo"],
        cvv: json["cvv"],
        monthExpiracion: json["month_expiracion"],
        nombreTarjeta: json["nombre_tarjeta"],
        numeroTarjeta: json["numero_tarjeta"],
        yearExpiracion: json["year_expiracion"],
        nombreBanco: json["nombre_banco"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "metodo": metodo,
        "cvv": cvv,
        "month_expiracion": monthExpiracion,
        "nombre_tarjeta": nombreTarjeta,
        "numero_tarjeta": numeroTarjeta,
        "year_expiracion": yearExpiracion,
        "nombre_banco": nombreBanco,
      };
}

class UserClass {
  UserClass({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.userType,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String password;
  String phoneNumber;
  String userType;

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        phoneNumber: json["phone_number"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "phone_number": phoneNumber,
        "user_type": userType,
      };
}
