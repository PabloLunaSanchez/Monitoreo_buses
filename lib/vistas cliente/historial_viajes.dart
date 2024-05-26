// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistorialViajes extends StatelessWidget {
  final String origen;
  final String destino;
  final String horaLlegada;

  HistorialViajes({
    required this.origen,
    required this.destino,
    required this.horaLlegada,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 8, 68, 118),
          title: Text("Historial de viajes"),
        ),
        body: ListView(children: [
          SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
                  child: Text(
                    "Historial de viajes",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 9),
                  child: Container(
                    width: 380,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 245, 246, 211),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 3))
                        ]),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset("assets/images/bus2.jpg"),
                          height: 80,
                          width: 150,
                        ),
                        Container(
                          width: 190,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                origen,
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                destino,
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                horaLlegada,
                                style:
                                    TextStyle(fontSize: 11, color: Colors.blue
                                        // fontWeight: FontWeight.bold
                                        ),
                              )
                            ],
                          ),
                        ),
                        //         Padding(
                        //           padding: EdgeInsets.symmetric(
                        //               vertical: 8, horizontal: 2),
                        //           child: Container(
                        //             padding: EdgeInsets.all(5),
                        //             decoration: BoxDecoration(
                        //               color: Color.fromARGB(255, 83, 159, 235),
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Icon(
                        //                   Icons.minimize,
                        //                   color: Colors.white,
                        //                 ),
                        //                 Icon(Icons.history),
                        //                 Icon(
                        //                   Icons.minimize,
                        //                   color: Colors.white,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 9),
                        //   child: Container(
                        //     width: 380,
                        //     height: 100,
                        //     decoration: BoxDecoration(
                        //         color: Color.fromARGB(255, 245, 246, 211),
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               color: Colors.grey.withOpacity(0.5),
                        //               spreadRadius: 3,
                        //               blurRadius: 10,
                        //               offset: Offset(0, 3))
                        //         ]),
                        //     child: Row(
                        //       children: [
                        //         Container(
                        //           alignment: Alignment.center,
                        //           child: Image.asset("assets/images/bus2.jpg"),
                        //           height: 80,
                        //           width: 150,
                        //         ),
                        //         Container(
                        //           width: 190,
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //             children: [
                        //               Text(
                        //                 "origen",
                        //                 style: TextStyle(
                        //                     fontSize: 20,
                        //                     fontWeight: FontWeight.bold),
                        //               ),
                        //               Text(
                        //                 "destino",
                        //                 style: TextStyle(
                        //                     fontSize: 20,
                        //                     fontWeight: FontWeight.bold),
                        //               ),
                        //               Text(
                        //                 "hora de llegada",
                        //                 style:
                        //                     TextStyle(fontSize: 14, color: Colors.blue
                        //                         // fontWeight: FontWeight.bold
                        //                         ),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: EdgeInsets.symmetric(
                        //               vertical: 8, horizontal: 2),
                        //           child: Container(
                        //             padding: EdgeInsets.all(5),
                        //             decoration: BoxDecoration(
                        //               color: Color.fromARGB(255, 83, 159, 235),
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Icon(
                        //                   Icons.minimize,
                        //                   color: Colors.white,
                        //                 ),
                        //                 Icon(Icons.history),
                        //                 Icon(
                        //                   Icons.minimize,
                        //                   color: Colors.white,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))
        ]));
  }
}
