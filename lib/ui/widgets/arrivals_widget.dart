import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/arrivals_cubit.dart';
import '../../models/arrival.dart';

class ArrivalsWidget extends StatefulWidget {
  final String stationId;

 const ArrivalsWidget({super.key, required this.stationId});

  @override
  ArrivalsWidgetState createState() => ArrivalsWidgetState();
}

class ArrivalsWidgetState extends State<ArrivalsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ArrivalsCubit>().fetchArrivals(widget.stationId);
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
      body: BlocBuilder<ArrivalsCubit, List<Arrival>>(
        builder: (context, arrivals) {
          if (arrivals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: arrivals.length,
            itemBuilder: (context, index) {
              final arrival = arrivals[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Provenance : ${arrival.direction}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Arrivée : ${formatDateTime(arrival.arrivalTime)}'),
                      Text('Ligne : ${arrival.line}'),
                      Text('Type : ${arrival.type}'),
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
          context.read<ArrivalsCubit>().fetchArrivals(widget.stationId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}