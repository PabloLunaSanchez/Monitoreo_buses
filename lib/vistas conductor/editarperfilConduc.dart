import 'dart:convert';
import 'dart:io';
import 'package:app_bus_tesis/api_conexion/api_conexion.dart';
import 'package:app_bus_tesis/conductorPreferences/currentUser.dart';
import 'package:app_bus_tesis/userPreferences/currentUser.dart';
import 'package:app_bus_tesis/vistas%20conductor/principal_conductor.dart';
import 'package:app_bus_tesis/vistas%20conductor/registroconductor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  CurrentUserConductor _currentConductor = Get.find(); // Obtener la instancia de CurrentUser

  // Controladores para los campos de texto
  TextEditingController nombreController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController placaController = TextEditingController();
  TextEditingController capacidadController = TextEditingController();
  TextEditingController puertasController = TextEditingController();

  File? _file;
  String status = '';
  File? tempfile;
  String error = 'Error';

  Future<void> chooseImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });

      // Guardar la ruta del archivo en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_image_path', pickedFile.path);
    }
  }

  @override
  void initState() {
    super.initState();
    // Cargar los datos del usuario al iniciar la pantalla
    cargarDatosUsuario();
    loadSavedImage();
  }

  void cargarDatosUsuario() {
    // Actualizar los controladores con los datos actuales del usuario
    nombreController.text = _currentConductor.user.nombre;
    correoController.text = _currentConductor.user.correo;
    contrasenaController.text = _currentConductor.user.contrasena;
    telefonoController.text = _currentConductor.user.telefono;
    placaController.text = _currentConductor.user.placa;
    capacidadController.text = _currentConductor.user.capacidad;
    puertasController.text = _currentConductor.user.puertas;
  }

  void saveChanges() async {
    // Convertir la imagen a base64
    String base64Image = '';
    if (_file != null) {
      List<int> imageBytes = await _file!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    var url = API.actualizarconductor; // URL de tu API para actualizar datos
    var response = await http.post(
      Uri.parse(url),
      body: {
        'id_conductor': _currentConductor.user.id_conductor.toString(),
        'nombre': nombreController.text,
        'correo': correoController.text,
        'contrasena': contrasenaController.text,
        'telefono': telefonoController.text,
        'placa': placaController.text,
        'capacidad': capacidadController.text,
        'puertas': puertasController.text,
        'image': base64Image, // Añadir la imagen a la solicitud
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        var updatedUser = jsonResponse['user'];

        setState(() {
          // Actualizar los datos en _currentUser después de guardar
          _currentConductor.user.nombre = updatedUser['nombre'];
          _currentConductor.user.correo = updatedUser['correo'];
          _currentConductor.user.contrasena = updatedUser['contrasena'];
          _currentConductor.user.telefono = updatedUser['telefono'];
          _currentConductor.user.placa = updatedUser['placa'];
          _currentConductor.user.capacidad = updatedUser['capacidad'];
          _currentConductor.user.puertas = updatedUser['puertas'];
          _currentConductor.user.base64Image = updatedUser['image'];
        });

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Perfil actualizado correctamente'),
        ));
      } else {
        // Mostrar mensaje de error si falla la actualización
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error actualizando perfil'),
        ));
      }
    } else {
      // Mostrar mensaje de error si falla la solicitud HTTP
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error de conexión al actualizar perfil'),
      ));
    }
  }

  void loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('user_image_path');
    if (imagePath != null) {
      setState(() {
        _file = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     String imageUrl =
        'http://192.168.1.164/api_tesis_monitoreo_buses/uploads/image${_currentConductor.user.base64Image}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PrincipalConductor()));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Editar Perfil",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
             Center(
                child: Stack(
                  children: [
                    if (_file != null)
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_file!),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(imageUrl),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 45,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.green,
                        ),
                        child: IconButton(
                          onPressed: chooseImage,
                          icon: const Icon(Icons.add_a_photo,
                              size: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Nombre", nombreController),
              buildTextField("Correo", correoController),
              buildTextField("Contraseña", contrasenaController, isPassword: true),
              buildTextField("Telefono", telefonoController),
              buildTextField("Placa", placaController),
              buildTextField("Capacidad de asientos", capacidadController),
              buildTextField("Puertas", puertasController),
              SizedBox(
                height: 35,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: Text("CANCEL",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.black)),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepOrange),
                      ),
                      onPressed: () {
                        saveChanges();
                      },
                      child: Text('Guardar'),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
