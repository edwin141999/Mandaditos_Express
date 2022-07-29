import 'package:flutter/material.dart';
import 'package:mandaditos_express/cliente/dashboard_cliente.dart';
import 'package:mandaditos_express/cliente/historial_usuario.dart';
import 'package:mandaditos_express/cliente/mandados/confirmar_pedido.dart';
import 'package:mandaditos_express/cliente/mandados/solicitar_pedido.dart';
import 'package:mandaditos_express/cliente/monitoreo/pedido_monitoreo_user.dart';
import 'package:mandaditos_express/cliente/perfil_cliente.dart';
import 'package:mandaditos_express/login/login_screen.dart';
import 'package:mandaditos_express/metodos_pago/creartarjeta_screen.dart';
import 'package:mandaditos_express/metodos_pago/editartarjeta_screen.dart';
import 'package:mandaditos_express/metodos_pago/metodospago_screen.dart';
import 'package:mandaditos_express/register/register_screen.dart';
import 'package:mandaditos_express/repartidor/confirmar_mandado.dart';
import 'package:mandaditos_express/repartidor/dashboard_repartidor.dart';
import 'package:mandaditos_express/repartidor/mandados_disponibles.dart';
import 'package:mandaditos_express/repartidor/perfil_repartidor.dart';
import 'package:mandaditos_express/repartidor/ruta_mandado.dart';
import 'package:mandaditos_express/splash/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandaditos Express',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashView(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/cliente/dashboard': (_) => const Dashboard(),
        '/cliente/perfil': (_) => const PerfilCliente(),
        '/cliente/tarjetas': (_) => const MetodosPagoScreen(),
        '/cliente/agregartarjeta': (_) => const CreaTarjetaScreen(),
        '/cliente/editarTarjeta': (_) => const EditarTarjeta(),
        '/cliente/solictarMandado': (_) => const SolicitarPedido(),
        '/cliente/confirmarMandado': (_) => const ConfirmarPedido(),
        '/cliente/historialUsuario': (_) => const HistorialUsuario(),
        '/cliente/monitoreo': (_) => const PedidoMonitoreo(),
        '/repartidor/dashboard': (_) => const DashboardRepartidor(),
        '/repartidor/perfil': (_) => const PerfilRepartidor(),
        '/repartidor/mandadosDisponibles': (_) => const MandadosDisponibles(),
        '/repartidor/confirmarMandado': (_) => const ConfirmarMandado(),
        '/repartidor/rutaMandado': (_) => const RutaMandado(),
      },
    );
  }
}
