import 'package:latlong2/latlong.dart';

class TrainStation {
  final String name;
  final String shortLabel;
  final LatLng location;

  const TrainStation(this.name, this.shortLabel, this.location);

  factory TrainStation.fromGeoJson(Map<String, dynamic> json){
    final String name = json['nom'];
    final String shortLabel = json['libellecourt'];
    final double latitude = json['position_geographique']['lat'];
    final double longitude = json['position_geographique']['lon'];
    final LatLng location = LatLng(latitude, longitude);

    return TrainStation(name, shortLabel, location);
  }

}