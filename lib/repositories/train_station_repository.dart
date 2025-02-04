import 'dart:convert';
import 'package:http/http.dart';
import 'package:projet_gares/models/train_station.dart';

class TrainStationRepository {

  Future<List<TrainStation>> fetchTrainStations() async {
    final Response response = await get(Uri.parse('https://data.sncf.com/api/explore/v2.1/catalog/datasets/gares-de-voyageurs/records?limit=100&refine=segment_drg%3A%22A%22&refine=segment_drg%3A%22A%3BA%22'));
    if(response.statusCode == 200){
      final List<TrainStation> trainStations = [];

      final Map<String, dynamic> json = jsonDecode(response.body);
      if(json.containsKey("results")){
        final List<dynamic> results = json['results'];

        for (Map<String, dynamic> result in results){
          final trainStation = TrainStation.fromGeoJson(result);
          final id = await fetchStationId(trainStation.shortLabel);
          String stationId;
          if (id.contains(';')) {
            stationId = id.split(';').last;
          } else {
            stationId = id;
          }
          trainStations.add(TrainStation(stationId, trainStation.name, trainStation.shortLabel, trainStation.location));
        }
      }
      return trainStations;
    } else {
      throw Exception('Failed to load train stations');
    }
  }

  Future<String> fetchStationId(String shortLabel) async {
    final Response response = await get(Uri.parse('https://data.sncf.com/api/explore/v2.1/catalog/datasets/gares-de-voyageurs/records?refine=libellecourt%3A$shortLabel'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      if (json.containsKey("results") && json['results'].isNotEmpty) {
        return json['results'][0]['codes_uic'];
      } else {
        throw Exception('Failed to load station ID');
      }
    } else {
      throw Exception('Failed to load station ID');
    }
  }
}
