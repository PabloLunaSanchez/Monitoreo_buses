import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_bus_tesis/Modelos/user.dart';
import 'package:app_bus_tesis/api_conexion/api_conexion.dart';
import 'package:app_bus_tesis/componets.dart/page_title_bar.dart';
import 'package:app_bus_tesis/componets.dart/upside.dart';
import 'package:app_bus_tesis/vistas%20conductor/Login.dart';
import 'package:app_bus_tesis/vistas%20cliente/homepage.dart';
import 'package:app_bus_tesis/widgets/rounded_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registro extends StatefulWidget {
  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var tutorNameController = TextEditingController();
  var tutorLastNameController = TextEditingController();
  var childNameController = TextEditingController();
  var childLastNameController = TextEditingController();
  var numbercontroller = TextEditingController();
  var isObsecure = true.obs;

  File? _file;
  String status = '';
  late String base64image;
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


  
  validateUserEmail() async {
    try {
      var res = await http.post(Uri.parse(API.validateEmailUser),
          body: {'correo': emailController.text.trim()});

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
    if (_file == null) {
      Fluttertoast.showToast(msg: "Por favor, selecciona una imagen");
      return;
    }

    // Convierte la imagen a una cadena base64
    List<int> imageBytes = await _file!.readAsBytes();
    String base64Image = base64Encode(imageBytes); // Aquí se obtiene la cadena base64

    User userModel = User(
      1,
      emailController.text.trim(),
      passwordController.text.trim(),
      tutorNameController.text.trim(),
      tutorLastNameController.text.trim(),
      childNameController.text.trim(),
      childLastNameController.text.trim(),
      numbercontroller.text.trim(),
      base64Image, // Se asigna la cadena base64 al modelo de usuario
    );

    try {
      var res = await http.post(Uri.parse(API.signUpUser), body: userModel.toJson());

      if (res.statusCode == 200) {
        var resBodyOfSignup = jsonDecode(res.body);
        if (resBodyOfSignup['success'] == true) {
          Fluttertoast.showToast(msg: "¡Felicidades! Tu cuenta ha sido creada");
        } else {
          Fluttertoast.showToast(msg: "Ocurrió un error al registrarse");
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/images/register.png",
                ),
                const PageTitleBar(
                  title: 'Crea una nueva cuenta',
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 320.0),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 81, 136, 184),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
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
                           /////// imagen
                            Form(
                                key: formkey,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 30, 30, 8),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        //email
                                        controller: emailController,
                                        validator: (val) => val == ""
                                            ? "Por favor escribe tu correo"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Colors.black,
                                          ),
                                          errorStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 189, 13, 0),
                                          ),
                                          hintText: "email",
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
                                          fillColor:  Color.fromARGB(255, 223, 197, 51),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Obx(
                                        //password
                                        () => TextFormField(
                                          controller: passwordController,
                                          obscureText: isObsecure.value,
                                          validator: (val) => val == ""
                                              ? "Porfavor escribe tu contraseña"
                                              : null,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.vpn_key_sharp,
                                              color: Colors.black,
                                            ),
                                            errorStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 13, 0),
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
                                            fillColor: Color.fromARGB(
                                                255, 223, 197, 51),
                                            filled: true,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: numbercontroller,
                                        validator: (val) => val == ""
                                            ? "Por favor escriba su número de teléfono"
                                            : null,
                                        keyboardType: TextInputType
                                            .phone, 
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly 
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                          ),
                                          errorStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 189, 13, 0),
                                          ),
                                          hintText: "telefono",
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
                                          fillColor:  Color.fromARGB(255, 223, 197, 51),
                                          filled: true,
                                        ),
                                      ),
                                     
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      TextFormField(
                                        //nombre del tutor
                                        controller: tutorNameController,
                                        validator: (val) => val == ""
                                            ? "Porfavor escriba el nombre del tutor"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          ),
                                          errorStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 189, 13, 0),
                                          ),
                                          hintText: "nombre del tutor",
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
                                          fillColor:  Color.fromARGB(255, 223, 197, 51),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      TextFormField(
                                        //apellido del tutor
                                        controller: tutorLastNameController,
                                        validator: (val) => val == ""
                                            ? "Porfavor escriba el apellido del tutor"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.person_pin_rounded,
                                            color: Colors.black,
                                          ),
                                          errorStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 189, 13, 0),
                                          ),
                                          hintText: "Apellido del tutor",
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
                                          fillColor:
                                              Color.fromARGB(255, 223, 197, 51),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      TextFormField(
                                        //Nombre del hijo
                                        controller: childNameController,
                                        validator: (val) => val == ""
                                            ? "Porfavor escriba el nombre del hijo"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.boy_outlined,
                                            color: Colors.black,
                                          ),
                                          errorStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 189, 13, 0),
                                          ),
                                          hintText: "Nombre del hijo",
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
                                          fillColor:
                                              Color.fromARGB(255, 223, 197, 51),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      TextFormField(
                                        controller: childLastNameController,
                                        validator: (val) => val == ""
                                            ? "Por favor escriba el apellido del hijo"
                                            : null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.boy_rounded,
                                            color: Colors.black,
                                          ),
                                          errorStyle: TextStyle(
                                            color:
                                                Color.fromARGB(255, 189, 13, 0),
                                          ),
                                          hintText: "Apellido del hijo",
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
                                          fillColor:
                                              Color.fromARGB(255, 223, 197, 51),
                                          filled: true,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Material(
                                        //boton login
                                        color: Color.fromARGB(255, 15, 67, 172),
                                        borderRadius: BorderRadius.circular(30),
                                        child: InkWell(
                                          onTap: () {
                                            if (formkey.currentState!
                                                .validate()) {
                                              validateUserEmail();
                                            }
                                          },
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "ya tienes una cuenta?",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.to(InicioSesion());
                                        },
                                        child: const Text(
                                          "Inicia sesion aqui",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 200,
                                      )
                                    ],
                                  ),
                                )),
                          ]),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MapaPage()));
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
                buildTextField("Correo", "andrea125@gmail.com", false),
                buildTextField("Contraseña", "******", true),
                buildTextField("Nombre del tutor", "Andrea", false),
                buildTextField("Apellido del tutor", "Perez Castillo", false),
                buildTextField("Nombre del hij@", "Andrea", false),
                buildTextField("Apellido del hij@", "Andrea", false),
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
                        onPressed: () {},
                        child: Text('Guardar'),
                      ),
                    ])
              ],
            )),
      ),
    );
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