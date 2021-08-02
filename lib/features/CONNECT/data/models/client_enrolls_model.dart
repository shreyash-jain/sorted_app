import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/institute_instance.dart';

class ClientEnrollsModel extends Equatable {
  List<ClassInstanceModel> requestedClasses;
  List<ClassInstanceModel> enrolledClasses;
  List<ConsultationInstanceModel> requestedConsultation;
  List<ConsultationInstanceModel> enrolledConsultation;
  List<InstituteInstanceModel> requestedInstitutes;
  List<InstituteInstanceModel> enrolledInstitutes;
  
  ClientEnrollsModel({
    this.requestedClasses = const [],
    this.enrolledClasses = const [],
    this.requestedConsultation = const [],
    this.enrolledConsultation = const [],
    this.requestedInstitutes = const [],
    this.enrolledInstitutes = const [],
  });

  ClientEnrollsModel copyWith({
    List<ClassInstanceModel> requestedClasses,
    List<ClassInstanceModel> enrolledClasses,
    List<ConsultationInstanceModel> requestedConsultation,
    List<ConsultationInstanceModel> enrolledConsultation,
    List<InstituteInstanceModel> requestedInstitutes,
    List<InstituteInstanceModel> enrolledInstitutes,
  }) {
    return ClientEnrollsModel(
      requestedClasses: requestedClasses ?? this.requestedClasses,
      enrolledClasses: enrolledClasses ?? this.enrolledClasses,
      requestedConsultation:
          requestedConsultation ?? this.requestedConsultation,
      enrolledConsultation: enrolledConsultation ?? this.enrolledConsultation,
      requestedInstitutes: requestedInstitutes ?? this.requestedInstitutes,
      enrolledInstitutes: enrolledInstitutes ?? this.enrolledInstitutes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestedClasses': requestedClasses?.map((x) => x.toMap())?.toList(),
      'enrolledClasses': enrolledClasses?.map((x) => x.toMap())?.toList(),
      'requestedConsultation':
          requestedConsultation?.map((x) => x.toMap())?.toList(),
      'enrolledConsultation':
          enrolledConsultation?.map((x) => x.toMap())?.toList(),
      'requestedInstitutes':
          requestedInstitutes?.map((x) => x.toMap())?.toList(),
      'enrolledInstitutes': enrolledInstitutes?.map((x) => x.toMap())?.toList(),
    };
  }

  factory ClientEnrollsModel.fromMap(Map<String, dynamic> map) {
    return ClientEnrollsModel(
      requestedClasses: List<ClassInstanceModel>.from(map['requestedClasses']
              ?.map((x) =>
                  ClassInstanceModel.fromMap(x) ?? ClassInstanceModel()) ??
          const []),
      enrolledClasses: List<ClassInstanceModel>.from(map['enrolledClasses']
              ?.map((x) =>
                  ClassInstanceModel.fromMap(x) ?? ClassInstanceModel()) ??
          const []),
      requestedConsultation: List<ConsultationInstanceModel>.from(
          map['requestedConsultation']?.map((x) =>
                  ConsultationInstanceModel.fromMap(x) ??
                  ConsultationInstanceModel()) ??
              const []),
      enrolledConsultation: List<ConsultationInstanceModel>.from(
          map['enrolledConsultation']?.map((x) =>
                  ConsultationInstanceModel.fromMap(x) ??
                  ConsultationInstanceModel()) ??
              const []),
      requestedInstitutes: List<InstituteInstanceModel>.from(
          map['requestedInstitutes']?.map((x) =>
                  InstituteInstanceModel.fromMap(x) ??
                  InstituteInstanceModel()) ??
              const []),
      enrolledInstitutes: List<InstituteInstanceModel>.from(
          map['enrolledInstitutes']?.map((x) =>
                  InstituteInstanceModel.fromMap(x) ??
                  InstituteInstanceModel()) ??
              const []),
    );
  }

  factory ClientEnrollsModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    return ClientEnrollsModel(
      requestedClasses:
          List<ClassInstanceModel>.from(map['requestedClasses'].map((i) {
                var z = Map<String, dynamic>.from(i);
                print("getEnrollsOfClient in snapshot $z");

                return ClassInstanceModel.fromMap(z) ?? ClassInstanceModel();
              }) ??
              const []),
      enrolledClasses:
          List<ClassInstanceModel>.from(map['enrolledClasses'].map((i) {
                var z = Map<String, dynamic>.from(i);

                return ClassInstanceModel.fromMap(z) ?? ClassInstanceModel();
              }) ??
              const []),
      requestedConsultation: List<ConsultationInstanceModel>.from(
          map['requestedConsultation'].map((i) {
                var z = Map<String, dynamic>.from(i);

                return ConsultationInstanceModel.fromMap(z) ??
                    ConsultationInstanceModel();
              }) ??
              const []),
      enrolledConsultation: List<ConsultationInstanceModel>.from(
          map['enrolledConsultation'].map((i) {
                var z = Map<String, dynamic>.from(i);

                return ConsultationInstanceModel.fromMap(z) ??
                    ConsultationInstanceModel();
              }) ??
              const []),
      requestedInstitutes:
          List<InstituteInstanceModel>.from(map['requestedInstitutes'].map((i) {
                var z = Map<String, dynamic>.from(i);

                return InstituteInstanceModel.fromMap(z) ??
                    InstituteInstanceModel();
              }) ??
              const []),
      enrolledInstitutes:
          List<InstituteInstanceModel>.from(map['enrolledInstitutes'].map((i) {
                var z = Map<String, dynamic>.from(i);

                return InstituteInstanceModel.fromMap(z) ??
                    InstituteInstanceModel();
              }) ??
              const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientEnrollsModel.fromJson(String source) =>
      ClientEnrollsModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      requestedClasses,
      enrolledClasses,
      requestedConsultation,
      enrolledConsultation,
      requestedInstitutes,
      enrolledInstitutes,
    ];
  }
}
