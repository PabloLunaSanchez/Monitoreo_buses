import 'package:app_bus_tesis/vistas%20conductor/Login_conductor.dart';

class API {
  static const hostConnect = "http://192.168.1.164/api_tesis_monitoreo_buses";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectConductor = "$hostConnect/conductor";


  static const validateEmailUser = "$hostConnect/user/validar_email.php";
  static const signUpUser = "$hostConnect/user/registro.php";
  static const login = "$hostConnect/user/login.php";
  static const loginConductor = "$hostConnect/conductor/login.php";
  static const actualizar = "$hostConnect/user/actualizarDatos.php";
  static const actualizarconductor = "$hostConnect/conductor/actualizarDatos.php";
  

  static const validateEmailConductor = "$hostConnect/conductor/validar_email.php";
  static const signUpConductor = "$hostConnect/conductor/registro.php";

    static const listaAlumnos = "$hostConnect/conductor/listaalumnos.php";
}
