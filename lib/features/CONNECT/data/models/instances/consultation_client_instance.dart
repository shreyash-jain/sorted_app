import 'dart:convert';

import 'package:equatable/equatable.dart';
//! commom with pro
class ConsultationClientInstanceModel extends Equatable {
  String consultationId;
  String clientName;
  String clientUrl;
  String packageName;
  String packageId;
  String clientId;
  ConsultationClientInstanceModel({
    this.consultationId = '',
    this.clientName = '',
    this.clientUrl = '',
    this.packageName = '',
    this.packageId = '',
    this.clientId = '',
  });

  ConsultationClientInstanceModel copyWith({
    String consultationId,
    String clientName,
    String clientUrl,
    String packageName,
    String packageId,
    String clientId,
  }) {
    return ConsultationClientInstanceModel(
      consultationId: consultationId ?? this.consultationId,
      clientName: clientName ?? this.clientName,
      clientUrl: clientUrl ?? this.clientUrl,
      packageName: packageName ?? this.packageName,
      packageId: packageId ?? this.packageId,
      clientId: clientId ?? this.clientId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'consultationId': consultationId,
      'clientName': clientName,
      'clientUrl': clientUrl,
      'packageName': packageName,
      'packageId': packageId,
      'clientId': clientId,
    };
  }

  factory ConsultationClientInstanceModel.fromMap(Map<String, dynamic> map) {
    return ConsultationClientInstanceModel(
      consultationId: map['consultationId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientUrl: map['clientUrl'] ?? '',
      packageName: map['packageName'] ?? '',
      packageId: map['packageId'] ?? '',
      clientId: map['clientId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsultationClientInstanceModel.fromJson(String source) =>
      ConsultationClientInstanceModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      consultationId,
      clientName,
      clientUrl,
      packageName,
      packageId,
      clientId,
    ];
  }
}
