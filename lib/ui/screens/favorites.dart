import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/train_station.dart';
import '../../services/train_station_service.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final TrainStationService _service = TrainStationService();
  List<TrainStation> _favoriteStations = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStations();
  }

  void _loadFavoriteStations() async {
    final stations = await _service.getFavoriteStations();
    setState(() {
      _favoriteStations = stations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: _favoriteStations.isEmpty
          ? const Center(child: Text('Pas de gares ajoutées en favoris.'))
          : ListView.builder(
              itemCount: _favoriteStations.length,
              itemBuilder: (context, index) {
                final station = _favoriteStations[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/train_station',
                          arguments: station);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Libellé court : ${station.shortLabel}'),
                          Text('Latitude : ${station.location.latitude}'),
                          Text('Longitude : ${station.location.longitude}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'favorites',
        onPressed: () {
          Navigator.pop(context, '/home');
        },
        child: const Icon(Icons.train_outlined),
      ),
    );
  }
}
