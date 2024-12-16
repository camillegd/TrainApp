import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projet_gares/models/departure.dart';
import 'package:projet_gares/repositories/departures_repository.dart';

class DeparturesCubit extends Cubit<List<Departure>> {
  final DeparturesRepository repository;

  DeparturesCubit(this.repository) : super([]);

  Future<void> fetchDepartures(String stationId) async {
    try {
      emit([]);
      final token = dotenv.env['API_TOKEN'];
      final departures = await repository.fetchDepartures(token!);
      emit(departures.map((json) => Departure.fromJson(json)).toList());
    } catch (e) {
      // Handle error
    }
  }
}