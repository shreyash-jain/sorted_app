import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClassModel extends Equatable {
  int id;
  String name;
  String description;
  int shareId;
  String shareableLink;
  int type;
  int feeAdded;
  String imageUrl;
  String coverUrl;
  DateTime startDate;
  DateTime endDate;
  int numClients;
  int hasTimeTable;
  int hasAdvancedTimeTable;
  DateTime startTime;
  DateTime endTime;
  int maxClients;
  String expertName;
  String instituteName;
  String timeTableWeekdays;
  String topics;
  ClassModel({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.shareId = 0,
    this.shareableLink = '',
    this.type = 0,
    this.feeAdded = 0,
    this.imageUrl = '',
    this.coverUrl = '',
    this.startDate,
    this.endDate,
    this.numClients = 0,
    this.hasTimeTable = 0,
    this.hasAdvancedTimeTable = 0,
    this.startTime,
    this.endTime,
    this.maxClients = 0,
    this.expertName = '',
    this.instituteName = '',
    this.timeTableWeekdays = '',
    this.topics = '',
  });

  ClassModel copyWith({
    int id,
    String name,
    String description,
    int shareId,
    String shareableLink,
    int type,
    int feeAdded,
    String imageUrl,
    String coverUrl,
    DateTime startDate,
    DateTime endDate,
    int numClients,
    int hasTimeTable,
    int hasAdvancedTimeTable,
    DateTime startTime,
    DateTime endTime,
    int maxClients,
    String expertName,
    String instituteName,
    String timeTableWeekdays,
    String topics,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shareId: shareId ?? this.shareId,
      shareableLink: shareableLink ?? this.shareableLink,
      type: type ?? this.type,
      feeAdded: feeAdded ?? this.feeAdded,
      imageUrl: imageUrl ?? this.imageUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numClients: numClients ?? this.numClients,
      hasTimeTable: hasTimeTable ?? this.hasTimeTable,
      hasAdvancedTimeTable: hasAdvancedTimeTable ?? this.hasAdvancedTimeTable,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      maxClients: maxClients ?? this.maxClients,
      expertName: expertName ?? this.expertName,
      instituteName: instituteName ?? this.instituteName,
      timeTableWeekdays: timeTableWeekdays ?? this.timeTableWeekdays,
      topics: topics ?? this.topics,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shareId': shareId,
      'shareableLink': shareableLink,
      'type': type,
      'feeAdded': feeAdded,
      'imageUrl': imageUrl,
      'coverUrl': coverUrl,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'numClients': numClients,
      'hasTimeTable': hasTimeTable,
      'hasAdvancedTimeTable': hasAdvancedTimeTable,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'maxClients': maxClients,
      'expertName': expertName,
      'instituteName': instituteName,
      'timeTableWeekdays': timeTableWeekdays,
      'topics': topics,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      shareId: map['shareId'] ?? 0,
      shareableLink: map['shareableLink'] ?? '',
      type: map['type'] ?? 0,
      feeAdded: map['feeAdded'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      numClients: map['numClients'] ?? 0,
      hasTimeTable: map['hasTimeTable'] ?? 0,
      hasAdvancedTimeTable: map['hasAdvancedTimeTable'] ?? 0,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime']),
      maxClients: map['maxClients'] ?? 0,
      expertName: map['expertName'] ?? '',
      instituteName: map['instituteName'] ?? '',
      timeTableWeekdays: map['timeTableWeekdays'] ?? '',
      topics: map['topics'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassModel.fromJson(String source) =>
      ClassModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      description,
      shareId,
      shareableLink,
      type,
      feeAdded,
      imageUrl,
      coverUrl,
      startDate,
      endDate,
      numClients,
      hasTimeTable,
      hasAdvancedTimeTable,
      startTime,
      endTime,
      maxClients,
      expertName,
      instituteName,
      timeTableWeekdays,
      topics,
    ];
  }
}
