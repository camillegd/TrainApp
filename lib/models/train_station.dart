import 'dart:convert';

import 'package:latlong2/latlong.dart';

class TrainStation {
  final String stationId;
  final String name;
  final String shortLabel;
  final LatLng location;

  const TrainStation(this.stationId, this.name, this.shortLabel, this.location);

  factory TrainStation.fromJson(Map<String, dynamic> json) {
    final String stationId = json['stationId'];
    final String name = json['nom'];
    final String shortLabel = json['libellecourt'];
    final double latitude = json['position_geographique']['lat'];
    final double longitude = json['position_geographique']['lon'];
    final LatLng location = LatLng(latitude, longitude);

    return TrainStation(stationId, name, shortLabel, location);
  }

  factory TrainStation.fromGeoJson(Map<String, dynamic> json){
    final String name = json['nom'];
    final String shortLabel = json['libellecourt'];
    final double latitude = json['position_geographique']['lat'];
    final double longitude = json['position_geographique']['lon'];
    final LatLng location = LatLng(latitude, longitude);

    return TrainStation('', name, shortLabel, location);
  }

  String toJson() {
    return jsonEncode({
      'stationId': stationId,
      'nom': name,
      'libellecourt': shortLabel,
      'position_geographique': {
        'lat': location.latitude,
        'lon': location.longitude,
      },
    });
  }

}