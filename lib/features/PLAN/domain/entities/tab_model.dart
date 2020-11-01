import 'dart:convert';

import 'package:equatable/equatable.dart';

class PlanTabDetails extends Equatable {
  int type;
  String tabName;
  String search;
  String imagePath;
  PlanTabDetails({
    this.type = 0,
    this.tabName = '',
    this.search = '',
    this.imagePath = '',
  });

  PlanTabDetails copyWith({
    int type,
    String tabName,
    String search,
    String imagePath,
  }) {
    return PlanTabDetails(
      type: type ?? this.type,
      tabName: tabName ?? this.tabName,
      search: search ?? this.search,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'tabName': tabName,
      'search': search,
      'imagePath': imagePath,
    };
  }

  factory PlanTabDetails.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlanTabDetails(
      type: map['type'],
      tabName: map['tabName'],
      search: map['search'],
      imagePath: map['imagePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanTabDetails.fromJson(String source) =>
      PlanTabDetails.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [type, tabName, search, imagePath];
}
