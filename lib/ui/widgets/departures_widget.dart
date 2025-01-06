import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_gares/blocs/departures_cubit.dart';

import '../../models/departure.dart';

class DeparturesWidget extends StatefulWidget {
  final String stationId;

  // Constructor with the required stationId parameter
  DeparturesWidget({super.key, required this.stationId});

  @override
  _DeparturesWidgetState createState() => _DeparturesWidgetState();
}

class _DeparturesWidgetState extends State<DeparturesWidget> {
  @override
  void initState() {
    super.initState();
    context.read<DeparturesCubit>().fetchDepartures(widget.stationId);
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
      body: BlocBuilder<DeparturesCubit, List<Departure>>(
        builder: (context, departures) {
          if (departures.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: departures.length,
            itemBuilder: (context, index) {
              final departure = departures[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direction : ${departure.direction}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Départ : ${formatDateTime(departure.departureTime)}'),
                      Text('Ligne : ${departure.line}'),
                      Text('Type : ${departure.type}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<DeparturesCubit>().fetchDepartures(widget.stationId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}