import 'dart:convert';
import 'package:http/http.dart' as http;

class DeparturesRepository {
  final String stationId;

  DeparturesRepository(this.stationId);

  Future<List<Map<String, dynamic>>> fetchDepartures(String token) async {
    final String url =
        'https://api.sncf.com/v1/coverage/sncf/stop_areas/stop_area:SNCF:$stationId/departures';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final departures = data['departures'] as List<dynamic>;

      return departures.map((departure) {
        return {
          'line': departure['route']?['line']?['name'] ?? 'Unknown',
          'departure_time': departure['stop_date_time']?['departure_date_time'] ?? 'Unknown',
          'direction': departure['display_informations']?['direction'] ?? 'Unknown',
          'physical_mode_name': departure['route']?['physical_modes']?[0]?['name'] ?? 'Unknown',
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch departures');
    }
  }
}