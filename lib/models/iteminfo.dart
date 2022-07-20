import 'dart:convert';
import 'dart:ffi';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));
String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  Item({
    required this.items,
  });

  List<ItemClass> items;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        items: List<ItemClass>.from(
            json["items"].map((x) => ItemClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ItemClass {
  ItemClass({
    required this.id,
    required this.tipoProducto,
    required this.ubicacion,
    required this.descripcion,
    required this.precio,
  });

  int id;
  String tipoProducto;
  String ubicacion;
  String descripcion;
  Float precio;

  factory ItemClass.fromJson(Map<String, dynamic> json) => ItemClass(
    id: json["id"],
    tipoProducto: json["tipo_producto"],
    ubicacion: json["recoger_ubicacion"],
    descripcion: json["descripcion"],
    precio: json["precio_producto"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tipo_producto": tipoProducto,
    "recoger_ubicacion": ubicacion,
    "descripcion": descripcion,
    "precio_producto": precio
  };
}
