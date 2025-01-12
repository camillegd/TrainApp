import 'package:geolocator/geolocator.dart';
import 'package:projet_gares/models/train_station_state.dart';

import '../../blocs/train_station_cubit.dart';

class MapService {
  final TrainStationCubit trainStationCubit;

  MapService(this.trainStationCubit);

  Future<TrainStationState> fetchTrainStations() async {
    await trainStationCubit.getAllTrainStations();
    final state = trainStationCubit.state;
    return state;
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}