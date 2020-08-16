import 'dart:convert';

import 'package:equatable/equatable.dart';

enum Gender { male, female }
enum Profession { student, working, both }

class UserDetail extends Equatable {
  final String name;
  final String imageUrl;
  final String email;
  final int id;
  final String userName;
  final int age;
  final int diaryStreak;
  final int points;
  final int level;
  final Gender gender;
  final Profession profession;
  UserDetail({
    this.name,
    this.imageUrl,
    this.email,
    this.id,
    this.userName,
    this.age,
    this.diaryStreak,
    this.points,
    this.level,
    this.gender,
    this.profession,
  });

  @override
  
  List<Object> get props {
    return [
      name,
      imageUrl,
      email,
      id,
      userName,
      age,
      diaryStreak,
      points,
      level,
      gender,
      profession,
    ];
  }

  UserDetail copyWith({
    String name,
    String imageUrl,
    String email,
    int id,
    String userName,
    int age,
    int diaryStreak,
    int points,
    int level,
    Gender gender,
    Profession profession,
  }) {
    return UserDetail(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      id: id ?? this.id,
      userName: userName ?? this.userName,
      age: age ?? this.age,
      diaryStreak: diaryStreak ?? this.diaryStreak,
      points: points ?? this.points,
      level: level ?? this.level,
      gender: gender ?? this.gender,
      profession: profession ?? this.profession,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'id': id,
      'userName': userName,
      'age': age,
      'diary_streak': diaryStreak,
      'points': points,
      'level': level,
      'gender': gender==Gender.male?0:1,
      'profession': profession==Profession.student?0:(profession==Profession.working)?1:2,
    };
  }

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserDetail(
      name: map['name'],
      imageUrl: map['imageUrl'],
      email: map['email'],
      id: map['id'],
      userName: map['userName'],
      age: map['age'],
      diaryStreak: map['diary_streak'],
      points: map['points'],
      level: map['level'],
      gender: Gender.values[(map['gender'])],
      profession: Profession.values[(map['profession'])],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetail.fromJson(String source) => UserDetail.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
