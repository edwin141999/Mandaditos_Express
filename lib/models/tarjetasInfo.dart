// To parse this JSON data, do
//
//     final tarjetasInfo = tarjetasInfoFromJson(jsonString);

import 'dart:convert';

TarjetasInfo tarjetasInfoFromJson(String str) =>
    TarjetasInfo.fromJson(json.decode(str));

String tarjetasInfoToJson(TarjetasInfo data) => json.encode(data.toJson());

class TarjetasInfo {
  TarjetasInfo({
    required this.tarjetas,
  });

  List<Tarjeta> tarjetas;

  factory TarjetasInfo.fromJson(Map<String, dynamic> json) => TarjetasInfo(
        tarjetas: List<Tarjeta>.from(
            json["tarjetas"].map((x) => Tarjeta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tarjetas": List<dynamic>.from(tarjetas.map((x) => x.toJson())),
      };
}

class Tarjeta {
  Tarjeta({
    required this.id,
    required this.userId,
    required this.metodo,
    this.nombreTarjeta,
    this.numeroTarjeta,
    this.yearExpiracion,
    this.monthExpiracion,
    this.cvv,
    this.nombreBanco,
  });

  int id;
  int userId;
  String metodo;
  dynamic nombreTarjeta;
  dynamic numeroTarjeta;
  dynamic yearExpiracion;
  dynamic monthExpiracion;
  dynamic cvv;
  dynamic nombreBanco;

  factory Tarjeta.fromJson(Map<String, dynamic> json) => Tarjeta(
        id: json["id"],
        userId: json["user_id"],
        metodo: json["metodo"],
        nombreTarjeta: json["nombre_tarjeta"],
        numeroTarjeta: json["numero_tarjeta"],
        yearExpiracion: json["year_expiracion"],
        monthExpiracion: json["month_expiracion"],
        cvv: json["cvv"],
        nombreBanco: json["nombre_banco"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "metodo": metodo,
        "nombre_tarjeta": nombreTarjeta,
        "numero_tarjeta": numeroTarjeta,
        "year_expiracion": yearExpiracion,
        "month_expiracion": monthExpiracion,
        "cvv": cvv,
        "nombre_banco": nombreBanco,
      };
}
