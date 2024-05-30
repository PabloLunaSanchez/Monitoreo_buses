import 'dart:convert';
import 'package:app_bus_tesis/userPreferences/currentUser.dart';
import 'package:app_bus_tesis/vistas%20cliente/homepage.dart';
import 'package:app_bus_tesis/vistas%20conductor/principal_conductor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart' as http;


class EditProfilePageCliente extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePageCliente> {

void saveChanges() {
    // Aquí puedes implementar la lógica para guardar los cambios.
    // Por ejemplo, puedes enviar los datos al servidor o almacenarlos localmente.

    // Ejemplo de impresión para demostrar cómo acceder a los datos del perfil.
    print("Nombre: ${_currentUser.user.nombre_tutor}");
    print("Correo: ${_currentUser.user.correo}");
    print("Contraseña: ${_currentUser.user.contrasena}");
    print("Telefono: ${_currentUser.user.telefono}");
  }

  bool showPassword = false;
   CurrentUser _currentUser = Get.put(CurrentUser());



  @override
  Widget build(BuildContext context) {
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MapaPage()));
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
                            image: AssetImage(
                                "assets/images/avatar-cindy-.png"), // Reemplaza "tu_imagen.png" con la ruta correcta de tu imagen
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                 buildTextField("Correo", _currentUser.user.correo, false),
                buildTextField("Contraseña", _currentUser.user.contrasena, true),
                  buildTextField("Telefono", _currentUser.user.telefono, false),
                   buildTextField("Nombre del tutor", _currentUser.user.nombre_tutor, false),
                buildTextField("Apellido Tutor", _currentUser.user.apellido_tutor, false),
               
                buildTextField("Nombre del hijo", _currentUser.user.nombre_hijo, false),
                buildTextField("Apellido del hijo", _currentUser.user.apellido_hijo, false),

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
                        onPressed: saveChanges,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepOrange),
                        ),
                        child: Text('Guardar'),
                      ),
                    ])
              ],
            )),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? !showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
           
            color: Colors.black,
          ),
        ),
         onChanged: (value) {
          setState(() {
            if (labelText == "Nombre") {
              _currentUser.user.nombre_tutor = value;
            } else if (labelText == "Correo") {
             _currentUser.user.correo = value;
            } else if (labelText == "Contraseña") {
             _currentUser.user.contrasena = value;
            } else if (labelText == "Telefono") {
              _currentUser.user.telefono = value;
            }
          });
  }),
    );
  }
}