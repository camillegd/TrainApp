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
            icon: Icon(Icons.location_on, color: Colors.blue, size: 40),
            onPressed: () {
              _showSnackBar('${station.name} (${station.shortLabel})', station.stationId);
            },
          ),
        );
      }).toList();
    });
  }

  void _showSnackBar(String message, String stationId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Details',
          onPressed: () {
            Navigator.pushNamed(context, '/train_station', arguments: stationId);
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
        _showSnackBar('Les services de localisation sont désactivés', '');
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Permissions de localisation refusées', '');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Permissions de localisation permanentemente refusées', '');
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
          child: Icon(Icons.my_location, color: Colors.green, size: 40),
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
      _showSnackBar('Impossible de récupérer la localisation : $e', '');
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
        options: MapOptions(
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
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
        tooltip: 'Centrer sur ma position',
      ),
    );
  }
}