class Conductor {
  int id_conductor;
  String correo;
  String contrasena;
  String nombre_conductor;
  String telefono;
  String placa;
  String capacidad;
  String puertas;

  Conductor(this.id_conductor, this.nombre_conductor, this.correo, this.contrasena, 
      this.telefono, this.placa, this.capacidad, this.puertas);
  Map<String, dynamic> toJson() => {
        'id_conductor': id_conductor.toString(),
        'nombre_conductor': nombre_conductor,
        'correo': correo,
        'contrasena': contrasena,
        'telefono': telefono,
        'placa': placa,
        'capacidad': capacidad,
        'puertas': puertas,
      };
}
