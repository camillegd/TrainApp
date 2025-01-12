import 'package:projet_gares/models/train_station.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_gares/repositories/train_station_repository.dart';

import '../models/train_station_state.dart';

class TrainStationCubit extends Cubit<TrainStationState>{
  final TrainStationRepository _trainStationRepository;

  TrainStationCubit(this._trainStationRepository) : super(TrainStationState());

  Future<void> getAllTrainStations() async {
    try {
      emit(TrainStationState(isLoading: true));
      final List<TrainStation> trainStations = await _trainStationRepository.fetchTrainStations();
      emit(TrainStationState(trainStations: trainStations, isLoading: false, error: null));
    } on Exception catch (e) {
      emit(TrainStationState(error: e.toString()));
    }
  }
}