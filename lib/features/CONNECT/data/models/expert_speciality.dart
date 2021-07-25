import 'dart:convert';

import 'package:equatable/equatable.dart';

class ExpertSpeciality extends Equatable {
  int id;
  String speciality;
  ExpertSpeciality({
    this.id = 0,
    this.speciality = '',
  });

  ExpertSpeciality copyWith({
    int id,
    String speciality,
  }) {
    return ExpertSpeciality(
      id: id ?? this.id,
      speciality: speciality ?? this.speciality,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'speciality': speciality,
    };
  }

  factory ExpertSpeciality.fromMap(Map<String, dynamic> map) {
    return ExpertSpeciality(
      id: map['id'] ?? 0,
      speciality: map['speciality'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpertSpeciality.fromJson(String source) => ExpertSpeciality.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, speciality];
}
