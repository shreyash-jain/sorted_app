import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

class GoalModel extends Equatable {
  int id;
  String title;
  String description;
  DateTime startDate;
  DateTime deadLine;
  double progress;
  String vision;
  int linkedTasks;
  DateTime savedTs;
  int linkedImages;
  int linkedLinks;
  int linkedStatus;
  int linkedLogs;
  int linkedTracks;
  int linkedNotes;
  GoalModel({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.startDate,
    this.deadLine,
    this.progress = 0.0,
    this.vision = '',
    this.linkedTasks = 0,
    this.savedTs,
    this.linkedImages = 0,
    this.linkedLinks = 0,
    this.linkedStatus = 0,
    this.linkedLogs = 0,
    this.linkedTracks = 0,
    this.linkedNotes = 0,
  });
  

  GoalModel copyWith({
    int id,
    String title,
    String description,
    DateTime startDate,
    DateTime deadLine,
    double progress,
    String vision,
    int linkedTasks,
    DateTime savedTs,
    int linkedImages,
    int linkedLinks,
    int linkedStatus,
    int linkedLogs,
    int linkedTracks,
    int linkedNotes,
  }) {
    return GoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      deadLine: deadLine ?? this.deadLine,
      progress: progress ?? this.progress,
      vision: vision ?? this.vision,
      linkedTasks: linkedTasks ?? this.linkedTasks,
      savedTs: savedTs ?? this.savedTs,
      linkedImages: linkedImages ?? this.linkedImages,
      linkedLinks: linkedLinks ?? this.linkedLinks,
      linkedStatus: linkedStatus ?? this.linkedStatus,
      linkedLogs: linkedLogs ?? this.linkedLogs,
      linkedTracks: linkedTracks ?? this.linkedTracks,
      linkedNotes: linkedNotes ?? this.linkedNotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate?.millisecondsSinceEpoch,
      'deadLine': deadLine?.millisecondsSinceEpoch,
      'progress': progress,
      'vision': vision,
      'linkedTasks': linkedTasks,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'linkedImages': linkedImages,
      'linkedLinks': linkedLinks,
      'linkedStatus': linkedStatus,
      'linkedLogs': linkedLogs,
      'linkedTracks': linkedTracks,
      'linkedNotes': linkedNotes,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return GoalModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      deadLine: DateTime.fromMillisecondsSinceEpoch(map['deadLine']),
      progress: map['progress'],
      vision: map['vision'],
      linkedTasks: map['linkedTasks'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      linkedImages: map['linkedImages'],
      linkedLinks: map['linkedLinks'],
      linkedStatus: map['linkedStatus'],
      linkedLogs: map['linkedLogs'],
      linkedTracks: map['linkedTracks'],
      linkedNotes: map['linkedNotes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalModel.fromJson(String source) => GoalModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      startDate,
      deadLine,
      progress,
      vision,
      linkedTasks,
      savedTs,
      linkedImages,
      linkedLinks,
      linkedStatus,
      linkedLogs,
      linkedTracks,
      linkedNotes,
    ];
  }
}
