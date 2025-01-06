import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projet_gares/repositories/arrivals_repository.dart';
import '../models/arrival.dart';

class ArrivalsCubit extends Cubit<List<Arrival>> {
  final ArrivalsRepository repository;

  ArrivalsCubit(this.repository) : super([]);

  Future<void> fetchArrivals(String stationId) async {
    try {
      emit([]);
      final token = dotenv.env['API_TOKEN'];
      final arrivals = await repository.fetchArrivals(token!);
      emit(arrivals.map((json) => Arrival.fromJson(json)).toList());
    } catch (e) {
    }
  }
}