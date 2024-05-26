// ignore_for_file: unused_element

import 'dart:convert';

import 'package:app_bus_tesis/Modelos/conductor.dart';
import 'package:app_bus_tesis/api_conexion/api_conexion.dart';
import 'package:app_bus_tesis/vistas%20conductor/Login_conductor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

String email = '';
String password = '';
String number = '';
String name = '';
String placas = '';
String capacidad = '';

class Registroconductor2 extends StatefulWidget {
  @override
  _Registroconductor2State createState() => _Registroconductor2State();
}

class _Registroconductor2State extends State<Registroconductor2> {
  bool showLoading = false;
  var formkey = GlobalKey<FormState>();
  var nombreController = TextEditingController();
  var correoController = TextEditingController();
  var contrasenaController = TextEditingController();
  var telefonoController = TextEditingController();
  var placaController = TextEditingController();
  var capacidadController = TextEditingController();
  var puertasController = TextEditingController();

  validateUserEmail() async {
    try {
      var res = await http.post(Uri.parse(API.validateEmailConductor),
          body: {'correo': correoController.text.trim()});

      if (res.statusCode == 200) {
        //from flutter
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if (resBodyOfValidateEmail['emailFound'] == true) {
          Fluttertoast.showToast(
              msg: "El email ya esta siendo usado por otro usuario");
        } else {
          registraryguardarusuarios();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registraryguardarusuarios() async {
    // Convertir el número de teléfono a un entero si es necesario
    int telefono = int.parse(telefonoController.text.trim());
    int capacidad = int.parse(capacidadController.text.trim());
    int puertas = int.parse(puertasController.text.trim());

    Conductor userModel = Conductor(
        1,
        nombreController.text.trim(),
        correoController.text.trim(),
        contrasenaController.text.trim(),
        telefonoController.text.trim(),
        placaController.text.trim(),
        capacidadController.text.trim(),
        puertasController.text.trim());
    try {
      var res =
          await http.post(Uri.parse(API.signUpConductor), body: userModel.toJson());

      if (res.statusCode == 200) {
        var resBodyOfSingup = jsonDecode(res.body);
        if (resBodyOfSingup['success'] == true) {
          Fluttertoast.showToast(msg: "Felicidades tu cuenta ha sido creada");
        } else {
          Fluttertoast.showToast(msg: "Ocurrio un error");
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoading
          ? loading2(fromColor: Colors.yellowAccent, toColor: Colors.redAccent)
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0),
                    Hero(
                      tag: 'Auth',
                      child: Image.asset(
                        'assets/images/bus circular.jpeg',
                        scale: 1.5,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Registrar Conductor',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Brand Bold',
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          _buildInputField(
                            'Placa',
                            TextInputType.name,
                            placaController,
                            (val) => val == ""
                                ? "Por favor escribe tu placa"
                                : null, // Función de validación
                            Icons.directions_car,
                          ),
                          SizedBox(height: 20.0),
                          _buildInputField(
                            'Capacidad',
                            TextInputType.phone,
                            capacidadController,
                            (val) => val == ""
                                ? "Por favor escribe la capacidad"
                                : null, // Función de validación
                            Icons.event_seat,
                          ),
                          SizedBox(height: 20.0),
                          _buildInputField(
                            'Total de puertas',
                            TextInputType.phone,
                            puertasController,
                            (val) => val == ""
                                ? "Por favor escribe el total de puertas"
                                : null, // Función de validación
                            Icons.door_front_door_sharp,
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20.0),
                    Material(
                      //boton login
                      color: Color.fromARGB(255, 15, 67, 172),
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            validateUserEmail();
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Text(
                            "Registrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      '¿Ya tienes una cuenta? ',
                      style: TextStyle(
                        color: Colors.black87, // Texto negro
                        fontSize: 16.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginConductor()),
                        );
                      },
                      child: Text(
                        'Inicia sesión aquí.',
                        style: TextStyle(
                          color: Colors.blue, // Texto azul
                          fontSize: 16.0,
                          decoration: TextDecoration.underline, // Subrayado
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInputField(
      String hintText,
      TextInputType keyboardType,
      TextEditingController controller,
      Function(String)?
          onChanged, // Cambia Function(String) por Function(String)?
      IconData? prefixIcon,
      {bool obscureText = false,
      String? Function(String?)? validator} // Cambia dynamic por String?
      ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        style: TextStyle(
            fontSize: 15.0, fontFamily: 'Brand Bold', color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon)
              : null, // Icono a la izquierda del campo de texto
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Brand Bold'),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.black87),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: validator, // Usar el validador proporcionado
      ),
    );
  }

  Widget loading2({required Color fromColor, required Color toColor}) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
      ),
    );
  }
}
