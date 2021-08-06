import 'dart:convert';

import 'package:equatable/equatable.dart';

class ConsultationTrainerInstanceModel extends Equatable {
  String consultationId;
  String coachName;
  String coachUrl;
  String packageName;
  String packageId;
  ConsultationTrainerInstanceModel({
    this.consultationId = '',
    this.coachName = '',
    this.coachUrl = '',
    this.packageName = '',
    this.packageId = '',
  });

  ConsultationTrainerInstanceModel copyWith({
    String consultationId,
    String coachName,
    String coachUrl,
    String packageName,
    String packageId,
  }) {
    return ConsultationTrainerInstanceModel(
      consultationId: consultationId ?? this.consultationId,
      coachName: coachName ?? this.coachName,
      coachUrl: coachUrl ?? this.coachUrl,
      packageName: packageName ?? this.packageName,
      packageId: packageId ?? this.packageId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'consultationId': consultationId,
      'coachName': coachName,
      'coachUrl': coachUrl,
      'packageName': packageName,
      'packageId': packageId,
    };
  }

  factory ConsultationTrainerInstanceModel.fromMap(Map<String, dynamic> map) {
    return ConsultationTrainerInstanceModel(
      consultationId: map['consultationId'] ?? '',
      coachName: map['coachName'] ?? '',
      coachUrl: map['coachUrl'] ?? '',
      packageName: map['packageName'] ?? '',
      packageId: map['packageId'] ?? '',
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
    ];
  }
}
