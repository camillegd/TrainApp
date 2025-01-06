import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projet_gares/blocs/train_station_cubit.dart';
import 'package:projet_gares/models/train_station.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final MapController _mapController = MapController();
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _fetchTrainStations();
  }

  void _fetchTrainStations() async {
    final trainStationCubit = context.read<TrainStationCubit>();
    await trainStationCubit.getAllTrainStations();
    final trainStations = trainStationCubit.state;
    _addMarkers(trainStations);
  }

  void _addMarkers(List<TrainStation> trainStations) {
    setState(() {
      markers = trainStations.map((station) {
        return Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(station.location.latitude, station.location.longitude),
          child: IconButton(
            icon: const Icon(Icons.location_on, color: Color(0xFF083D77), size: 40),
            onPressed: () {
              _showSnackBar('${station.name} (${station.stationId})', station);
            },
          ),
        );
      }).toList();
    });
  }

  void _showSnackBar(String message, TrainStation station) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Details',
          onPressed: () {
            Navigator.pushNamed(context, '/train_station', arguments: station);
          },
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Les services de localisation sont désactivés', const TrainStation('', '', '', LatLng(0, 0)));
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Permissions de localisation refusées', const TrainStation('', '', '', LatLng(0, 0)));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Permissions de localisation permanentemente refusées', const TrainStation('', '', '', LatLng(0, 0)));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        final currentLocationMarker = Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(position.latitude, position.longitude),
          child: const Icon(Icons.my_location, color: Colors.green, size: 40),
        );

        if (!markers.any((marker) =>
        marker.point.latitude == position.latitude &&
            marker.point.longitude == position.longitude)) {
          markers.add(currentLocationMarker);
        }

        _mapController.move(
          LatLng(position.latitude, position.longitude),
          13.0,
        );
      });
    } catch (e) {
      _showSnackBar('Impossible de récupérer la localisation : $e', const TrainStation('', '', '', LatLng(0, 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(48.8566, 2.3522),
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
          const RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap Contributors',
                prependCopyright: true,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: 'center_position',
              onPressed: _getCurrentLocation,
              tooltip: 'Centrer sur ma position',
              child: const Icon(Icons.my_location),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: 'favorites',
                onPressed: () {
                  Navigator.pushNamed(context, '/favorites');
                },
                tooltip: 'Voir mes favoris',
                child: const Icon(Icons.favorite_border),
              ),
            ),
          ),
        ],
      ),
    );
  }
}