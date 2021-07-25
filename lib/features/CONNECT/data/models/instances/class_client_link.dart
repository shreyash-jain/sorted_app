import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassClientLink extends Equatable {
  final String classId;
  final String className;
  final String clientId;
  final String clientName;
  final String clientImageUrl;
  ClassClientLink({
    this.classId = '',
    this.className = '',
    this.clientId = '',
    this.clientName = '',
    this.clientImageUrl = '',
  });

  ClassClientLink copyWith({
    String classId,
    String className,
    String clientId,
    String clientName,
    String clientImageUrl,
  }) {
    return ClassClientLink(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientImageUrl: clientImageUrl ?? this.clientImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className,
      'clientId': clientId,
      'clientName': clientName,
      'clientImageUrl': clientImageUrl,
    };
  }

  factory ClassClientLink.fromMap(Map<String, dynamic> map) {
    return ClassClientLink(
      classId: map['classId'] ?? '',
      className: map['className'] ?? '',
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientImageUrl: map['clientImageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassClientLink.fromJson(String source) => ClassClientLink.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      classId,
      className,
      clientId,
      clientName,
      clientImageUrl,
    ];
  }
}
