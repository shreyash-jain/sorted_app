import 'dart:convert';

import 'package:equatable/equatable.dart';

//! commom with pro
class ConsultationTrainerInstanceModel extends Equatable {
  String consultationId;
  String coachName;
  String coachUrl;
  String packageName;
  String packageId;
  String coachId;
  ConsultationTrainerInstanceModel({
    this.consultationId = '',
    this.coachName = '',
    this.coachUrl = '',
    this.packageName = '',
    this.packageId = '',
    this.coachId = '',
  });

  ConsultationTrainerInstanceModel copyWith({
    String consultationId,
    String coachName,
    String coachUrl,
    String packageName,
    String packageId,
    String coachId,
  }) {
    return ConsultationTrainerInstanceModel(
      consultationId: consultationId ?? this.consultationId,
      coachName: coachName ?? this.coachName,
      coachUrl: coachUrl ?? this.coachUrl,
      packageName: packageName ?? this.packageName,
      packageId: packageId ?? this.packageId,
      coachId: coachId ?? this.coachId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'consultationId': consultationId,
      'coachName': coachName,
      'coachUrl': coachUrl,
      'packageName': packageName,
      'packageId': packageId,
      'coachId': coachId,
    };
  }

  factory ConsultationTrainerInstanceModel.fromMap(Map<String, dynamic> map) {
    return ConsultationTrainerInstanceModel(
      consultationId: map['consultationId'] ?? '',
      coachName: map['coachName'] ?? '',
      coachUrl: map['coachUrl'] ?? '',
      packageName: map['packageName'] ?? '',
      packageId: map['packageId'] ?? '',
      coachId: map['coachId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsultationTrainerInstanceModel.fromJson(String source) =>
      ConsultationTrainerInstanceModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      consultationId,
      coachName,
      coachUrl,
      packageName,
      packageId,
      coachId,
    ];
  }
}
