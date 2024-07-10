class Exercise {
  final int id;
  final String imagePath;
  final String time;
  final String name;
  final List steps;
  final Duration duration;

  Exercise({
    required this.id,
    required this.imagePath,
    required this.time,
    required this.name,
    required this.steps,
    required this.duration,
  });
}
