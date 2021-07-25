import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ClassModel extends Equatable {
  String id;
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
  String linkedTracksIds;
  int mon;
  int tue;
  int wed;
  int thu;
  int fri;
  int sat;
  int sun;
  DateTime monStart;
  DateTime monEnd;
  DateTime tueStart;
  DateTime tueEnd;
  DateTime wedStart;
  DateTime wedEnd;
  DateTime thuStart;
  DateTime thuEnd;
  DateTime friStart;
  DateTime friEnd;
  DateTime satEnd;
  DateTime satStart;
  DateTime sunEnd;
  DateTime sunStart;
  DateTime defaultEnd;
  DateTime defaultStart;
  String coachUid;
  String coachName;
  int createdAt;
  List<String> membersId;
  List<String> membersName;
  List<String> membersImage;
  List<String> requestIds;
  List<String> requestName;
  List<String> requestImage;
  String recentMessage;
  String recentMessageSenderId;
  List<String> trackId;

  ClassModel({
    this.id = '',
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
    this.linkedTracksIds = '',
    this.mon = 0,
    this.tue = 0,
    this.wed = 0,
    this.thu = 0,
    this.fri = 0,
    this.sat = 0,
    this.sun = 0,
    this.monStart,
    this.monEnd,
    this.tueStart,
    this.tueEnd,
    this.wedStart,
    this.wedEnd,
    this.thuStart,
    this.thuEnd,
    this.friStart,
    this.friEnd,
    this.satEnd,
    this.satStart,
    this.sunEnd,
    this.sunStart,
    this.defaultEnd,
    this.defaultStart,
    this.coachUid = '',
    this.coachName = '',
    this.createdAt = 0,
    this.membersId = const [],
    this.membersName = const [],
    this.membersImage = const [],
    this.requestIds = const [],
    this.requestName = const [],
    this.requestImage = const [],
    this.recentMessage = '',
    this.recentMessageSenderId = '',
    this.trackId = const [],
  });

  ClassModel copyWith({
    String id,
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
    String linkedTracksIds,
    int mon,
    int tue,
    int wed,
    int thu,
    int fri,
    int sat,
    int sun,
    DateTime monStart,
    DateTime monEnd,
    DateTime tueStart,
    DateTime tueEnd,
    DateTime wedStart,
    DateTime wedEnd,
    DateTime thuStart,
    DateTime thuEnd,
    DateTime friStart,
    DateTime friEnd,
    DateTime satEnd,
    DateTime satStart,
    DateTime sunEnd,
    DateTime sunStart,
    DateTime defaultEnd,
    DateTime defaultStart,
    String coachUid,
    String coachName,
    int createdAt,
    List<String> membersId,
    List<String> membersName,
    List<String> membersImage,
    List<String> requestIds,
    List<String> requestName,
    List<String> requestImage,
    String recentMessage,
    String recentMessageSenderId,
    List<String> trackId,
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
      linkedTracksIds: linkedTracksIds ?? this.linkedTracksIds,
      mon: mon ?? this.mon,
      tue: tue ?? this.tue,
      wed: wed ?? this.wed,
      thu: thu ?? this.thu,
      fri: fri ?? this.fri,
      sat: sat ?? this.sat,
      sun: sun ?? this.sun,
      monStart: monStart ?? this.monStart,
      monEnd: monEnd ?? this.monEnd,
      tueStart: tueStart ?? this.tueStart,
      tueEnd: tueEnd ?? this.tueEnd,
      wedStart: wedStart ?? this.wedStart,
      wedEnd: wedEnd ?? this.wedEnd,
      thuStart: thuStart ?? this.thuStart,
      thuEnd: thuEnd ?? this.thuEnd,
      friStart: friStart ?? this.friStart,
      friEnd: friEnd ?? this.friEnd,
      satEnd: satEnd ?? this.satEnd,
      satStart: satStart ?? this.satStart,
      sunEnd: sunEnd ?? this.sunEnd,
      sunStart: sunStart ?? this.sunStart,
      defaultEnd: defaultEnd ?? this.defaultEnd,
      defaultStart: defaultStart ?? this.defaultStart,
      coachUid: coachUid ?? this.coachUid,
      coachName: coachName ?? this.coachName,
      createdAt: createdAt ?? this.createdAt,
      membersId: membersId ?? this.membersId,
      membersName: membersName ?? this.membersName,
      membersImage: membersImage ?? this.membersImage,
      requestIds: requestIds ?? this.requestIds,
      requestName: requestName ?? this.requestName,
      requestImage: requestImage ?? this.requestImage,
      recentMessage: recentMessage ?? this.recentMessage,
      recentMessageSenderId:
          recentMessageSenderId ?? this.recentMessageSenderId,
      trackId: trackId ?? this.trackId,
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
      'startDate': DateTime.now().microsecondsSinceEpoch,
      'endDate': DateTime.now().add(Duration(days: 365)).microsecondsSinceEpoch,
      'numClients': numClients,
      'hasTimeTable': hasTimeTable,
      'hasAdvancedTimeTable': hasAdvancedTimeTable,
      'startTime': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'endTime': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'maxClients': maxClients,
      'expertName': expertName,
      'instituteName': instituteName,
      'timeTableWeekdays': timeTableWeekdays,
      'topics': topics,
      'linkedTracksIds': linkedTracksIds,
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'sat': sat,
      'sun': sun,
      'monStart': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'monEnd': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'tueStart': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'tueEnd': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'wedStart': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'wedEnd': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'thuStart': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'thuEnd': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'friStart': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'friEnd': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'satEnd': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'satStart': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'sunEnd': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'sunStart': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'defaultEnd': DateTime(2000, 1, 1, 8, 00).microsecondsSinceEpoch,
      'defaultStart': DateTime(2000, 1, 1, 7, 00).microsecondsSinceEpoch,
      'coachUid': coachUid,
      'coachName': coachName,
      'createdAt': createdAt,
      'membersId': membersId,
      'membersName': membersName,
      'membersImage': membersImage,
      'requestIds': requestIds,
      'requestName': requestName,
      'requestImage': requestImage,
      'recentMessage': recentMessage,
      'recentMessageSenderId': recentMessageSenderId,
      'trackId': trackId,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? '',
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
      linkedTracksIds: map['linkedTracksIds'] ?? '',
      mon: map['mon'] ?? 0,
      tue: map['tue'] ?? 0,
      wed: map['wed'] ?? 0,
      thu: map['thu'] ?? 0,
      fri: map['fri'] ?? 0,
      sat: map['sat'] ?? 0,
      sun: map['sun'] ?? 0,
      monStart: DateTime.fromMillisecondsSinceEpoch(map['monStart']),
      monEnd: DateTime.fromMillisecondsSinceEpoch(map['monEnd']),
      tueStart: DateTime.fromMillisecondsSinceEpoch(map['tueStart']),
      tueEnd: DateTime.fromMillisecondsSinceEpoch(map['tueEnd']),
      wedStart: DateTime.fromMillisecondsSinceEpoch(map['wedStart']),
      wedEnd: DateTime.fromMillisecondsSinceEpoch(map['wedEnd']),
      thuStart: DateTime.fromMillisecondsSinceEpoch(map['thuStart']),
      thuEnd: DateTime.fromMillisecondsSinceEpoch(map['thuEnd']),
      friStart: DateTime.fromMillisecondsSinceEpoch(map['friStart']),
      friEnd: DateTime.fromMillisecondsSinceEpoch(map['friEnd']),
      satEnd: DateTime.fromMillisecondsSinceEpoch(map['satEnd']),
      satStart: DateTime.fromMillisecondsSinceEpoch(map['satStart']),
      sunEnd: DateTime.fromMillisecondsSinceEpoch(map['sunEnd']),
      sunStart: DateTime.fromMillisecondsSinceEpoch(map['sunStart']),
      defaultEnd: DateTime.fromMillisecondsSinceEpoch(map['defaultEnd']),
      defaultStart: DateTime.fromMillisecondsSinceEpoch(map['defaultStart']),
      coachUid: map['coachUid'] ?? '',
      coachName: map['coachName'] ?? '',
      createdAt: map['createdAt'] ?? 0,
      membersId: List<String>.from(map['membersId'] ?? const []),
      membersName: List<String>.from(map['membersName'] ?? const []),
      membersImage: List<String>.from(map['membersImage'] ?? const []),
      requestIds: List<String>.from(map['requestIds'] ?? const []),
      requestName: List<String>.from(map['requestName'] ?? const []),
      requestImage: List<String>.from(map['requestImage'] ?? const []),
      recentMessage: map['recentMessage'] ?? '',
      recentMessageSenderId: map['recentMessageSenderId'] ?? '',
      trackId: List<String>.from(map['trackId'] ?? const []),
    );
  }

  factory ClassModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
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
      linkedTracksIds: map['linkedTracksIds'] ?? '',
      mon: map['mon'] ?? 0,
      tue: map['tue'] ?? 0,
      wed: map['wed'] ?? 0,
      thu: map['thu'] ?? 0,
      fri: map['fri'] ?? 0,
      sat: map['sat'] ?? 0,
      sun: map['sun'] ?? 0,
      monStart: DateTime.fromMillisecondsSinceEpoch(map['monStart']),
      monEnd: DateTime.fromMillisecondsSinceEpoch(map['monEnd']),
      tueStart: DateTime.fromMillisecondsSinceEpoch(map['tueStart']),
      tueEnd: DateTime.fromMillisecondsSinceEpoch(map['tueEnd']),
      wedStart: DateTime.fromMillisecondsSinceEpoch(map['wedStart']),
      wedEnd: DateTime.fromMillisecondsSinceEpoch(map['wedEnd']),
      thuStart: DateTime.fromMillisecondsSinceEpoch(map['thuStart']),
      thuEnd: DateTime.fromMillisecondsSinceEpoch(map['thuEnd']),
      friStart: DateTime.fromMillisecondsSinceEpoch(map['friStart']),
      friEnd: DateTime.fromMillisecondsSinceEpoch(map['friEnd']),
      satEnd: DateTime.fromMillisecondsSinceEpoch(map['satEnd']),
      satStart: DateTime.fromMillisecondsSinceEpoch(map['satStart']),
      sunEnd: DateTime.fromMillisecondsSinceEpoch(map['sunEnd']),
      sunStart: DateTime.fromMillisecondsSinceEpoch(map['sunStart']),
      defaultEnd: DateTime.fromMillisecondsSinceEpoch(map['defaultEnd']),
      defaultStart: DateTime.fromMillisecondsSinceEpoch(map['defaultStart']),
      coachUid: map['coachUid'] ?? '',
      coachName: map['coachName'] ?? '',
      createdAt: map['createdAt'] ?? 0,
      membersId: List<String>.from(map['membersId'] ?? const []),
      membersName: List<String>.from(map['membersName'] ?? const []),
      membersImage: List<String>.from(map['membersImage'] ?? const []),
      requestIds: List<String>.from(map['requestIds'] ?? const []),
      requestName: List<String>.from(map['requestName'] ?? const []),
      requestImage: List<String>.from(map['requestImage'] ?? const []),
      recentMessage: map['recentMessage'] ?? '',
      recentMessageSenderId: map['recentMessageSenderId'] ?? '',
      trackId: List<String>.from(map['trackId'] ?? const []),
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
      linkedTracksIds,
      mon,
      tue,
      wed,
      thu,
      fri,
      sat,
      sun,
      monStart,
      monEnd,
      tueStart,
      tueEnd,
      wedStart,
      wedEnd,
      thuStart,
      thuEnd,
      friStart,
      friEnd,
      satEnd,
      satStart,
      sunEnd,
      sunStart,
      defaultEnd,
      defaultStart,
      coachUid,
      coachName,
      createdAt,
      membersId,
      membersName,
      membersImage,
      requestIds,
      requestName,
      requestImage,
      recentMessage,
      recentMessageSenderId,
      trackId,
    ];
  }
}
