import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/train_station.dart';

class TrainStationService {

  Future<List<TrainStation>> getFavoriteStations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('favorite_')).toList();
    final List<TrainStation> stations = [];
    for (String key in keys) {
      final String? stationJson = prefs.getString(key);
      if (stationJson != null) {
        final Map<String, dynamic> stationMap = jsonDecode(stationJson);
        stations.add(TrainStation.fromJson(stationMap));
      }
    }
    return stations;
  }

  Future<bool> isFavorite(String stationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('favorite_$stationId');
  }

  Future<void> toggleFavorite(TrainStation station, bool isFavorite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isFavorite) {
      await prefs.setString('favorite_${station.stationId}', station.toJson());
    } else {
      await prefs.remove('favorite_${station.stationId}');
    }
  }

}