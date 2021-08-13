import 'dart:convert';

import 'package:equatable/equatable.dart';

class ReplyModel extends Equatable {
  String id;
  String postId;
  String title;
  String senderName;
  String senderUrl;
  ReplyModel({
    this.id = '',
    this.postId = '',
    this.title = '',
    this.senderName = '',
    this.senderUrl = '',
  });

  ReplyModel copyWith({
    String id,
    String postId,
    String title,
    String senderName,
    String senderUrl,
  }) {
    return ReplyModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      title: title ?? this.title,
      senderName: senderName ?? this.senderName,
      senderUrl: senderUrl ?? this.senderUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'title': title,
      'senderName': senderName,
      'senderUrl': senderUrl,
    };
  }

  factory ReplyModel.fromMap(Map<String, dynamic> map) {
    return ReplyModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      title: map['title'] ?? '',
      senderName: map['senderName'] ?? '',
      senderUrl: map['senderUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplyModel.fromJson(String source) =>
      ReplyModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      postId,
      title,
      senderName,
      senderUrl,
    ];
  }
}
