// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:app_bus_tesis/componets.dart/constantes.dart';
import 'package:app_bus_tesis/userPreferences/currentUser.dart';
import 'package:app_bus_tesis/userPreferences/user_preferences.dart';
import 'package:app_bus_tesis/vistas%20cliente/editarPerfilCliente.dart';
import 'package:app_bus_tesis/vistas%20conductor/bienvCond_Client.dart';
import 'package:app_bus_tesis/vistas%20conductor/editarperfilConduc.dart';
import 'package:app_bus_tesis/vistas%20conductor/historial_viajes.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';


class MapaPage extends StatefulWidget {
 
  const MapaPage({Key? key}) : super(key: key);
  
  @override
  State<MapaPage> createState() => MapaPageState();
}

class MapaPageState extends State<MapaPage> {
   CurrentUser _recordarCurrentUser = Get.put(CurrentUser());
    CurrentUser _currentUser = Get.put(CurrentUser());

   
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  String distanceText = ""; // Variable para almacenar la distancia
  String durationText = "";

  String sourceAddress = ""; // Variable para almacenar la dirección del origen
  String destinationAddress =
      ""; // Variable para almacenar la dirección del destino
  String arrivalMessage = "";
    String distance = '';
  String duration = '';
   String destinationAddressText = '';

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  
  
   

  void setCustomMarkerIcon() async {
    double customMarkerIconSize = 100.0;

    Uint8List originIconBytes = await getBytesFromAsset(
        "assets/images/iconoescuela2.png", customMarkerIconSize.toInt());
    Uint8List destinationIconBytes = await getBytesFromAsset(
        "assets/images/casa.png", customMarkerIconSize.toInt());
    Uint8List currentLocationIconBytes = await getBytesFromAsset(
        "assets/images/graduates.png", customMarkerIconSize.toInt());

    sourceIcon = BitmapDescriptor.fromBytes(originIconBytes);
    destinationIcon = BitmapDescriptor.fromBytes(destinationIconBytes);
    currentLocationIcon = BitmapDescriptor.fromBytes(currentLocationIconBytes);
  }

  Future<Uint8List> getBytesFromAsset(String path, int size) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: size);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const double radius = 6371; // Radio de la Tierra en kilómetros
    double dLat = degreesToRadians(endLat - startLat);
    double dLng = degreesToRadians(endLng - startLng);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(startLat)) *
            cos(degreesToRadians(endLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = radius * c * 1000; // Convertir a metros
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newloc) {
      currentLocation = newloc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 13.0,
              target: LatLng(newloc.latitude!, newloc.longitude!))));
      setState(() {});

      // Verificar si la ubicación actual está cerca del destino
      double distance = calculateDistance(newloc.latitude!, newloc.longitude!,
          destination.latitude, destination.longitude);

      // Definir una distancia de llegada (ajústala según sea necesario)
      double arrivalDistance = 50; // en metros

      if (distance <= arrivalDistance) {
        // Llegada al destino
        showArrivalMessage();
      }
    });
  }


  void updateDistanceAndDuration(LatLng newCameraPosition) async {
    String apiUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?'
        'origins=${newCameraPosition.latitude},${newCameraPosition.longitude}&'
        'destinations=${destination.latitude},${destination.longitude}&'
        'key=$google_api_key';

    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        distance = data['rows'][0]['elements'][0]['distance']['text'];
        duration = data['rows'][0]['elements'][0]['duration']['text'];
      });
      // Obtener la dirección del destino
      String destinationAddress =
          await getAddress(destination.latitude, destination.longitude);
      setState(() {
        destinationAddressText = destinationAddress;
      });
    }
  }

  Future<String> getAddress(double lat, double lng) async {
    String apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=$lat,$lng&key=$google_api_key';

    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['results'][0]['formatted_address'];
    } else {
      return '';
    }
  }


  void showArrivalMessage() {
    // Obtener la hora de llegada
    DateTime arrivalTime = DateTime.now();

    // Formatear la fecha y la hora con el formato de 12 horas
    String formattedArrivalTime =
        DateFormat('h:mm a yyyy-MM-dd').format(arrivalTime);

    // Actualizar el estado para reflejar la hora de llegada en un widget de texto
    setState(() {
      arrivalMessage =
          "¡Su hijo llegó a su destino! a las $formattedArrivalTime";
    });
    // Mostrar una notificación personalizada
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '¡Llegada al Destino!',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '¡Su hijo ha llegado a su destino!',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Hora de llegada:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedArrivalTime,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                'Aceptar',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
            google_api_key,
            PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
            PointLatLng(destination.latitude, destination.longitude));

    if (polylineResult.points.isNotEmpty) {
      polylineResult.points.forEach((PointLatLng points) =>
          polylineCoordinates.add(LatLng(points.latitude, points.longitude)));
      setState(() {});
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPolyPoints();
    getCurrentLocation();
    setCustomMarkerIcon();
    
    getRouteInfo();
    getAddressFromLatLng(sourceLocation).then((value) {
      setState(() {
        sourceAddress = value;
      });
    });

    getAddressFromLatLng(destination).then((value) {
      setState(() {
        destinationAddress = value;
      });
    });
  }

  Future<void> getRouteInfo() async {
    String apiKey = google_api_key; // Reemplaza con tu propia API Key de Google Maps

    String apiUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${sourceLocation.latitude},${sourceLocation.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey";

    http.Response response = await http.get(Uri.parse(apiUrl));
    // Variable para almacenar la duración

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> routes = data["routes"];

      if (routes.isNotEmpty) {
        List<dynamic> legs = routes[0]["legs"];
        if (legs.isNotEmpty) {
          Map<String, dynamic> leg = legs[0];
          distanceText = leg["distance"]["text"];
          durationText = leg["duration"]["text"];
        }
      }
    } else {
      print("Error al obtener la ruta: ${response.statusCode}");
    }
  }

  // Función para obtener la dirección a partir de la latitud y longitud
  Future<String> getAddressFromLatLng(LatLng location) async {
    String apiKey = google_api_key;
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data['results'][0]['formatted_address'];
      }
    }

    return "Dirección no disponible";
  }

  cerrarSesion()async{
    var resultResponse = await Get.dialog(
   AlertDialog(
    backgroundColor: const ui.Color.fromARGB(255, 140, 194, 241),
    title: const Text(
     "Cerrar sesion",
     style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold
     ),
    ),
    content: const Text(
      "Esta seguro que desea cerrar sesion?"
    ),
    actions: [
      TextButton(onPressed: (){
        Get.back();
      }, child: const Text("No",
      style: TextStyle(
        color: Colors.black
      ),
      )),
      TextButton(onPressed: (){
        Get.back(result: "Sesion cerrada");
      }, child: const Text("Si",
      style: TextStyle(
        color: Colors.black
      ),
      ))
    ],
    ));

   if(resultResponse == "Sesion cerrada"){
    RecordarUserPref.removerUserInfo().then((value){
      Get.off(Conductor_ClientePage());
    });
   }
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState){
        _recordarCurrentUser.obtenerInfoUser();
      },
      builder: (controller) {
      return Scaffold(
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 11, 9, 103),
          centerTitle: true,
          title: Text(
            "Mapa bus escolar",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(
              color: Colors
                  .white), // Cambia "Colors.white" al color que desees para las tres líneas del ícono del drawer
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
          UserAccountsDrawerHeader(
                 accountName: Text('${_currentUser.user.nombre_tutor} ${_currentUser.user.apellido_tutor}'), 
                accountEmail: Text(_currentUser.user.correo),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                      child: Image.asset('assets/images/avatar-cindy-.png')),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    image: AssetImage('assets/images/fondoanavbar.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
           
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Editar perfil'),
                onTap: () {
                 Get.to(EditProfilePageCliente());
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Historial de viajes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistorialViajes(
                        origen: sourceAddress,
                        destino: destinationAddress,
                        horaLlegada: arrivalMessage,
                      ),
                    ),
                  );
                },
              ),
              
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar sesión'),
                onTap: () {
                cerrarSesion();
                },
              ),
            ],
          ),
        ),
        body: currentLocation == null
            ? Center(
                child: Text("Loading"),
              )
            : Container(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        zoom: 13.8,
                        target: LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        ),
                      ),
                      polylines: {
                        Polyline(
                          polylineId: PolylineId("route"),
                          points: polylineCoordinates,
                          color: ui.Color.fromARGB(255, 15, 148, 41),
                          width: 8
                        )
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("currentlocation"),
                          icon: currentLocationIcon,
                          position: LatLng(
                            currentLocation!.latitude!,
                            currentLocation!.longitude!,
                          ),
                        ),
                        Marker(
                          markerId: MarkerId("source"),
                           icon: sourceIcon,
                          position: sourceLocation,
                        ),
                        Marker(
                          markerId: MarkerId("destino"),
                           icon: destinationIcon,
                          position: destination,
                        )
                      },
                       onCameraMove: (position) {
                      updateDistanceAndDuration(position.target);
                    },
                      onMapCreated: (controller) {
                        _controller.complete(controller);
                      },
                    ),
                    Positioned(
              bottom: 13.0,
              left: 20.0,
              right: 20.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: ui.Color.fromARGB(255, 214, 168, 16),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          blurRadius: 7,
                          spreadRadius: 5)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Ajusta la alineación cruzada para que los elementos se expandan en todo lo ancho
                                children: [
                                  Text(
                                    "Su hija andrea esta a :",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "$duration, de llegar a su destino",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.amber.shade400,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        " Distancia:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "                 $distance",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.location_on_outlined,
                                          size: 30,
                                          color: ui.Color.fromARGB(255, 212, 74, 10),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/origen.png",
                                        width: 34,
                                        height: 34,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Container(
                                        child: Text(
                                          "$sourceAddress",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.black),
                                        ),
                                      ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/destino.png",
                                        width: 34,
                                        height: 34,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            "$destinationAddress",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                  ],
                
                ),
              ),
      
    );
  }
);}}
