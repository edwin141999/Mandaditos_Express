// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.token,
    required this.user,
    required this.datatype,
  });

  String token;
  UserClass user;
  List<Datatype> datatype;

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json["token"],
        user: UserClass.fromJson(json["user"]),
        datatype: List<Datatype>.from(
            json["datatype"].map((x) => Datatype.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
        "datatype": List<dynamic>.from(datatype.map((x) => x.toJson())),
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
