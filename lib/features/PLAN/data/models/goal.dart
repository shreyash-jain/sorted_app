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
  int markCompleted;
  String coverImageId;
  String goalImageId;
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
    this.markCompleted = 0,
    this.coverImageId = '',
    this.goalImageId = '',
  });

  @override
  // TODO: implement props
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
      markCompleted,
      coverImageId,
      goalImageId,
    ];
  }

  factory GoalModel.getRandom(int id) {
    DateTime now = DateTime.now();

    return GoalModel(
      id: id,
      title: faker.job.title(),
      description: faker.lorem.sentence(),
      startDate: faker.date.dateTime(minYear: 2020, maxYear: 2020),
      deadLine: faker.date.dateTime(minYear: 2021, maxYear: 2021),
      progress: random.decimal(),
      vision: faker.lorem.sentence(),
      linkedTasks: 0,
      savedTs: now,
      linkedImages: 0,
      linkedLinks: 0,
      linkedStatus: 0,
      linkedLogs: 0,
      linkedTracks: 0,
      linkedNotes: 0,
      coverImageId: "0",
      goalImageId: "0",
    );
  }

  String getTable() => "Goals";
  String getTableLinkImages() => "Goals_Images";
  String getTableLinkLinks() => "Goals_Links";
  String getTableLinkTags() => "Goals_Tags";
  String getTableLinkAttachment() => "Goals_Attachments";
  String getTableLinktextbox() => "Goals_Textboxes";
  String getTableLinkTasks() => "Goals_Tasks";
  String getTableLinkLogs() => "Goals_Logs";
  String getTableLinkStatus() => "Goals_Status";

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
    int markCompleted,
    String coverImageId,
    String goalImageId,
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
      markCompleted: markCompleted ?? this.markCompleted,
      coverImageId: coverImageId ?? this.coverImageId,
      goalImageId: goalImageId ?? this.goalImageId,
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
      'markCompleted': markCompleted,
      'coverImageId': coverImageId,
      'goalImageId': goalImageId,
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
      markCompleted: map['markCompleted'],
      coverImageId: map['coverImageId'],
      goalImageId: map['goalImageId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalModel.fromJson(String source) =>
      GoalModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
