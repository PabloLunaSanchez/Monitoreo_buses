import 'dart:convert';
import 'package:app_bus_tesis/api_conexion/api_conexion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ListaAumnosDesdeAPI extends StatefulWidget {
  @override
  _ListaAumnosDesdeAPIState createState() => _ListaAumnosDesdeAPIState();
}

class _ListaAumnosDesdeAPIState extends State<ListaAumnosDesdeAPI> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
 
    final response = await http.get(Uri.parse(API.listaAlumnos));

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
        // Agregar una propiedad 'seleccionado' a cada elemento de _data
        _data.forEach((element) {
          element['seleccionado'] = false; // Inicialmente ninguno seleccionado
        });
      });
    } else {
      throw Exception('Fallo al cargar los datos desde el servidor');
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumnos en el bus'),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset("assets/images/graduacion.png", scale: 12),
            title: Text(_data[index]['nombre_hijo']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_data[index]['apellido_hijo']),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16.0, color: const Color.fromARGB(255, 11, 133, 234)),
                    SizedBox(width: 4.0),
                    Text(_data[index]['telefono']),
                  ],
                ),
              ],
            ),
            trailing: Checkbox(
              activeColor: Colors.green[800],
              value: _data[index]['seleccionado'],
              onChanged: (newValue) {
                setState(() {
                  _data[index]['seleccionado'] = newValue;
                });
              },
            ),
          );
        },
      ),
    );
  }
}