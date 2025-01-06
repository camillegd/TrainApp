import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/train_station.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<TrainStation> _favoriteStations = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteStations();
  }

  void _loadFavoriteStations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('favorite_')).toList();
    final List<TrainStation> stations = [];
    for (String key in keys) {
      final String? stationJson = prefs.getString(key);
      if (stationJson != null) {
        final Map<String, dynamic> stationMap = jsonDecode(stationJson);
        stations.add(TrainStation.fromJson(stationMap));
      }
    }
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
          ? const Center(child: Text('No favorites added'))
          : ListView.builder(
        itemCount: _favoriteStations.length,
        itemBuilder: (context, index) {
          final station = _favoriteStations[index];
          return ListTile(
            title: Text(station.name),
            subtitle: Text(station.shortLabel),
            onTap: () {
              Navigator.pushNamed(context, '/train_station', arguments: station);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, '/home');
        },
        child: const Icon(Icons.train_outlined),
      ),
    );
  }
}