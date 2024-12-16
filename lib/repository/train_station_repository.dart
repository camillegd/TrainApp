


import 'dart:convert';

import 'package:http/http.dart';
import 'package:projet_gares/models/train_station.dart';

class TrainStationRepository {

  Future<List<TrainStation>> fetchTrainStations() async {
    final Response response = await get(Uri.parse('https://data.sncf.com/api/explore/v2.1/catalog/datasets/gares-de-voyageurs/records?limit=20'));
    if(response.statusCode == 200){
      final List<TrainStation> trainStations = [];

      final Map<String, dynamic> json = jsonDecode(response.body);



      return trainStations;
    } else {
      throw Exception('Failed to load train stations');
    }
    
  }

}