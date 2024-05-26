import 'dart:convert';

import 'package:app_bus_tesis/Modelos/conductor.dart';
import 'package:app_bus_tesis/api_conexion/api_conexion.dart';
import 'package:app_bus_tesis/vistas%20conductor/Login_conductor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

String correo = '';
String contrasena = '';
String telefono = '';
String nombre = '';
String placas = '';
String capacidad = '';
bool showPassword = false;

class Registroconductor1 extends StatefulWidget {
  @override
  _Registroconductor1State createState() => _Registroconductor1State();
}

class _Registroconductor1State extends State<Registroconductor1> {
  bool showLoading = false;
  var formkey = GlobalKey<FormState>();
  var nombreController = TextEditingController();
  var correoController = TextEditingController();
  var contrasenaController = TextEditingController();
  var telefonoController = TextEditingController();
  var placaController = TextEditingController();
  var capacidadController = TextEditingController();
  var puertasController = TextEditingController();
  var isObsecure = true.obs;

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
    Conductor conductorModel = Conductor(
        1,
        nombreController.text.trim(),
        correoController.text.trim(),
        contrasenaController.text.trim(),
        telefonoController.text.trim(),
        placaController.text.trim(),
        capacidadController.text.trim(),
        puertasController.text.trim());
    try {
      var res = await http.post(Uri.parse(API.signUpConductor),
          body: conductorModel.toJson());

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
            ? loading2(
                fromColor: Colors.yellowAccent,
                toColor: Colors.redAccent,
              )
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
                            TextFormField(
                              //email
                              controller: nombreController,
                              validator: (val) => val == ""
                                  ? "Por favor escribe tu nombre"
                                  : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 4, 22, 134),
                                ),
                                hintText: "Nombre",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Color.fromARGB(255, 219, 190, 4),
                                filled: true,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                           

                            TextFormField(
                                        //email
                                        controller: correoController,
                                        validator: (val) => val == ""
                                            ? "Por favor escribe tu correo"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.email,
                                           color: Color.fromARGB(255, 4, 22, 134),
                                          ),
                                          hintText: "Correo",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                        fillColor: Color.fromARGB(255, 219, 190, 4),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                              height: 20,
                            ),
                           
                            Obx(
                                        //password
                                        () => TextFormField(
                                          controller: contrasenaController,
                                          obscureText: isObsecure.value,
                                          validator: (val) => val == ""
                                              ? "Porfavor escribe tu contraseña"
                                              : null,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.fingerprint,
                                             color: Color.fromARGB(255, 4, 22, 134),
                                            ),
                                            suffixIcon:
                                                Obx(() => GestureDetector(
                                                      onTap: () {
                                                        isObsecure.value =
                                                            !isObsecure.value;
                                                      },
                                                      child: Icon(
                                                        isObsecure.value
                                                            ? Icons
                                                                .visibility_off
                                                            : Icons.visibility,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                            hintText: "contraseña",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Colors.white60,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Colors.white60,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Colors.white60,
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Colors.white60,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            fillColor: Color.fromARGB(255, 219, 190, 4),
                                            filled: true,
                                          ),
                                        ),
                                      ),
                                     const SizedBox(
                              height: 20,
                            ),
                            
                             TextFormField(
                                        //numero de telefono
                                        controller: telefonoController,
                                        validator: (val) => val == ""
                                            ? "Porfavor escriba su telefono"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.phone_android,
                                            color: Color.fromARGB(255, 4, 22, 134),
                                          ),
                                          hintText: "Telefono",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          fillColor: Color.fromARGB(255, 219, 190, 4),
                                          filled: true,
                                        ),
                                      ),
                                     const SizedBox(
                              height: 20,
                            ),
                           
                          TextFormField(
                                        //nombre del tutor
                                        controller: placaController,
                                        validator: (val) => val == ""
                                            ? "Porfavor escriba su placa"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.directions_car,
                                           color: Color.fromARGB(255, 4, 22, 134),
                                          ),
                                          hintText: "Placa",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                         fillColor: Color.fromARGB(255, 219, 190, 4),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                              height: 20,
                            ),

                             TextFormField(
                                        //nombre del tutor
                                        controller: capacidadController,
                                        validator: (val) => val == ""
                                            ? "Porfavor escriba la capacidad de asientos"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.event_seat,
                                            color: Color.fromARGB(255, 4, 22, 134),
                                          ),
                                          hintText: "Capacidad de asientos",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                         fillColor: Color.fromARGB(255, 219, 190, 4),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                              height: 20,
                            ),

                            TextFormField(
                                        //nombre del tutor
                                        controller: puertasController,
                                        validator: (val) => val == ""
                                            ? "Porfavor escriba el total de puertas"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.door_front_door_sharp,
                                            color: Color.fromARGB(255, 4, 22, 134),
                                          ),
                                          hintText: "Puertas",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                         fillColor: Color.fromARGB(255, 219, 190, 4),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  validateUserEmail();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                backgroundColor: Color.fromARGB(255, 3, 40,
                                    108), // Ajusta el padding vertical
                                minimumSize: Size(double.infinity,
                                    50), // Color de fondo del botón
                              ),
                              child: Text(
                                'Registrar',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.yellow,
                                ), // Ajusta el tamaño del texto
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
                                  decoration:
                                      TextDecoration.underline, // Subrayado
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              )));
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: TextField(
          obscureText: isPasswordTextField ? showPassword : false,
          decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
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
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ));
  }
}

Widget loading2({required Color fromColor, required Color toColor}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
    ),
  );
}
