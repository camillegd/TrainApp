class Arrival {
  final String line;
  final String direction;
  final String arrivalTime;
  final String type;

  Arrival(this.line, this.direction, this.arrivalTime, this.type);

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      json['line'] ?? 'Unknown',
      json['direction'] ?? 'Unknown',
      json['arrival_time'] ?? 'Unknown',
      json['physical_mode_name'] ?? 'Unknown',
    );
  }

  @override
  String toString() {
    return 'Arrival(line: $line, direction: $direction, arrivalTime: $arrivalTime, type: $type)';
  }
}