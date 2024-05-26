import 'dart:async';
import 'dart:convert';


import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app_bus_tesis/componets.dart/constantes.dart';
import 'package:app_bus_tesis/vistas%20conductor/editarperfilConduc.dart';
import 'package:app_bus_tesis/vistas%20conductor/listaAlumnos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:emailjs/emailjs.dart' as EmailJS;
import 'package:url_launcher/url_launcher.dart';


class PrincipalConductor extends StatefulWidget {
  const PrincipalConductor({Key? key}) : super(key: key);

  @override
  State<PrincipalConductor> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<PrincipalConductor> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  static const LatLng otherHouseLocation =
      LatLng(37.35243475748375, -122.04816870890869);
  static const LatLng otherHouseLocation2 =
      LatLng(37.355411177345786, -122.04270772621575);
  static const LatLng otherHouseLocation4 =
      LatLng(37.35826806898714, -122.0403151730931);
  static const LatLng otherHouseLocation3 =
      LatLng(37.3300358083292, -122.03439560161372);

  List<LatLng> polylineCoordinates = [];
  List<LatLng> puntosRuta = [];
  List<LatLng> bestRouteCoordinates = [];
  LocationData? currentLocation;
  String distance = '';
  String duration = '';
  String destinationAddressText = '';
  bool destinationReached = false;
  LatLng originalLocation =
      sourceLocation; // Guarda el punto de origen original
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  
  final int numHouses = 6; // Número de casas de estudiantes
  final int populationSize = 100; // Tamaño de la población
  final int generations = 250; // Número de generaciones
  final double mutationRate = 1 / 6; // Tasa de mutación


 Uri dialnumber=Uri(scheme: 'tel', path: '123456789');

 callnumber()async{
  await launchUrl(dialnumber);
 }
 directcall()async{
  await FlutterPhoneDirectCaller.callNumber('123456789');
 }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newloc) {
        currentLocation = newloc;

        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          zoom: 13,
          target: LatLng(
            newloc.latitude!,
            newloc.longitude!,
          ),
        )));

        setState(() {});
      },
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (polylineResult.points.isNotEmpty) {
      polylineResult.points.forEach((PointLatLng points) =>
          polylineCoordinates.add(LatLng(points.latitude, points.longitude)));
      setState(() {});
    }
  }

  void setCustomMarkerIcon() async {
    double customMarkerIconSize = 100.0;

    Uint8List originIconBytes = await getBytesFromAsset(
        "assets/images/iconoescuela2.png", customMarkerIconSize.toInt());
    Uint8List destinationIconBytes = await getBytesFromAsset(
        "assets/images/casa.png", customMarkerIconSize.toInt());
    Uint8List currentLocationIconBytes = await getBytesFromAsset(
        "assets/images/busescolar.png", customMarkerIconSize.toInt());

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

  void notifyDelivery() async {
    // Define los detalles de la solicitud HTTP para enviar el correo electrónico
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    String sourceAddress =
        await getAddress(sourceLocation.latitude, sourceLocation.longitude);

    final data = jsonEncode({
      'service_id':
          'service_dny0gxn', // Reemplaza con el ID de tu servicio en EmailJS
      'template_id':
          'template_frme21s', // Reemplaza con el ID de tu plantilla de correo electrónico en EmailJS
      'user_id':
          'D9wXbTz8N4wOedPUQ', // Reemplaza con tu ID de usuario de EmailJS
      'template_params': {
        // Incluye el destino en los parámetros del correo electrónico
        'destination': destinationAddressText,
        'source': sourceAddress,
      },
    });

    // Envía la solicitud HTTP
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        },
        body: data);

    // Verifica si la solicitud se realizó correctamente
    if (response.statusCode == 200) {
      // Muestra un Snackbar con un icono de palomita indicando que el correo electrónico se envió correctamente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle,
                  color: const ui.Color.fromARGB(
                      255, 255, 255, 255)), // Icono de palomita
              SizedBox(width: 8), // Espacio entre el icono y el texto
              Text('Correo electrónico enviado correctamente.'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Muestra un Snackbar rojo indicando que ocurrió un error al enviar el correo electrónico
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al enviar el correo electrónico: ${response.body}',
            style: TextStyle(
                color: const ui.Color.fromARGB(255, 255, 255, 255),
                fontWeight: ui.FontWeight.w600),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// Definir la representación de la población
  List<List<int>> initializePopulation(int populationSize, int numHouses) {
    List<List<int>> population = [];
    for (int i = 0; i < populationSize; i++) {
      population.add(List<int>.generate(numHouses, (index) => index));
      population[i].shuffle();
    }
    return population;
  }

// Implementar la función de aptitud
  double fitness(List<int> route, List<LatLng> locations) {
    double distance = 0;
    for (int i = 0; i < route.length - 1; i++) {
      LatLng location1 = locations[route[i]];
      LatLng location2 = locations[route[i + 1]];
      distance += calculateDistance(location1, location2);
    }
    return distance;
  }

// Calcular la distancia entre dos ubicaciones
  double calculateDistance(LatLng location1, LatLng location2) {
    // Aquí puedes usar la fórmula de la distancia entre dos puntos en un plano (p. ej., la distancia euclidiana)
    // asumiremos que estamos trabajando con coordenadas en un plano y que la distancia es la línea recta entre los puntos
    return sqrt(pow(location2.latitude - location1.latitude, 2) +
        pow(location2.longitude - location1.longitude, 2));
  }

// Implementar operadores genéticos
  List<List<int>> crossover(List<int> parent1, List<int> parent2) {
    int crossoverPoint = Random().nextInt(parent1.length - 1) + 1;
    List<int> child1 = parent1.sublist(0, crossoverPoint);
    List<int> child2 = parent2.where((gene) => !child1.contains(gene)).toList();
    return [child1 + child2];
  }

  void mutate(List<int> route) {
    if (Random().nextDouble() < mutationRate) {
      int index1 = Random().nextInt(route.length);
      int index2 = Random().nextInt(route.length);
      int temp = route[index1];
      route[index1] = route[index2];
      route[index2] = temp;
    }
  }

// Crear el algoritmo genético
  List<int> geneticAlgorithm(List<LatLng> locations) {
    List<List<int>> population =
        initializePopulation(populationSize, numHouses);
    for (int generation = 0; generation < generations; generation++) {
      population.sort(
          (a, b) => fitness(a, locations).compareTo(fitness(b, locations)));
      List<List<int>> newPopulation = [];
      for (int i = 0; i < populationSize / 2; i++) {
        List<int> parent1 = population[Random().nextInt(populationSize ~/ 2)];
        List<int> parent2 = population[Random().nextInt(populationSize ~/ 2)];
        List<List<int>> children = crossover(parent1, parent2);
        mutate(children[0]);
        newPopulation.addAll(children);
      }
      population = newPopulation;
    }
    return population[0];
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolyPoints();

    super.initState();
    List<int> bestRoute = geneticAlgorithm([
      sourceLocation,
      destination,
      otherHouseLocation,
      otherHouseLocation2,
      otherHouseLocation3,
      otherHouseLocation4
    ]);
    bestRouteCoordinates = bestRoute.map((index) {
      switch (index) {
        case 0:
          return sourceLocation;
        case 1:
          return destination;
        case 2:
          return otherHouseLocation;
        case 3:
          return otherHouseLocation2;
        case 4:
          return otherHouseLocation3;
        case 5:
          return otherHouseLocation4;

        // Añade más casos para otras ubicaciones si es necesario
        default:
          throw Exception('Índice de ubicación no válido: $index');
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ui.Color.fromARGB(255, 11, 109, 190),
          title: const Text(
            "Mapa conductor",
            style: TextStyle(
                color: ui.Color.fromARGB(255, 251, 251, 251),
                fontSize: 16,
                fontWeight: ui.FontWeight.w600),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Pedro Castillo Rosales"),
                accountEmail: Text("Pedro1234@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                      child:
                          Image.asset('assets/images/conductorprofile.jpeg')),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Historial de viajes'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.help_center),
                title: Text('Ayuda'),
                onTap: () {
                  // Implementa la acción deseada.
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar sesión'),
                onTap: () {
                  // Implementa la acción deseada.
                },
              ),
            ],
          ),
        ),
        body: Stack(children: [
          currentLocation == null
              ? const Center(child: Text("Cargando"))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                    zoom: 13.5,
                  ),
                  polylines: {
                    Polyline(
                      polylineId: PolylineId("route"),
                      points: bestRouteCoordinates,
                      color: ui.Color.fromARGB(255, 137, 156, 254),
                      width: 6,
                    ),
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId("currentlocation"),
                      position: LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      ),
                      icon: currentLocationIcon,
                      infoWindow: InfoWindow(
                        title: "Ubicacion actual",
                        snippet: "Your current location",
                        onTap: () {
                          // Acción al hacer clic en el marcador
                        },
                      ),
                    ),
                    Marker(
                      markerId: MarkerId("origen"),
                      icon: sourceIcon,
                      position: sourceLocation,
                    ),
                    Marker(
                      markerId: MarkerId("destino"),
                      icon: destinationIcon,
                      position: destination,
                    ),
                    Marker(
                      markerId: MarkerId("otra_casa"),
                      icon: destinationIcon,
                      position: otherHouseLocation,
                      infoWindow: InfoWindow(
                        title: "Otra casa",
                        snippet: "Dirección de la otra casa",
                        onTap: () {
                          // Acción al hacer clic en el marcador de la otra casa
                        },
                      ),
                    ),
                    Marker(
                      markerId: MarkerId("otra_casa"),
                      icon: destinationIcon,
                      position: otherHouseLocation2,
                      infoWindow: InfoWindow(
                        title: "Otra casa",
                        snippet: "Dirección de la otra casa",
                        onTap: () {
                          // Acción al hacer clic en el marcador de la otra casa
                        },
                      ),
                    ),
                    Marker(
                      markerId: MarkerId("otra_casa"),
                      icon: destinationIcon,
                      position: otherHouseLocation4,
                      infoWindow: InfoWindow(
                        title: "Otra casa",
                        snippet: "Dirección de la otra casa",
                        onTap: () {
                          // Acción al hacer clic en el marcador de la otra casa
                        },
                      ),
                    ),
                    Marker(
                      markerId: MarkerId("otra_casa"),
                      icon: destinationIcon,
                      position: otherHouseLocation3,
                      infoWindow: InfoWindow(
                        title: "Otra casa",
                        snippet: "Dirección de la otra casa",
                        onTap: () {
                          // Acción al hacer clic en el marcador de la otra casa
                        },
                      ),
                    )
                  },
                  onCameraMove: (position) {
                    updateDistanceAndDuration(position.target);
                  },
                  onMapCreated: (mapcontroller) {
                    _controller.complete(mapcontroller);
                  },
                ),
        Stack(
  children: [
    Positioned(
      top: 16.0,
      right: 16.0,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.red, 
          minimumSize: Size(12,42),
        ),
        child: Icon(Icons.emergency),
      ),
    ),
    Positioned(
      bottom: 470.0,
      right: 16.0,
      child: ElevatedButton(
        onPressed: () {
           Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListaAumnosDesdeAPI()));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: const ui.Color.fromARGB(255, 0, 0, 0), backgroundColor: ui.Color.fromARGB(255, 240, 188, 31),
          minimumSize: Size(3,42),
        ),
        child: Icon(Icons.contacts),
      ),
    ),
  ],
),


          Positioned(
            top: 20.0,
            right: 99,
            left: 99,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 2),
                          blurRadius: 6.0)
                    ]),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_car),
                          SizedBox(
                              width: 5), // Espacio entre el icono y el texto
                          Text(
                            "Distancia: $distance",
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer),
                          SizedBox(
                              width: 5), // Espacio entre el icono y el texto
                          Text(
                            "Duración: $duration",
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 13.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
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
                  Row(
                    children: [
                      Icon(
                        Icons.location_on, // Icono de destino
                        color: ui.Color.fromARGB(255, 250, 128,
                            7), // Color del icono, puedes cambiarlo según tus preferencias
                      ),
                      Text(
                        "Punto destino",
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: ui.Color.fromARGB(255, 147, 146, 146)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5), // Espacio entre el título y la dirección
                  Text(
                    "$destinationAddressText",
                    style:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                  ),

                  Divider(), // Divider para separar la dirección de los demás elementos
                  Row(
                    children: [
                      Text(
                        "En ruta a casa del estudiante: ",
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: ui.Color.fromARGB(255, 147, 146, 146)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage("assets/images/profile2.png"),
                            )),
                      ),
                      const SizedBox(width: 10.0),
                      Text("Erika Martinez"),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                         callnumber();
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[200]),
                          child: const Icon(Icons.phone, color: Colors.green),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),

                  ElevatedButton(
                    onPressed: () {
                      notifyDelivery();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size(double.infinity,
                          0), // Asegura que el botón se expanda completamente en todo lo ancho
                    ),
                    child: Text(
                      'Notificar entrega',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Acción al hacer clic en el botón "Iniciar trayecto"
                      // Implementa la lógica según sea necesario
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Color de fondo del botón
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0), // Espaciado interno
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Bordes redondeados
                      ),
                      minimumSize: Size(150, 0), // Tamaño mínimo del botón
                    ),
                    child: Text(
                      'Iniciar trayecto',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}

/* class AlgoritmoGenetico {
  static List<int> obtenerMejorRuta(List<List<double>> coordenadasCasas,
      int generaciones, int tamanoPoblacion) {
    List<List<int>> poblacion =
        generarPoblacionInicial(coordenadasCasas.length, tamanoPoblacion);
    List<int> mejorRuta = [];
    double mejorDistancia = double.infinity;

    for (int i = 0; i < generaciones; i++) {
      for (int j = 0; j < poblacion.length; j++) {
        double distancia =
            calcularDistanciaTotal(coordenadasCasas, poblacion[j]);
        if (distancia < mejorDistancia) {
          mejorDistancia = distancia;
          mejorRuta = List.from(poblacion[j]);
        }
      }

      poblacion = reproducir(poblacion);
    }

    return mejorRuta;
  }

  static List<List<int>> generarPoblacionInicial(int n, int tamanoPoblacion) {
    List<List<int>> poblacion = [];

    for (int i = 0; i < tamanoPoblacion; i++) {
      List<int> ruta = List.generate(n, (index) => index);
      ruta.shuffle();
      poblacion.add(ruta);
    }

    return poblacion;
  }

  static double calcularDistanciaTotal(
      List<List<double>> coordenadasCasas, List<int> ruta) {
    double distanciaTotal = 0.0;

    for (int i = 0; i < ruta.length - 1; i++) {
      int casaActual = ruta[i];
      int siguienteCasa = ruta[i + 1];

      double distanciaEntreCasas = distanciaEntreDosPuntos(
          coordenadasCasas[casaActual][0],
          coordenadasCasas[casaActual][1],
          coordenadasCasas[siguienteCasa][0],
          coordenadasCasas[siguienteCasa][1]);

      distanciaTotal += distanciaEntreCasas;
    }

    return distanciaTotal;
  }

  static double distanciaEntreDosPuntos(
      double lat1, double lon1, double lat2, double lon2) {
    const int radioTierra = 6371;
    double dLat = _gradosARadianes(lat2 - lat1);
    double dLon = _gradosARadianes(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_gradosARadianes(lat1)) *
            cos(_gradosARadianes(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distancia = radioTierra * c;
    return distancia;
  }

  static double _gradosARadianes(double grados) {
    return grados * pi / 180;
  }

  static List<List<int>> reproducir(List<List<int>> poblacion) {
    List<List<int>> nuevaPoblacion = [];

    for (int i = 0; i < poblacion.length; i += 2) {
      List<int> padre1 = poblacion[i];
      List<int> padre2 = poblacion[(i + 1) % poblacion.length];
      List<int> hijo1 = List.from(padre1);
      List<int> hijo2 = List.from(padre2);

      // Implementación del cruce (PMX)
      int puntoCorte1 = Random().nextInt(padre1.length);
      int puntoCorte2 = Random().nextInt(padre1.length);

      if (puntoCorte1 > puntoCorte2) {
        int temp = puntoCorte1;
        puntoCorte1 = puntoCorte2;
        puntoCorte2 = temp;
      }

      for (int j = puntoCorte1; j <= puntoCorte2; j++) {
        int valorHijo1 = hijo1[j];
        int valorHijo2 = hijo2[j];
        hijo1[j] = valorHijo2;
        hijo2[j] = valorHijo1;
      }

      // Implementación de la mutación (intercambio de dos elementos)
      if (Random().nextDouble() < 0.05) {
        // Probabilidad de mutación del 5%
        int index1 = Random().nextInt(hijo1.length);
        int index2 = Random().nextInt(hijo1.length);
        int temp = hijo1[index1];
        hijo1[index1] = hijo1[index2];
        hijo1[index2] = temp;
      }

      if (Random().nextDouble() < 0.05) {
        // Probabilidad de mutación del 5%
        int index1 = Random().nextInt(hijo2.length);
        int index2 = Random().nextInt(hijo2.length);
        int temp = hijo2[index1];
        hijo2[index1] = hijo2[index2];
        hijo2[index2] = temp;
      }

      nuevaPoblacion.add(hijo1);
      nuevaPoblacion.add(hijo2);
    }

    return nuevaPoblacion;
  } */

