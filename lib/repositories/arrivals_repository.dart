import 'dart:convert';
import 'package:http/http.dart' as http;

class ArrivalsRepository {
  final String stationId;

  ArrivalsRepository(this.stationId);

  Future<List<Map<String, dynamic>>> fetchArrivals() async {
    final String url =
        'https://api.sncf.com/v1/coverage/sncf/stop_areas/stop_area:SNCF:$stationId/arrivals';
    const String token = '9d9b8d59-e302-41c1-be38-e22bfd5a6f7f';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final arrivals = data['arrivals'] as List<dynamic>;

      return arrivals.map((arrival) {
        return {
          'line': arrival['route']?['line']?['name'] ?? 'Unknown',
          'arrival_time': arrival['stop_date_time']?['arrival_date_time'] ?? 'Unknown',
          'direction': arrival['display_informations']?['direction'] ?? 'Unknown',
          'physical_mode_name': arrival['route']?['physical_modes']?[0]?['name'] ?? 'Unknown',
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch arrivals');
    }
  }
}