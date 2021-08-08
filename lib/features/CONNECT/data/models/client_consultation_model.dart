import 'dart:convert';

import 'package:equatable/equatable.dart';

//!same as pro

class ClientConsultationModel extends Equatable {
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
  int type;
  int hasPackage;
  String packageId;
  String startDate;
  String endDate;
  String coachId;
  String coachName;

  //0->requested
  //1->accepted
  //2->removed
  int clientState;
  String dietPreference;
  double weight;

  String initialClientMessage;
  String packageName;
  int prefferedSlot;

  ClientConsultationModel({
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
    this.type = 0,
    this.hasPackage = 0,
    this.packageId = '',
    this.startDate = '',
    this.endDate = '',
    this.coachId = '',
    this.coachName = '',
    this.clientState = 0,
    this.dietPreference = '',
    this.weight = 0.0,
    this.initialClientMessage = '',
    this.packageName = '',
    this.prefferedSlot = 0,
  });

  ClientConsultationModel copyWith({
    String name,
    String id,
    String email,
    int phoneNumber,
    String imageUrl,
    int age,
    String fitnessGoals,
    String healthConditions,
    int fitnessPlanId,
    int dietPlanId,
    String uid,
    int type,
    int hasPackage,
    String packageId,
    String startDate,
    String endDate,
    String coachId,
    String coachName,
    int clientState,
    String dietPreference,
    double weight,
    String initialClientMessage,
    String packageName,
    int prefferedSlot,
  }) {
    return ClientConsultationModel(
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
      type: type ?? this.type,
      hasPackage: hasPackage ?? this.hasPackage,
      packageId: packageId ?? this.packageId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coachId: coachId ?? this.coachId,
      coachName: coachName ?? this.coachName,
      clientState: clientState ?? this.clientState,
      dietPreference: dietPreference ?? this.dietPreference,
      weight: weight ?? this.weight,
      initialClientMessage: initialClientMessage ?? this.initialClientMessage,
      packageName: packageName ?? this.packageName,
      prefferedSlot: prefferedSlot ?? this.prefferedSlot,
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
      'type': type,
      'hasPackage': hasPackage,
      'packageId': packageId,
      'startDate': startDate,
      'endDate': endDate,
      'coachId': coachId,
      'coachName': coachName,
      'clientState': clientState,
      'dietPreference': dietPreference,
      'weight': weight,
      'initialClientMessage': initialClientMessage,
      'packageName': packageName,
      'prefferedSlot': prefferedSlot,
    };
  }

  factory ClientConsultationModel.fromMap(Map<String, dynamic> map) {
    return ClientConsultationModel(
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
      type: map['type'] ?? 0,
      hasPackage: map['hasPackage'] ?? 0,
      packageId: map['packageId'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      coachId: map['coachId'] ?? '',
      coachName: map['coachName'] ?? '',
      clientState: map['clientState'] ?? 0,
      dietPreference: map['dietPreference'] ?? '',
      weight: map['weight'] ?? 0.0,
      initialClientMessage: map['initialClientMessage'] ?? '',
      packageName: map['packageName'] ?? '',
      prefferedSlot: map['prefferedSlot'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientConsultationModel.fromJson(String source) =>
      ClientConsultationModel.fromMap(json.decode(source));

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
      type,
      hasPackage,
      packageId,
      startDate,
      endDate,
      coachId,
      coachName,
      clientState,
      dietPreference,
      weight,
      initialClientMessage,
      packageName,
      prefferedSlot,
    ];
  }
}
