import 'package:app_bus_tesis/vistas%20conductor/registroconductor.dart';

class User {
  int user_id;
  String correo;
  String contrasena;
  String nombre_tutor;
  String apellido_tutor;
  String nombre_hijo;
  String apellido_hijo;
  String telefono;

  User(this.user_id, this.correo, this.contrasena, this.nombre_tutor,
      this.apellido_tutor, this.nombre_hijo, this.apellido_hijo, this.telefono);

  factory User.fromJson(Map<String, dynamic> json) => User(
        int.parse(json["user_id"]),
        json["correo"],
        json["contrasena"],
        json["nombre_tutor"],
        json["apellido_tutor"],
        json["nombre_hijo"],
        json["apellido_hijo"],
        json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'correo': correo,
        'contrasena': contrasena,
        'telefono': telefono,
        'nombre_tutor': nombre_tutor,
        'apellido_tutor': apellido_tutor,
        'nombre_hijo': nombre_hijo,
        'apellido_hijo': apellido_hijo,
      };
}
