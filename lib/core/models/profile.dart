import 'package:flutter/material.dart';

class Profile {
  const Profile({
    required this.birthDate,
    required this.birthTime,
    required this.gender,
    required this.gestationalWeek,
    required this.name,
    required this.weight,
  });

  final DateTime birthDate;
  final TimeOfDay birthTime;
  final String gender;
  final int gestationalWeek;
  final String name;
  final double weight;

  Map<String, dynamic> toJson() {
    return {
      'birth_date': birthDate.toIso8601String(),
      'birth_time': '${birthTime.hour}:${birthTime.minute}',
      'gender': gender,
      'gestational_week': gestationalWeek,
      'name': name,
      'weight': weight,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['birth_time'] as String).split(':');
    return Profile(
      birthDate: DateTime.parse(json['birth_date']),
      birthTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      gender: json['gender'],
      gestationalWeek: json['gestational_week'],
      name: json['name'],
      weight: json['weight'],
    );
  }
}
