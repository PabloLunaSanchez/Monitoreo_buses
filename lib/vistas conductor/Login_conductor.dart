import 'package:app_bus_tesis/vistas%20conductor/registroconductor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class LoginConductor extends StatelessWidget {
  const LoginConductor({Key? key}) : super(key: key);

  @override
  @override
Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return Scaffold(
    backgroundColor: const Color(0xfff0f1f5),
    body: SafeArea(
      child: SingleChildScrollView( // Agregar SingleChildScrollView
        child: Container(
          padding: const EdgeInsets.all(18),
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: RichText(
                  text: const TextSpan(
                    text: 'Inicio',
                    style: TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(255, 255, 184, 69),
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: ' App Conductor',
                        style: TextStyle(
                          color: Color.fromARGB(231, 0, 46, 131),
                        )
                      )
                    ]
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                height: size.height * .3,
                child: Image.asset('assets/images/driver.png'),
              ),
              Container(
                height: size.height * .4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.2),
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    )
                  ]
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned(
                      top: 10,
                      left: 20,
                      child: Text(
                        'Inicia sesion',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.mail_outline,
                                color: Colors.grey,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                width: 300,
                                child: const TextField(
                                  cursorColor: Colors.grey,
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'example@gmail.com',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: size.width * .8,
                            child: const Divider(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ),
                    Positioned(
                      top: 120,
                      left: 20,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.fingerprint,
                                color: Colors.grey,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                width: 300,
                                child: const TextField(
                                  obscureText: true,
                                  cursorColor: Colors.grey,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                    letterSpacing: 1.4,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '...........',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: size.width * .8,
                            child: const Divider(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ),
                    Positioned(
  top: 150,
  bottom: 2,
  left: 18,
  child: SizedBox(
    width: size.width * .8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: 'Crea una cuenta',
            style: TextStyle(
              color: Color.fromARGB(196, 5, 88, 255),
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
          
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registroconductor1()),
                );
              },
          ),
        ),
        RichText(
          text: TextSpan(
            text: '¿Olvido su contraseña?',
            style: TextStyle(
              color: Color.fromARGB(253, 117, 119, 123),
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
          
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registroconductor1()),
                );
              },
          ),
        ),
      ],
    ),
  ),
),
                    GestureDetector(
  onTap: () {
    // Acciones que deseas realizar cuando se presiona el botón de la flecha
   
    // Puedes agregar aquí cualquier acción que desees realizar al presionar el botón de flecha
  },
  child: Stack(
    children: [
      Positioned(
        bottom: -10,
        right: 10,
        child: Container(
          padding: const EdgeInsets.all(22),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 34, 114),
                Color.fromARGB(255, 60, 94, 147),
              ],
              stops: [
                0.0,
                1.0
              ],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight
            ),
            shape: BoxShape.circle,
          ),
          
          child: Image.asset('assets/images/right-arrow.png'),
        ),
      ),
    ],
  ),
),
            ],
          ),
        ),
      ]),
    ),
  )));
}
}