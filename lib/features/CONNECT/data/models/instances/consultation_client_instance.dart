import 'dart:convert';

import 'package:equatable/equatable.dart';

class ConsultationClientInstanceModel extends Equatable {
  String consultationId;
  String clientName;
  String clientUrl;
  String packageName;
  String packageId;
  ConsultationClientInstanceModel({
    this.consultationId = '',
    this.clientName = '',
    this.clientUrl = '',
    this.packageName = '',
    this.packageId = '',
  });

  ConsultationClientInstanceModel copyWith({
    String consultationId,
    String clientName,
    String clientUrl,
    String packageName,
    String packageId,
  }) {
    return ConsultationClientInstanceModel(
      consultationId: consultationId ?? this.consultationId,
      clientName: clientName ?? this.clientName,
      clientUrl: clientUrl ?? this.clientUrl,
      packageName: packageName ?? this.packageName,
      packageId: packageId ?? this.packageId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'consultationId': consultationId,
      'clientName': clientName,
      'clientUrl': clientUrl,
      'packageName': packageName,
      'packageId': packageId,
    };
  }

  factory ConsultationClientInstanceModel.fromMap(Map<String, dynamic> map) {
    return ConsultationClientInstanceModel(
      consultationId: map['consultationId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientUrl: map['clientUrl'] ?? '',
      packageName: map['packageName'] ?? '',
      packageId: map['packageId'] ?? '',
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
    ];
  }
}
