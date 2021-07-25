import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClientModel extends Equatable {
  String name;
  String id;
  String email;
  int phoneNumber;
  String imageUrl;
  int age;
  String fitnessGoals;
  String healthConditions;
  int fitnessPlanId;
  int dietPlanId;
  String uid;
  ClientModel({
    this.name = '',
    this.id = '',
    this.email = '',
    this.phoneNumber = 0,
    this.imageUrl = '',
    this.age = 0,
    this.fitnessGoals = '',
    this.healthConditions = '',
    this.fitnessPlanId = 0,
    this.dietPlanId = 0,
    this.uid = '',
  });


  

  ClientModel copyWith({
     String name,
    int id,
    String email,
    int phoneNumber,
    String imageUrl,
    int age,
    String fitnessGoals,
    String healthConditions,
    int fitnessPlanId,
    int dietPlanId,
    String uid,
  }) {
    return ClientModel(
      name: name ?? this.name,
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      age: age ?? this.age,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      healthConditions: healthConditions ?? this.healthConditions,
      fitnessPlanId: fitnessPlanId ?? this.fitnessPlanId,
      dietPlanId: dietPlanId ?? this.dietPlanId,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'age': age,
      'fitnessGoals': fitnessGoals,
      'healthConditions': healthConditions,
      'fitnessPlanId': fitnessPlanId,
      'dietPlanId': dietPlanId,
      'uid': uid,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      age: map['age'] ?? 0,
      fitnessGoals: map['fitnessGoals'] ?? '',
      healthConditions: map['healthConditions'] ?? '',
      fitnessPlanId: map['fitnessPlanId'] ?? 0,
      dietPlanId: map['dietPlanId'] ?? 0,
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) => ClientModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      id,
      email,
      phoneNumber,
      imageUrl,
      age,
      fitnessGoals,
      healthConditions,
      fitnessPlanId,
      dietPlanId,
      uid,
    ];
  }
}
