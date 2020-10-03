import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

class TaskModel extends Equatable {
  int id;
  String title;
  String description;
  DateTime startDate;
  DateTime deadLine;
  double priority;
  int type;
  double duration;
  double progress;
  DateTime savedTs;
  int linkedGoals;
  int linkedReviews;
  int linkedActivities;
  int linkedImages;
  int linkedTags;
  int linkedLogs;
  int linkedLinks;
  int linkedStatus;
  int linkedTodos;
  int linkedDependencies;
  TaskModel({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.startDate,
    this.deadLine,
    this.priority = 0.0,
    this.type = 0,
    this.duration = 0.0,
    this.progress = 0.0,
    this.savedTs,
    this.linkedGoals = 0,
    this.linkedReviews = 0,
    this.linkedActivities = 0,
    this.linkedImages = 0,
    this.linkedTags = 0,
    this.linkedLogs = 0,
    this.linkedLinks = 0,
    this.linkedStatus = 0,
    this.linkedTodos = 0,
    this.linkedDependencies = 0,
  });

  TaskModel copyWith({
    int id,
    String title,
    String description,
    DateTime startDate,
    DateTime deadLine,
    double priority,
    int type,
    double duration,
    double progress,
    DateTime savedTs,
    int linkedGoals,
    int linkedReviews,
    int linkedActivities,
    int linkedImages,
    int linkedTags,
    int linkedLogs,
    int linkedLinks,
    int linkedStatus,
    int linkedTodos,
    int linkedDependencies,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      deadLine: deadLine ?? this.deadLine,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      savedTs: savedTs ?? this.savedTs,
      linkedGoals: linkedGoals ?? this.linkedGoals,
      linkedReviews: linkedReviews ?? this.linkedReviews,
      linkedActivities: linkedActivities ?? this.linkedActivities,
      linkedImages: linkedImages ?? this.linkedImages,
      linkedTags: linkedTags ?? this.linkedTags,
      linkedLogs: linkedLogs ?? this.linkedLogs,
      linkedLinks: linkedLinks ?? this.linkedLinks,
      linkedStatus: linkedStatus ?? this.linkedStatus,
      linkedTodos: linkedTodos ?? this.linkedTodos,
      linkedDependencies: linkedDependencies ?? this.linkedDependencies,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate?.millisecondsSinceEpoch,
      'deadLine': deadLine?.millisecondsSinceEpoch,
      'priority': priority,
      'type': type,
      'duration': duration,
      'progress': progress,
      'savedTs': savedTs?.millisecondsSinceEpoch,
      'linkedGoals': linkedGoals,
      'linkedReviews': linkedReviews,
      'linkedActivities': linkedActivities,
      'linkedImages': linkedImages,
      'linkedTags': linkedTags,
      'linkedLogs': linkedLogs,
      'linkedLinks': linkedLinks,
      'linkedStatus': linkedStatus,
      'linkedTodos': linkedTodos,
      'linkedDependencies': linkedDependencies,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      deadLine: DateTime.fromMillisecondsSinceEpoch(map['deadLine']),
      priority: map['priority'],
      type: map['type'],
      duration: map['duration'],
      progress: map['progress'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
      linkedGoals: map['linkedGoals'],
      linkedReviews: map['linkedReviews'],
      linkedActivities: map['linkedActivities'],
      linkedImages: map['linkedImages'],
      linkedTags: map['linkedTags'],
      linkedLogs: map['linkedLogs'],
      linkedLinks: map['linkedLinks'],
      linkedStatus: map['linkedStatus'],
      linkedTodos: map['linkedTodos'],
      linkedDependencies: map['linkedDependencies'],
    );
  }
  factory TaskModel.makeRandomTask(int type) {
    DateTime now = DateTime.now();
    

    return TaskModel(
      id: now.millisecondsSinceEpoch,
      title: faker.job.title(),
      description: faker.lorem.sentence(),
      startDate: now,
      deadLine: faker.date.dateTime(minYear: 2019,maxYear: 2021),
      priority: random.decimal(scale: 1,min:0),
      type: 0,
      duration: random.integer(240).toDouble(),
      progress: random.decimal(scale: 1,min:0),
      savedTs: now,
      linkedGoals: 0,
      linkedReviews: 0,
      linkedActivities: 0,
      linkedImages: 0,
      linkedTags: 0,
      linkedLogs: 0,
      linkedLinks: 0,
      linkedStatus: 0,
      linkedTodos:0,
      linkedDependencies: 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

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
      priority,
      type,
      duration,
      progress,
      savedTs,
      linkedGoals,
      linkedReviews,
      linkedActivities,
      linkedImages,
      linkedTags,
      linkedLogs,
      linkedLinks,
      linkedStatus,
      linkedTodos,
      linkedDependencies,
    ];
  }
}
