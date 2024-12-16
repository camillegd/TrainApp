import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  // Contrôleur de carte
  final MapController _mapController = MapController();

  // Liste des marqueurs
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    markers = [
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(48.8566, 2.3522), // Coordonnées de Paris
        child: IconButton(
          icon: Icon(Icons.location_pin, color: Colors.red, size: 40),
          onPressed: () {
            _showSnackBar('Paris');
          },
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(48.8742, 2.3470), // Tour Eiffel
        child: IconButton(
          icon: Icon(Icons.location_on, color: Colors.blue, size: 40),
          onPressed: () {
            _showSnackBar('Tour Eiffel');
          },
        ),
      ),
    ];
  }

  // Méthode pour afficher un SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
    );
  }

  // Obtenir la localisation actuelle
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Vérifier si les services de localisation sont activés
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Les services de localisation sont désactivés');
        return;
      }

      // Vérifier les permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Permissions de localisation refusées');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Permissions de localisation permanentemente refusées');
        return;
      }

      // Obtenir la position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      setState(() {
        // Créer un marqueur pour la position actuelle
        final currentLocationMarker = Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(position.latitude, position.longitude),
          child: Icon(
              Icons.my_location,
              color: Colors.green,
              size: 40
          ),
        );

        // Ajouter le marqueur s'il n'existe pas déjà
        if (!markers.any((marker) =>
        marker.point.latitude == position.latitude &&
            marker.point.longitude == position.longitude)) {
          markers.add(currentLocationMarker);
        }

        // Centrer la carte sur la position actuelle
        _mapController.move(
            LatLng(position.latitude, position.longitude),
            13.0
        );
      });
    } catch (e) {
      _showSnackBar('Impossible de récupérer la localisation : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add_location),
            onPressed: () {
              // Ajouter un nouveau marqueur dynamiquement
              setState(() {
                markers.add(
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(48.8584, 2.2945), // Exemple : La Défense
                    child: IconButton(
                      icon: Icon(Icons.location_on, color: Colors.green, size: 40),
                      onPressed: () {
                        _showSnackBar('La Défense');
                      },
                    ),
                  ),
                );
              });
            },
          )
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(48.8566, 2.3522), // Centre sur Paris
          initialZoom: 10.0,
          minZoom: 3.0,
          maxZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: markers),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap Contributors',
                prependCopyright: true,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Option 1 : Réinitialiser la vue sur Paris
          // _mapController.move(
          //     LatLng(48.8566, 2.3522),
          //     10.0
          // );

          // Option 2 : Obtenir la localisation actuelle
          _getCurrentLocation();
        },
        child: Icon(Icons.my_location),
        tooltip: 'Centrer sur ma position',
      ),
    );
  }
}