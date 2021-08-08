import 'dart:convert';

import 'package:equatable/equatable.dart';

class NoticeboardMessage extends Equatable {
  String id;
  int time;
  String message;
  NoticeboardMessage({
    this.id = '',
    this.time = 0,
    this.message = '',
  });
  

  NoticeboardMessage copyWith({
    String id,
    int time,
    String message,
  }) {
    return NoticeboardMessage(
      id: id ?? this.id,
      time: time ?? this.time,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'message': message,
    };
  }

  factory NoticeboardMessage.fromMap(Map<String, dynamic> map) {
    return NoticeboardMessage(
      id: map['id'] ?? '',
      time: map['time'] ?? 0,
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NoticeboardMessage.fromJson(String source) => NoticeboardMessage.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, time, message];
}
