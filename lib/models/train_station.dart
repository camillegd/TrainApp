import 'package:latlong2/latlong.dart';

class TrainStation {
  final String stationId;
  final String name;
  final String shortLabel;
  final LatLng location;

  const TrainStation(this.stationId, this.name, this.shortLabel, this.location);

  factory TrainStation.fromGeoJson(Map<String, dynamic> json){
    final String name = json['nom'];
    final String shortLabel = json['libellecourt'];
    final double latitude = json['position_geographique']['lat'];
    final double longitude = json['position_geographique']['lon'];
    final LatLng location = LatLng(latitude, longitude);

    return TrainStation('', name, shortLabel, location);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': stationId,
      'nom': name,
      'libellecourt': shortLabel,
      'position_geographique': {
        'lat': location.latitude,
        'lon': location.longitude,
      },
    };
  }

  factory TrainStation.fromJson(Map<String, dynamic> json) {
    final String stationId = json['id'];
    final String name = json['nom'];
    final String shortLabel = json['libellecourt'];
    final double latitude = json['position_geographique']['lat'];
    final double longitude = json['position_geographique']['lon'];
    final LatLng location = LatLng(latitude, longitude);

    return TrainStation(stationId, name, shortLabel, location);
  }

}