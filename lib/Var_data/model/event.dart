/// Example event class.
class Event {
  final int? id;
  final String eventKey;
  final String title;
  final String duration;
  final String kcal;
  final DateTime dateTime;
  const Event({
    this.id,
    required this.eventKey,
    required this.title,
    required this.duration,
    required this.kcal,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'eventKey': eventKey,
      'title': title,
      'duration': duration,
      'time': dateTime.toIso8601String(),
      'kcal': kcal,
    };
  }

  static Event fromJson(Map<String, Object?> json) => Event(
        id: json['_id'] as int,
        eventKey: json['eventKey'] as String,
        title: json['title'] as String,
        duration: json['duration'] as String,
        dateTime: DateTime.parse(json['time'] as String),
        kcal: json['kcal'] as String,
      );
}
