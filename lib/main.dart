import 'package:app_bus_tesis/userPreferences/user_preferences.dart';
import 'package:app_bus_tesis/vistas%20cliente/homepage.dart';
import 'package:app_bus_tesis/vistas%20conductor/Login.dart';
import 'package:app_bus_tesis/vistas%20conductor/Login_conductor.dart';
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
      // routes: {
      //   '/onboarding': (context) =>
      //       const OnboardingScreen(), // Ruta para la pantalla de bienvenida
      //   '/Login': (context) => Conductor_ClientePage(), // Ruta para la próxima página
      // },
      home: FutureBuilder(
        future: RecordarUserPref.LeerUserInfo(),
        builder: (context, dataSnapShot){
          if(dataSnapShot.data == null){
            return Conductor_ClientePage();
          }
          else{
            return MapaPage();
          }
        }
        
 
      ),
      
    );
  }
}