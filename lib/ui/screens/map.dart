import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projet_gares/blocs/train_station_cubit.dart';
import 'package:projet_gares/models/train_station.dart';

import '../../services/map_service.dart';
import '../widgets/search_bar_widget.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<Map> {
  final MapController _mapController = MapController();
  late MapService _service;
  List<Marker> markers = [];
  List<TrainStation> _allStations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = MapService(context.read<TrainStationCubit>());
    _fetchTrainStations();
  }

  void _fetchTrainStations() async {
    final trainStations = await _service.fetchTrainStations();
    setState(() {
      _allStations = trainStations;
      _addMarkers(trainStations);
      _isLoading = false;
    });
  }

  void _addMarkers(List<TrainStation> trainStations) {
    setState(() {
      markers = trainStations.map((station) {
        return Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(station.location.latitude, station.location.longitude),
          child: IconButton(
            icon: const Icon(Icons.location_on,
                color: Color(0xFF083D77), size: 40),
            onPressed: () {
              _showSnackBar('${station.name} (${station.shortLabel})', station);
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
    final position = await _service.getCurrentLocation();
    if (position == null) {
      _showSnackBar('Unable to retrieve location',
          const TrainStation('', '', '', LatLng(0, 0)));
      return;
    }

    setState(() {
      final currentLocationMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(position.latitude, position.longitude),
        child:
            const Icon(Icons.my_location, color: Color(0xFF8B2635), size: 30),
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
  }

  void _filterMarkers(String query) {
    final filteredStations = _allStations.where((station) {
      return station.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    _addMarkers(filteredStations);
    _zoomToFitMarkers();
  }

  void _zoomToFitMarkers() {
    if (markers.isEmpty) return;

    var bounds = LatLngBounds(markers.first.point, markers.first.point);
    for (var marker in markers) {
      bounds.extend(marker.point);
    }

    final center = bounds.center;
    final zoom = _calculateZoomLevel(bounds);

    _mapController.move(center, zoom);
  }

  double _calculateZoomLevel(LatLngBounds bounds) {
    // Implement your logic to calculate the appropriate zoom level
    // based on the bounds. This is a placeholder implementation.
    const maxZoom = 18.0;
    const minZoom = 6.0;
    // Calculate zoom level based on the bounds size
    // This is a simplified example, you may need a more complex calculation
    final latDiff = bounds.north - bounds.south;
    final lngDiff = bounds.east - bounds.west;
    final zoom = (maxZoom - minZoom) - (latDiff + lngDiff);
    return zoom.clamp(minZoom, maxZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des gares de France'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
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
          Column(
            children: [
              Container(
                color: Colors.transparent,
                child: SearchBarWidget(
                  onSearchChanged: (query) {
                    setState(() {
                      _filterMarkers(query);
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
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