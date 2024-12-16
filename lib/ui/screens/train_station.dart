import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrainStation extends StatefulWidget {
  final String stationId;

  // Constructor with the required stationId parameter
  TrainStation({super.key, required this.stationId});


  @override
  _TrainStationState createState() => _TrainStationState();
}

class _TrainStationState extends State<TrainStation> {
  late Future<List<Map<String, dynamic>>> _departures;

  @override
  void initState() {
    super.initState();
    _departures = fetchDepartures();
  }

  Future<List<Map<String, dynamic>>> fetchDepartures() async {
    final String url =
        'https://api.sncf.com/v1/coverage/sncf/stop_areas/stop_area:SNCF:${widget.stationId}/departures';
    const String token = '9d9b8d59-e302-41c1-be38-e22bfd5a6f7f';  // Ton token API

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final departures = data['departures'] as List<dynamic>;

      return departures.map((departure) {
        return {
          'line': departure['route']?['line']?['name'] ?? 'Unknown',  // Vérification null pour 'line'
          'departure_time': departure['stop_date_time']?['departure_date_time'] ?? 'Unknown',  // Vérification null pour 'departure_date_time'
          'arrival_time': departure['stop_date_time']?['arrival_date_time'] ?? 'Unknown',
          'direction': departure['display_informations']?['direction'] ?? 'Unknown',  // Vérification null pour 'direction'
          'physical_mode_name': departure['route']?['physical_modes']?[0]?['name'] ?? 'Unknown',  // Extraction du "name" de "physical_modes"
        };
      }).toList();
    } else {
      throw Exception('Échec de la récupération des départs');
    }
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _departures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No departures available.'));
          }

          final departures = snapshot.data!;
          return ListView.builder(
            itemCount: departures.length,
            itemBuilder: (context, index) {
              final departure = departures[index];
              return ListTile(
                title: Text('${departure['direction']}'),
                subtitle: Text(
                  'Départ : ${formatDateTime(departure['departure_time'])}\nArrivée : ${formatDateTime(departure['arrival_time'])}\nLigne : ${departure['line']}\nType de train : ${departure['physical_mode_name']}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
