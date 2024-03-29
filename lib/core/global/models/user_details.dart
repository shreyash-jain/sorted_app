import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum Gender { male, female, unknown }
enum Profession { student, working, both, unknown }

class UserDetail extends Equatable {
  final String name;
  final String imageUrl;
  final String email;
  final String id;
  final String userName;
  final int age;
  final int diaryStreak;
  final String currentDevice;
  final int currentDeviceId;
  final int points;
  final int level;
  final Gender gender;
  final Profession profession;

  final int mobileNumber;
  final String status;

  UserDetail(
      {this.currentDevice,
      this.currentDeviceId,
      this.name = "User",
      this.imageUrl =
          "https://lh4.googleusercontent.com/-EV2-cJYALr0/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucmi-Jjd1nedgh6-6T3JFazcDTpFbA/s96-c/photo.jpg",
      this.email = "sortedlabs@gmail.com",
      this.id,
      this.userName = "Sort It User",
      this.age,
      this.diaryStreak = 5,
      this.points = 15,
      this.level = 25,
      this.gender = Gender.male,
      this.profession = Profession.student,
      this.mobileNumber = 0,
      this.status = ''});

  @override
  List<Object> get props {
    return [
      name,
      imageUrl,
      email,
      currentDeviceId,
      currentDevice,
      id,
      userName,
      age,
      diaryStreak,
      points,
      level,
      gender,
      profession,
      mobileNumber,
      status
    ];
  }

  UserDetail copyWith(
      {String name,
      String imageUrl,
      String email,
      String id,
      String userName,
      int currentDeviceId,
      String currentDevice,
      int age,
      int diaryStreak,
      int points,
      int level,
      Gender gender,
      Profession profession,
      int mobileNumber,
      String status}) {
    print(5);
    return UserDetail(
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        email: email ?? this.email,
        id: id ?? this.id,
        userName: userName ?? this.userName,
        age: age ?? this.age,
        currentDeviceId: currentDeviceId ?? this.currentDeviceId,
        currentDevice: currentDevice ?? this.currentDevice,
        diaryStreak: diaryStreak ?? this.diaryStreak,
        points: points ?? this.points,
        level: level ?? this.level,
        gender: gender ?? this.gender,
        profession: profession ?? this.profession,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        status: status ?? this.status);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'id': id,
      'userName': userName,
      'currentDeviceId': currentDeviceId,
      'currentDevice': currentDevice,
      'age': age,
      'diary_streak': diaryStreak,
      'points': points,
      'level': level,
      'gender': gender == Gender.male ? 0 : 1,
      'mobileNumber': mobileNumber,
      'status': status,
      'profession': profession == Profession.student
          ? 0
          : (profession == Profession.working)
              ? 1
              : 2,
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
      currentDeviceId: map['currentDeviceId'],
      currentDevice: map['currentDevice'],
      points: map['points'],
      level: map['level'],
      status: map['status'],
      mobileNumber: map['mobileNumber'],
      gender: Gender.values[(map['gender'])],
      profession: Profession.values[(map['profession'])],
    );
  }
  factory UserDetail.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    if (map == null) return null;

    return UserDetail(
      name: map['name'],
      imageUrl: map['imageUrl'],
      email: map['email'],
      id: map['id'],
      userName: map['userName'],
      currentDeviceId: map['currentDeviceId'],
      currentDevice: map['currentDevice'],
      age: map['age'],
      diaryStreak: map['diary_streak'],
      points: map['points'],
      status: map['status'],
      mobileNumber: map['mobileNumber'],
      level: map['level'],
      gender: Gender.values[(map['gender'])],
      profession: Profession.values[(map['profession'])],
    );
  }
  String toJson() => json.encode(toMap());

  factory UserDetail.fromJson(String source) =>
      UserDetail.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  int checkValidityOnUserIntro() {
    if (gender == null) return 1;
    if (age == null || age < 1) return 2;

    return 10;
  }

  String generateMessageOnUserIntro() {
    if (userName == null || userName == "")
      return "Please enter a valid phone number";
    if (age == null || age < 10) return "$name, please enter your valid age";

    if (gender == null) return "$name, please complete all details";
    return "";
  }
}
