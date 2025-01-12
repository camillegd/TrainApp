import 'package:flutter/material.dart';

import '../../models/train_station.dart';
import '../../services/train_station_service.dart';
import '../widgets/arrivals_widget.dart';
import '../widgets/departures_widget.dart';

class TrainStationDetails extends StatefulWidget {
  final TrainStation station;

  const TrainStationDetails({super.key, required this.station});

  @override
  _TrainStationDetailsState createState() => _TrainStationDetailsState();
}

class _TrainStationDetailsState extends State<TrainStationDetails> {
  final TrainStationService _service = TrainStationService();
  int _selectedIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleFavorite() async {
    await _service.toggleFavorite(widget.station, !_isFavorite);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _loadFavoriteStatus() async {
    final isFavorite = await _service.isFavorite(widget.station.stationId);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  String formatDateTime(String dateTime) {
    try {
      final parsedDate = DateTime.parse(dateTime);
      return '${parsedDate.hour}:${parsedDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.stationId),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? const Color(0xFF8B2635) : Colors.white,
              ),
              onPressed: _toggleFavorite,
            ),
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? DeparturesWidget(
              stationId: widget.station.stationId,
            )
          : ArrivalsWidget(
              stationId: widget.station.stationId,
            ),
      floatingActionButton: Padding(
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_train),
            label: 'Départs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_train),
            label: 'Arrivées',
          ),
        ],
        backgroundColor: const Color(0xFF083D77),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
