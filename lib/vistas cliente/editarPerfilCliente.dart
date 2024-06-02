import 'dart:convert';
import 'dart:io';
import 'package:app_bus_tesis/api_conexion/api_conexion.dart';
import 'package:app_bus_tesis/userPreferences/currentUser.dart';
import 'package:app_bus_tesis/vistas%20cliente/homepage.dart';
import 'package:app_bus_tesis/vistas%20conductor/principal_conductor.dart';
import 'package:app_bus_tesis/vistas%20conductor/registroConductorParte2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePageCliente extends StatefulWidget {
  static final GlobalKey<_EditProfilePageState> editProfileKey =
      GlobalKey<_EditProfilePageState>();
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePageCliente> {
  CurrentUser _currentUser = Get.find(); // Obtener la instancia de CurrentUser

  // Controladores para los campos de texto
  TextEditingController correoController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController nombreTutorController = TextEditingController();
  TextEditingController apellidoTutorController = TextEditingController();
  TextEditingController nombreHijoController = TextEditingController();
  TextEditingController apellidoHijoController = TextEditingController();
  TextEditingController nameController = TextEditingController();

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

  void loadSavedImage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? imagePath = prefs.getString('user_image_path');
  if (imagePath != null) {
    setState(() {
      _file = File(imagePath);
    });
  }
}

  void cargarDatosUsuario() {
    // Actualizar los controladores con los datos actuales del usuario
    correoController.text = _currentUser.user.correo;
    contrasenaController.text = _currentUser.user.contrasena;
    telefonoController.text = _currentUser.user.telefono;
    nombreTutorController.text = _currentUser.user.nombre_tutor;
    apellidoTutorController.text = _currentUser.user.apellido_tutor;
    nombreHijoController.text = _currentUser.user.nombre_hijo;
    apellidoHijoController.text = _currentUser.user.apellido_hijo;
  }

  void saveChanges() async {
    var url = API.actualizar; // URL de tu API para actualizar datos
    var response = await http.post(
      Uri.parse(url),
      body: {
        'user_id': _currentUser.user.user_id.toString(),
        'nombre_tutor': nombreTutorController.text,
        'correo': correoController.text,
        'contrasena': contrasenaController.text,
        'telefono': telefonoController.text,
        'apellido_tutor': apellidoTutorController.text,
        'nombre_hijo': nombreHijoController.text,
        'apellido_hijo': apellidoHijoController.text,
      },
    );
    

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        var updatedUser = jsonResponse['user'];

        setState(() {
          // Actualizar los datos en _currentUser después de guardar
          _currentUser.user.nombre_tutor = updatedUser['nombre_tutor'];
          _currentUser.user.correo = updatedUser['correo'];
          _currentUser.user.contrasena = updatedUser['contrasena'];
          _currentUser.user.telefono = updatedUser['telefono'];
          _currentUser.user.apellido_tutor = updatedUser['apellido_tutor'];
          _currentUser.user.nombre_hijo = updatedUser['nombre_hijo'];
          _currentUser.user.apellido_hijo = updatedUser['apellido_hijo'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: EditProfilePageCliente.editProfileKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Get.back(result: MapaPage());
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
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
              SizedBox(height: 15),
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
                            image: AssetImage("assets/images/Placeholder.png"),
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
                          icon: const Icon(Icons.add_a_photo, size: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),
              // Campos de texto para editar perfil
              buildTextField("Correo", correoController),
              buildTextField("Contraseña", contrasenaController, isPassword: true),
              buildTextField("Teléfono", telefonoController),
              buildTextField("Nombre del tutor", nombreTutorController),
              buildTextField("Apellido del tutor", apellidoTutorController),
              buildTextField("Nombre del hijo", nombreHijoController),
              buildTextField("Apellido del hijo", apellidoHijoController),
              SizedBox(height: 35),
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
                    onPressed: () {
                      // Acción al presionar "Cancelar"
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                        saveChanges();
                        
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepOrange,
                      ),
                    ),
                    child: Text('Guardar'),
                  ),
                ],
              ),
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
