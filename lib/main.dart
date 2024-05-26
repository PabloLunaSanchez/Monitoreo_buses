import 'package:app_bus_tesis/vistas%20cliente/homepage.dart';
import 'package:app_bus_tesis/vistas%20conductor/Login.dart';
import 'package:app_bus_tesis/vistas%20conductor/bienvCond_Client.dart';
import 'package:app_bus_tesis/vistas%20conductor/onboarding_screen.dart';
import 'package:app_bus_tesis/vistas%20conductor/principal_conductor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding', // Agregar una ruta inicial
      routes: {
        '/onboarding': (context) =>
            const OnboardingScreen(), // Ruta para la pantalla de bienvenida
        '/Login': (context) => PrincipalConductor(), // Ruta para la próxima página
      },
      home: FutureBuilder(
        future: yourFutureFunction(), // Proporciona un Future a FutureBuilder
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Si el Future ha terminado, puedes mostrar LoginScreen
            return LoginScreen();
          } else {
            // Mientras tanto, puedes mostrar un indicador de carga o algo más
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> yourFutureFunction() {
    // Simula una operación asíncrona que se resuelve después de 2 segundos
    return Future.delayed(Duration(seconds: 2));
  }
}
