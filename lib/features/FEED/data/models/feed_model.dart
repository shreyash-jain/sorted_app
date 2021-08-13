import 'dart:convert';

import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  String id;
  String title;
  String subTitle;
  String senderUrl;
  String senderId;
  String senderName;
  DateTime time;
  String feedUrl;
  int feedType;
  int clickAction;
  String feedId;
  PostModel({
    this.id = '',
    this.title = '',
    this.subTitle = '',
    this.senderUrl = '',
    this.senderId = '',
    this.senderName = '',
    this.time,
    this.feedUrl = '',
    this.feedType = 0,
    this.clickAction = 0,
    this.feedId = '',
  });

  PostModel copyWith({
    String id,
    String title,
    String subTitle,
    String senderUrl,
    String senderId,
    String senderName,
    DateTime time,
    String feedUrl,
    int feedType,
    String feedId,
    int clickAction,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      senderUrl: senderUrl ?? this.senderUrl,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      time: time ?? this.time,
      feedUrl: feedUrl ?? this.feedUrl,
      feedType: feedType ?? this.feedType,
      clickAction: clickAction ?? this.clickAction,
      feedId: feedId ?? this.feedId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'senderUrl': senderUrl,
      'senderId': senderId,
      'senderName': senderName,
      'time': time.millisecondsSinceEpoch,
      'feedUrl': feedUrl,
      'feedType': feedType,
      'clickAction': clickAction,
      'feedId': feedId,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      senderUrl: map['senderUrl'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      feedUrl: map['feedUrl'] ?? '',
      feedType: map['feedType'] ?? 0,
      clickAction: map['clickAction'] ?? 0,
      feedId: map['feedId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      title,
      subTitle,
      senderUrl,
      senderId,
      senderName,
      time,
      feedUrl,
      feedType,
      clickAction,
      feedId,
    ];
  }
}
