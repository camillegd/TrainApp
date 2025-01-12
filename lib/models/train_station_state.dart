import 'package:projet_gares/models/train_station.dart';

class TrainStationState {
  final bool isLoading;
  final List<TrainStation> trainStations;
  final String? error;

  TrainStationState({this.isLoading = false, this.trainStations = const [], this.error});

}