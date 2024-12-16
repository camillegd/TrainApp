import 'package:bloc/bloc.dart';
import 'package:projet_gares/models/departure.dart';
import 'package:projet_gares/repositories/departures_repository.dart';

class DeparturesCubit extends Cubit<List<Departure>> {
  final DeparturesRepository repository;

  DeparturesCubit(this.repository) : super([]);

  Future<void> fetchDepartures(String stationId) async {
    try {
      emit([]);
      final departures = await repository.fetchDepartures();
      emit(departures.map((json) => Departure.fromJson(json)).toList());
    } catch (e) {
      // Handle error
    }
  }
}