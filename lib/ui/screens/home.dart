// Exemple de page d'accueil avec une liste de stations
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemple de liste d'ID de stations et de noms de stations
    const stations = [
      {'id': '87313759', 'name': 'Abancourt'},
      {'id': '87313874', 'name': 'Amiens'},
      {'id': '87271007', 'name': 'Paris Gare du Nord'},
      // Ajouter d'autres stations si nécessaire
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stations'),
      ),
      body: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final station = stations[index];
          return ListTile(
            title: Text(station['name']!),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/train_station',
                arguments: station['id'],  // Pass stationId dynamically here
              );
            },
          );
        },
      ),
    );
  }
}
