import 'package:projet_gares/models/train_station.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_gares/repository/train_station_repository.dart';

class TrainStationCubit extends Cubit<List<TrainStation>>{
  final TrainStationRepository _trainStationRepository;

  TrainStationCubit(this._trainStationRepository) : super([]);

  Future<void> getAllTrainStations() async {
    final List<TrainStation> trainStations = await _trainStationRepository.fetchTrainStations();
    emit(trainStations);
  }
}