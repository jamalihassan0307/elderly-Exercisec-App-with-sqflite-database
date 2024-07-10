class Reports {
  final int? id;
  final String workouts;
  final String kcal;
  final String duration;
  final DateTime time;
  final String eventKey;

  const Reports({
    this.id,
    required this.workouts,
    required this.kcal,
    required this.duration,
    required this.time,
    required this.eventKey,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'workouts': workouts,
      'kcal': kcal,
      'duration': duration,
      'time': time.toIso8601String(),
      'eventKey': eventKey,
    };
  }

  static Reports fromJson(Map<String, Object?> json) => Reports(
        id: json['_id'] as int,
        workouts: json['workouts'] as String,
        kcal: json['kcal'] as String,
        duration: json['duration'] as String,
        time: DateTime.parse(json['time'] as String),
        eventKey: json['eventKey'] as String,
      );
}
