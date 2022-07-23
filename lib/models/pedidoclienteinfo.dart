// To parse this JSON data, do
//
//     final pedidoCliente = pedidoClienteFromJson(jsonString);

import 'dart:convert';

PedidoCliente pedidoClienteFromJson(String str) =>
    PedidoCliente.fromJson(json.decode(str));

String pedidoClienteToJson(PedidoCliente data) => json.encode(data.toJson());

class PedidoCliente {
  PedidoCliente({
    required this.pedidos,
  });

  List<Pedido> pedidos;

  factory PedidoCliente.fromJson(Map<String, dynamic> json) => PedidoCliente(
        pedidos:
            List<Pedido>.from(json["pedidos"].map((x) => Pedido.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toJson())),
      };
}

class Pedido {
  Pedido({
    required this.id,
    this.deliveryId,
    required this.envioId,
    required this.clienteId,
    required this.fechaSolicitada,
    required this.horaSolicitada,
    this.horaEntregada,
    required this.entregaEstimada,
    required this.metodoPago,
    required this.subtotal,
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

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json["id"],
        deliveryId: json["delivery_id"],
        envioId: json["envio_id"],
        clienteId: json["cliente_id"],
        fechaSolicitada: DateTime.parse(json["fecha_solicitada"]),
        horaSolicitada: DateTime.parse(json["hora_solicitada"]),
        horaEntregada: json["hora_entregada"] == null
            ? null
            : DateTime.parse(json["hora_entregada"]),
        entregaEstimada: json["entrega_estimada"],
        metodoPago: json["metodo_pago"],
        subtotal: json["subtotal"],
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
      };
}
