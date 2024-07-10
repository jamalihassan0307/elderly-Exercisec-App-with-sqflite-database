import 'package:ex_app/data/advanced_exercises.dart';
import 'package:ex_app/data/beginner_exercises.dart';
import 'package:ex_app/data/intermediate_exercises.dart';
import 'package:ex_app/data/low_impact_cardio_workout.dart';

class Levels {
  final int id;
  final String imagePath;
  final String time;
  final String kcal;
  final String title;
  final List exercise;
  final Duration duration;
  final double skipKcal;

  Levels({
    required this.id,
    required this.imagePath,
    required this.time,
    required this.kcal,
    required this.title,
    required this.exercise,
    required this.skipKcal,
    required this.duration,
  });
}

List<Levels> levels = [
  Levels(
    id: 0,
    imagePath: 'assets/images/BeginnersPic.JPG',
    time: '15',
    kcal: '60',
    skipKcal: 0.067,
    title: 'Exercise for Beginners',
    exercise: beginnerExercises,
    duration: const Duration(minutes: 15),
  ),
  Levels(
    id: 1,
    imagePath: 'assets/images/IntermediatePic.JPG',
    time: '12',
    kcal: '60',
    skipKcal: 0.083,
    title: 'Exercise for Intermediate',
    exercise: intermediateExercises,
    duration: const Duration(minutes: 12),
  ),
  Levels(
    id: 2,
    imagePath: 'assets/images/AdvanedPic.PNG',
    time: '12',
    kcal: '72',
    skipKcal: 0.1,
    title: 'Exercise for Advanced',
    exercise: advancedExercises,
    duration: const Duration(minutes: 12),
  ),
  Levels(
    id: 3,
    imagePath: 'assets/images/lowImpactCardioWorkout.jpg',
    time: '15',
    kcal: '60',
    skipKcal: 0.083,
    title: 'Low impact cardio workout',
    exercise: lowImpactCardioWorkout,
    duration: const Duration(minutes: 15),
  ),
];
