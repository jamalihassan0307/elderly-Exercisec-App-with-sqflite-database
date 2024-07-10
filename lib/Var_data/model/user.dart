class User {
  final int id;
  final String? name;
  final String? gender;
  final String? weight;
  final String? height;
  final String? bmi;
  final String? birth;
  const User({
    required this.id,
    this.name,
    this.gender,
    this.weight,
    this.height,
    this.bmi,
    this.birth,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'gender': gender,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'birth': birth,
    };
  }

  static User fromJson(Map<String, Object?> json) => User(
        id: json['_id'] as int,
        name: json['name'] as String,
        gender: json['gender'] as String,
        weight: json['weight'] as String,
        height: json['height'] as String,
        bmi: json['bmi'] as String,
        birth: json['birth'] as String,
      );
}
