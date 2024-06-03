import 'dart:convert';

import 'package:app_bus_tesis/Modelos/user.dart';
import 'package:app_bus_tesis/api_conexion/api_conexion.dart';
import 'package:app_bus_tesis/componets.dart/page_title_bar.dart';
import 'package:app_bus_tesis/componets.dart/upside.dart';
import 'package:app_bus_tesis/userPreferences/user_preferences.dart';
import 'package:app_bus_tesis/vistas%20cliente/homepage.dart';
import 'package:app_bus_tesis/vistas%20cliente/sign_up.dart';
import 'package:app_bus_tesis/widgets/rounded_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginUsuario() async{
  
      var res = await http.post(Uri.parse(API.login),
       body: {
       "correo" : emailController.text.trim(),
       "contrasena" : passwordController.text.trim()
       },
    );
  if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {

          Fluttertoast.showToast(msg: "Ha inciado sesion correctamente");
     

         User userInfo = User.fromJson(resBodyOfLogin["userData"]);
         //guardar info del usuario

         await RecordarUserPref.AlmacenaminetoInfoUser(userInfo);
         
         Future.delayed(Duration(milliseconds: 2000),()
         {
          Get.to(MapaPage());
         });
        }
        else{
        Fluttertoast.showToast(msg: "Incorrecto vuelva a escribir su correo o contraseña, vuelve a intentarlo");
        }
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
                  imgUrl: "assets/images/bus azul.jpg",
                ),
                const PageTitleBar(title: 'Inicia sesion con tu cuenta'),
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
                              height: 15,
                            ),
                            iconButton(context),
                           
                           
                           
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
                                            color: Color.fromARGB(255, 189, 13, 0),
                                          ),
                                          hintText: "correo",
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
                                              Color.fromARGB(255, 223, 197, 51).withAlpha(500),
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
                                            color: Color.fromARGB(255, 189, 13, 0),
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
                                            fillColor:   Color.fromARGB(255, 223, 197, 51).withAlpha(500),
                                            filled: true,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Material(
                                        //boton login
                                        color: Color.fromARGB(255, 15, 67, 172),
                                        borderRadius: BorderRadius.circular(30),
                                        child: InkWell(
                                          onTap: () {
                                            if (formkey.currentState!
                                                .validate()){
                                                  loginUsuario();
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
                                              "Iniciar sesion",
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
                                            "¿No tienes una cuenta?",
                                            style:
                                                TextStyle(color: Color.fromARGB(255, 238, 238, 238)),
                                          )
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.to(SignUpScreen());
                                        },
                                        child: const Text("Registrate aqui",
                                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.w700),
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

iconButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      RoundedIcon(imageUrl: "assets/images/graduacion.png",),
      SizedBox(
        width: 20,
      ),
      
    ],
  );
}
