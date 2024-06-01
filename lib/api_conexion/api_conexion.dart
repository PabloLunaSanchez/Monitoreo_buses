class API {
  static const hostConnect = "http://192.168.1.164/api_tesis_monitoreo_buses";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectConductor = "$hostConnect/conductor";


  static const validateEmailUser = "$hostConnect/user/validar_email.php";
  static const signUpUser = "$hostConnect/user/registro.php";
  static const login = "$hostConnect/user/login.php";
  static const actualizar = "$hostConnect/user/actualizarDatos.php";
  static const insertarimagen = "$hostConnect/user/imagenes.php";



  static const validateEmailConductor = "$hostConnect/conductor/validar_email.php";
  static const signUpConductor = "$hostConnect/conductor/registro.php";

    static const listaAlumnos = "$hostConnect/conductor/listaalumnos.php";
}
