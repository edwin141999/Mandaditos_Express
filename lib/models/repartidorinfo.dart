// To parse this JSON data, do
//
//     final repartidorInfo = repartidorInfoFromJson(jsonString);

import 'dart:convert';

RepartidorInfo repartidorInfoFromJson(String str) =>
    RepartidorInfo.fromJson(json.decode(str));

String repartidorInfoToJson(RepartidorInfo data) => json.encode(data.toJson());

class RepartidorInfo {
  RepartidorInfo({
    required this.repartidor,
  });

  Repartidor repartidor;

  factory RepartidorInfo.fromJson(Map<String, dynamic> json) => RepartidorInfo(
        repartidor: Repartidor.fromJson(json["repartidor"]),
      );

  Map<String, dynamic> toJson() => {
        "repartidor": repartidor.toJson(),
      };
}

class Repartidor {
  Repartidor({
    required this.id,
    required this.userId,
    required this.cityDrive,
    required this.estado,
    required this.latitud,
    required this.longitud,
  });

  int id;
  int userId;
  String cityDrive;
  String estado;
  String latitud;
  String longitud;

  factory Repartidor.fromJson(Map<String, dynamic> json) => Repartidor(
        id: json["id"],
        userId: json["user_id"],
        cityDrive: json["city_drive"],
        estado: json["estado"],
        latitud: json["latitud"],
        longitud: json["longitud"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "city_drive": cityDrive,
        "estado": estado,
        "latitud": latitud,
        "longitud": longitud,
      };
}
