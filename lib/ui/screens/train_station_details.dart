import 'package:flutter/material.dart';

import '../widgets/arrivals_widget.dart';
import '../widgets/departures_widget.dart';

class TrainStation extends StatefulWidget {
  final String stationId;

  // Constructor with the required stationId parameter
  TrainStation({super.key, required this.stationId});


  @override
  _TrainStationState createState() => _TrainStationState();
}

class _TrainStationState extends State<TrainStation> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
        title: const Text('Station'),
      ),
      body:  _selectedIndex == 0 ? DeparturesWidget(stationId: widget.stationId,) : ArrivalsWidget(stationId: widget.stationId,),
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
