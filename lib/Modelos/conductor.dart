class Conductor {
  int id_conductor;
  String correo;
  String contrasena;
  String nombre;
  String telefono;
  String placa;
  String capacidad;
  String puertas;
 String
      base64Image; // Asegúrate de que el nombre del campo coincida con tu uso
  Conductor(this.id_conductor, this.nombre, this.correo, this.contrasena, 
      this.telefono, this.placa, this.capacidad, this.puertas, this.base64Image);


   factory Conductor.fromJson(Map<String, dynamic> json) => Conductor(
        int.parse(json["id_conductor"]),
        json["nombre"],
        json["correo"],
        json["contrasena"],
        json["telefono"],
        json["placa"],
        json["capacidad"],
        json["puertas"],
        json["image"], 
      );


  Map<String, dynamic> toJson() => {
        'id_conductor': id_conductor.toString(),
        'nombre': nombre,
        'correo': correo,
        'contrasena': contrasena,
        'telefono': telefono,
        'placa': placa,
        'capacidad': capacidad,
        'puertas': puertas,
        'image': base64Image, 
      };
}
