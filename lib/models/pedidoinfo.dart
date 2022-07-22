// To parse this JSON data, do
//
//     final pedido = pedidoFromJson(jsonString);
import 'dart:convert';

Pedido pedidoFromJson(String str) => Pedido.fromJson(json.decode(str));

String pedidoToJson(Pedido data) => json.encode(data.toJson());

class Pedido {
  Pedido({
    required this.pedidos,
  });

  List<PedidoElement> pedidos;

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        pedidos: List<PedidoElement>.from(
            json["pedidos"].map((x) => PedidoElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toJson())),
      };
}

class PedidoElement {
  PedidoElement({
    required this.id,
    required this.deliveryId,
    required this.envioId,
    required this.clienteId,
    required this.fechaSolicitada,
    required this.horaSolicitada,
    required this.horaEntregada,
    required this.entregaEstimada,
    required this.metodoPago,
    required this.subtotal,
    required this.cliente,
    required this.item,
  });

  int id;
  dynamic deliveryId;
  int envioId;
  int clienteId;
  DateTime fechaSolicitada;
  DateTime horaSolicitada;
  dynamic horaEntregada;
  int entregaEstimada;
  String metodoPago;
  String subtotal;
  Cliente cliente;
  Item item;

  factory PedidoElement.fromJson(Map<String, dynamic> json) => PedidoElement(
        id: json["id"],
        deliveryId: json["delivery_id"],
        envioId: json["envio_id"],
        clienteId: json["cliente_id"],
        fechaSolicitada: DateTime.parse(json["fecha_solicitada"]),
        horaSolicitada: DateTime.parse(json["hora_solicitada"]),
        horaEntregada: json["hora_entregada"],
        entregaEstimada: json["entrega_estimada"],
        metodoPago: json["metodo_pago"],
        subtotal: json["subtotal"],
        cliente: Cliente.fromJson(json["cliente"]),
        item: Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "delivery_id": deliveryId,
        "envio_id": envioId,
        "cliente_id": clienteId,
        "fecha_solicitada": fechaSolicitada.toIso8601String(),
        "hora_solicitada": horaSolicitada.toIso8601String(),
        "hora_entregada": horaEntregada,
        "entrega_estimada": entregaEstimada,
        "metodo_pago": metodoPago,
        "subtotal": subtotal,
        "cliente": cliente.toJson(),
        "item": item.toJson(),
      };
}

class Cliente {
  Cliente({
    required this.id,
    required this.userId,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    required this.users,
  });

  int id;
  int userId;
  String direccion;
  String latitud;
  String longitud;
  Users users;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        userId: json["user_id"],
        direccion: json["direccion"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        users: Users.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "direccion": direccion,
        "latitud": latitud,
        "longitud": longitud,
        "users": users.toJson(),
      };
}

class Users {
  Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.userType,
    required this.tipopago,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String password;
  String phoneNumber;
  String userType;
  List<Tipopago> tipopago;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        phoneNumber: json["phone_number"],
        userType: json["user_type"],
        tipopago: List<Tipopago>.from(
            json["tipopago"].map((x) => Tipopago.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "phone_number": phoneNumber,
        "user_type": userType,
        "tipopago": List<dynamic>.from(tipopago.map((x) => x.toJson())),
      };
}

class Tipopago {
  Tipopago({
    required this.id,
    required this.userId,
    required this.metodo,
    required this.cvv,
    required this.monthExpiracion,
    required this.nombreTarjeta,
    required this.numeroTarjeta,
    required this.yearExpiracion,
    required this.nombreBanco,
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

  factory Tipopago.fromJson(Map<String, dynamic> json) => Tipopago(
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
