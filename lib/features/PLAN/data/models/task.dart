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
  //type -> 0 -> task | 1-> event | 2 -> milestone
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
  String taskImageId;
  String coverImageid;
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
    this.taskImageId = "0",
    this.coverImageid = "0",
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
    String taskImageId,
    String coverImageid,
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
      taskImageId: taskImageId ?? this.taskImageId,
      coverImageid: coverImageid ?? this.coverImageid,
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
      'taskImageId': taskImageId,
      'coverImageid': coverImageid,
    };
  }

  

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DateTime start, saved;
    if (map['startDate'] != null) {
      start = DateTime.fromMillisecondsSinceEpoch(map['startDate']);
    } else
      start = DateTime.now();
    if (map['savedTs'] != null) {
      saved = DateTime.fromMillisecondsSinceEpoch(map['savedTs']);
    } else
      saved = DateTime.now();

    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: start,
      deadLine: DateTime.fromMillisecondsSinceEpoch(map['deadLine']),
      priority: map['priority'],
      type: map['type'],
      duration: map['duration'],
      progress: map['progress'],
      savedTs: saved,
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
      taskImageId: map['taskImageId'].toString(),
      coverImageid: map['coverImageid'].toString(),
    );
  }

  factory TaskModel.getRandom(int id) {
    List<String> emojiRandom = [
    '💌',
    '🕳',
    '💣',
    '🛀',
    '🛌',
    '🔪',
    '🏺',
    '🗺',
    '🧭',
    '🧱',
    '💈',
    '🛢',
    '🛎',
    '🧳',
    '⌛',
    '⏳',
    '⌚',
    '⏰',
    '⏱',
    '⏲',
    '🕰',
    '🌡',
    '⛱',
    '🧨',
    '🎈',
    '🎉',
    '🎊',
    '🎎',
    '🎏',
    '🎐',
    '🧧',
    '🎀',
    '🎁',
    '🔮',
    '🧿',
    '🕹',
    '🧸',
    '🖼',
    '🧵',
    '🧶',
    '🛍',
    '📿',
    '💎',
    '📯',
    '🎙',
    '🎚',
    '🎛',
    '📻',
    '📱',
    '📲',
    '☎',
    '📞',
    '📟',
    '📠',
    '🔋',
    '🔌',
    '💻',
    '🖥',
    '🖨',
    '⌨',
    '🖱',
    '🖲',
    '💽',
    '💾',
    '💿',
    '📀',
    '🧮',
    '🎥',
    '🎞',
    '📽',
    '📺',
    '📷',
    '📸',
    '📹',
    '📼',
    '🔍',
    '🔎',
    '🕯',
    '💡',
    '🔦',
    '🏮',
    '📔',
    '📕',
    '📖',
    '📗',
    '📘',
    '📙',
    '📚',
    '📓',
    '📃',
    '📜',
    '📄',
    '📰',
    '🗞',
    '📑',
    '🔖',
    '🏷',
    '💰',
    '💴',
    '💵',
    '💶',
    '💷',
    '💸',
    '💳',
    '🧾',
    '✉',
    '📧',
    '📨',
    '📩',
    '📤',
    '📥',
    '📦',
    '📫',
    '📪',
    '📬',
    '📭',
    '📮',
    '🗳',
    '✏',
    '✒',
    '🖋',
    '🖊',
    '🖌',
    '🖍',
    '📝',
    '📁',
    '📂',
    '🗂',
    '📅',
    '📆',
    '🗒',
    '🗓',
    '📇',
    '📈',
    '📉',
    '📊',
    '📋',
    '📌',
    '📍',
    '📎',
    '🖇',
    '📏',
    '📐',
    '✂',
    '🗃',
    '🗄',
    '🗑',
  ];
    DateTime now = DateTime.now();

    return TaskModel(
      id: id,
      title: faker.job.title(),
      description: faker.lorem.sentence(),
      startDate: faker.date.dateTime(minYear: 2020, maxYear: 2020),
      deadLine: faker.date.dateTime(minYear: 2021, maxYear: 2021),
      progress: random.decimal(),
      priority: random.decimal(),
      type: 0,
      duration: 0,
      savedTs: now,
      linkedGoals: 0,
      linkedReviews: 0,
      linkedActivities: 0,
      linkedImages: 0,
      linkedTags: 0,
      linkedLogs: 0,
      linkedLinks: 0,
      linkedStatus: 1,
      linkedTodos: 0,
      linkedDependencies: 0,
      taskImageId: emojiRandom[random.integer(140)],
      coverImageid: "0",
    );
  }

  String toJson() => json.encode(toMap());
  String getTable() => "Tasks";
  String getImageTable() => "Tasks_Images";
  String getAttachmentTable() => "Tasks_Attachments";
  String getGoalTable() => "Goals_Tasks";
  String getLinkTable() => "Tasks_Links";
  String getTagTable() => "Tasks_Tags";
  String getLogTable() => "Tasks_Logs";
  String getTodoTable() => "Tasks_Todos";
  String getDependencyTable() => "Tasks_Tasks";
  String getActivityTable() => "Tasks_Activities";
  String getStatusTable() => "Tasks_Status";
  String getReviewTable() => "Tasks_Reviews";
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
      taskImageId,
      coverImageid,
    ];
  }
}
