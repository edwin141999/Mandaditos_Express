import 'package:mysql_client/mysql_client.dart';

Future<void> insertarDatos(tipoProducto, lugar, descripcion) async {
    // Crear la coneccion
    print("Conectando...");
    final conn = await MySQLConnection.createConnection(
      host: 'rds-me.cqdlxg2bft08.us-east-1.rds.amazonaws.com',
      port: 3306,
      userName: 'me',
      password: 'me123456',
      databaseName: 'me',
    );
    await conn.connect();
    print("Conectado.");

    // Insertar datos.
    var stmt = await conn.prepare(
      "insert into item (tipo_producto, recoger_ubicacion, descripcion) values (?, ?, ?)",
    );
    await stmt.execute([tipoProducto, lugar, descripcion]);

    // Ver resultados
    stmt = await conn.prepare("select * from item");
    var result = await stmt.execute([]);
    await stmt.deallocate();
    for (final row in result.rows) {
      print(row.assoc());
    }
    await conn.close();
  }