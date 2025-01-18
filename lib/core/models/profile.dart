class Profile {
  const Profile({
    required this.birthDate,
    required this.gender,
    required this.gestationalWeek,
    required this.name,
    required this.weight,
  });

  final DateTime birthDate;
  final String gender;
  final int gestationalWeek;
  final String name;
  final double weight;

  Map<String, dynamic> toJson() {
    return {
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'gestational_week': gestationalWeek,
      'name': name,
      'weight': weight,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      birthDate: DateTime.parse(json['birth_date']),
      gender: json['gender'],
      gestationalWeek: json['gestational_week'],
      name: json['name'],
      weight: json['weight'],
    );
  }
}
