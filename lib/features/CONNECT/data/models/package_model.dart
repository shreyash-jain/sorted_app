import 'dart:convert';

import 'package:equatable/equatable.dart';

//! same at pro

/// type ->
/// 0-> one time
/// 1-> one week
/// 2-> one month
/// 3-> three months
///
///
/// category ->
///  0-> yoga
/// 1-> fitness
/// 2-> nutrition
class ConsultationPackageModel extends Equatable {
  String id;
  String name;
  List<int> days;
  int type;
  int category;
  int perSessionPrice;
  int numClients;
  String imageUrl;
  String coachId;
  String coachName;
  String topics;
  String dynamicLink;
  String description;
  

  ConsultationPackageModel({
    this.id = '',
    this.name = '',
    this.days = const [],
    this.type = 0,
    this.category = 0,
    this.perSessionPrice = 0,
    this.numClients = 0,
    this.imageUrl = '',
    this.coachId = '',
    this.coachName = '',
    this.topics = '',
    this.dynamicLink = '',
    this.description = '',
  });

  ConsultationPackageModel copyWith({
     String id,
    String name,
    List<int> days,
    int type,
    int category,
    int perSessionPrice,
    int numClients,
    String imageUrl,
    String coachId,
    String coachName,
    String topics,
    String dynamicLink,
    String description,
  }) {
    return ConsultationPackageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
      type: type ?? this.type,
      category: category ?? this.category,
      perSessionPrice: perSessionPrice ?? this.perSessionPrice,
      numClients: numClients ?? this.numClients,
      imageUrl: imageUrl ?? this.imageUrl,
      coachId: coachId ?? this.coachId,
      coachName: coachName ?? this.coachName,
      topics: topics ?? this.topics,
      dynamicLink: dynamicLink ?? this.dynamicLink,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'days': days,
      'type': type,
      'category': category,
      'perSessionPrice': perSessionPrice,
      'numClients': numClients,
      'imageUrl': imageUrl,
      'coachId': coachId,
      'coachName': coachName,
      'topics': topics,
      'dynamicLink': dynamicLink,
      'description': description,
    };
  }

  factory ConsultationPackageModel.fromMap(Map<String, dynamic> map) {
    return ConsultationPackageModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      days: List<int>.from(map['days'] ?? const []),
      type: map['type'] ?? 0,
      category: map['category'] ?? 0,
      perSessionPrice: map['perSessionPrice'] ?? 0,
      numClients: map['numClients'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      coachId: map['coachId'] ?? '',
      coachName: map['coachName'] ?? '',
      topics: map['topics'] ?? '',
      dynamicLink: map['dynamicLink'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsultationPackageModel.fromJson(String source) =>
      ConsultationPackageModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      days,
      type,
      category,
      perSessionPrice,
      numClients,
      imageUrl,
      coachId,
      coachName,
      topics,
      dynamicLink,
      description,
    ];
  }
}
