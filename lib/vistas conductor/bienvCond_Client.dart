import 'dart:ui';

import 'package:app_bus_tesis/vistas%20conductor/Login.dart';
import 'package:app_bus_tesis/vistas%20conductor/Login_conductor.dart';
import 'package:flutter/material.dart';


class Conductor_ClientePage extends StatefulWidget {
  const Conductor_ClientePage();

  @override
  _ConductorPageState createState() => _ConductorPageState();
}

class _ConductorPageState extends State<Conductor_ClientePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bus flutter.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'MiBus',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: const Color.fromARGB(255, 255, 254, 254)
                              .withOpacity(0.5),
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * .16),
                  _loginButton(context),
                  SizedBox(height: 25),
                  _signUpButton(context),
                  SizedBox(height: 24),
                  CustomDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginConductor(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 14.5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xffdf8e33).withAlpha(100),
              offset: Offset(2, 4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
          color: Color.fromARGB(255, 248, 204, 6),
        ),
        child: Text(
          'Iniciar sesion conductor',
          style: TextStyle(
              fontSize: 20, color: Color.fromARGB(255, 0, 0, 0), fontWeight:FontWeight.w600),
        ),
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xffdf8e33).withAlpha(100),
              offset: Offset(2, 4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
          color: Color.fromARGB(255, 73, 127, 193),
        ),
        child: Text(
          'Iniciar sesion padre de familia',
          style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final divider = Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          color: Colors.white,
          thickness: 1,
        ),
      ),
    );
    return Row(children: [
      divider,
      Text(
        "ou",
        style: TextStyle(color: Colors.white),
      ),
      divider
    ]);
  }
}

class Logo extends StatelessWidget {
  final double fontSize;
  final bool backgroundColorIsOrange;

  const Logo({
    required this.fontSize,
    required this.backgroundColorIsOrange,
  });

  @override
  Widget build(BuildContext context) {
    // Implement your logo widget here
    return Container();
  }
}

class YourLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your login page widget here
    return Container();
  }
}

class YourSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your sign-up page widget here
    return Container();
  }
}

final LinearGradient mainLinearGradient = LinearGradient(
  colors: [
    Color.fromARGB(255, 8, 0, 119),
    Color.fromARGB(255, 222, 208, 4)
  ], // Modify these colors accordingly
);

final Color mainLightLessColor = Colors.black; // Modify as needed