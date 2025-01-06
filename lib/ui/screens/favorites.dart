import 'package:flutter/material.dart';
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

  void _removeFavorite(TrainStation station) async {
    await _service.toggleFavorite(station, false);
    _loadFavoriteStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        centerTitle: true,
      ),
      body: _favoriteStations.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.train_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Pas de gares ajoutées en favoris.'),
                ],
              ),
            )
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color(0xFF8B2635)),
                            onPressed: () {
                              _removeFavorite(station);
                            },
                          ),
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
        child: const Icon(Icons.map_outlined),
      ),
    );
  }
}
