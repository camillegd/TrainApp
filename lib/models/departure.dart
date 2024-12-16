class Departure {
  final String line;
  final String direction;
  final String departureTime;
  final String type;

  Departure(this.line, this.direction, this.departureTime, this.type);

  factory Departure.fromJson(Map<String, dynamic> json) {
    return Departure(
      json['line'] ?? 'Unknown',
      json['direction'] ?? 'Unknown',
      json['departure_time'] ?? 'Unknown',
      json['physical_mode_name'] ?? 'Unknown',
    );
  }

  @override
  String toString() {
    return 'Departure(line: $line, direction: $direction, departureTime: $departureTime, type: $type)';
  }
}