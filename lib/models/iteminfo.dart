// To parse this JSON data, do
//
//     final itemInfo = itemInfoFromJson(jsonString);

import 'dart:convert';

ItemInfo itemInfoFromJson(String str) => ItemInfo.fromJson(json.decode(str));

String itemInfoToJson(ItemInfo data) => json.encode(data.toJson());

class ItemInfo {
  ItemInfo({
    required this.item,
  });

  Item item;

  factory ItemInfo.fromJson(Map<String, dynamic> json) => ItemInfo(
        item: Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "item": item.toJson(),
      };
}

class Item {
  Item({
    required this.id,
    required this.tipoProducto,
    required this.recogerUbicacion,
    required this.descripcion,
    required this.precioProducto,
    required this.latitud,
    required this.longitud,
  });

  int id;
  String tipoProducto;
  String recogerUbicacion;
  String descripcion;
  String precioProducto;
  String latitud;
  String longitud;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        tipoProducto: json["tipo_producto"],
        recogerUbicacion: json["recoger_ubicacion"],
        descripcion: json["descripcion"],
        precioProducto: json["precio_producto"],
        latitud: json["latitud"],
        longitud: json["longitud"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo_producto": tipoProducto,
        "recoger_ubicacion": recogerUbicacion,
        "descripcion": descripcion,
        "precio_producto": precioProducto,
        "latitud": latitud,
        "longitud": longitud,
      };
}
