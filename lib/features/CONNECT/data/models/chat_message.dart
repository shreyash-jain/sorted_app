import 'dart:convert';


import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sorted/features/CONNECT/domain/entities/chat_message_entity.dart';

class ChatMessage extends Equatable {
  String id;
  String text;
  int type;
  String time;
  String senderName;
  String url;
  String uid;
  ChatMessage({
    this.id = '',
    this.text = '',
    this.type = 0,
    this.time = '',
    this.senderName = '',
    this.url = '',
    this.uid = '',
  });

  ChatMessage copyWith({
    String id,
    String text,
    int type,
    String time,
    String senderName,
    String url,
    String uid,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      time: time ?? this.time,
      senderName: senderName ?? this.senderName,
      url: url ?? this.url,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'time': time,
      'senderName': senderName,
      'url': url,
      'uid': uid,
    };
  }

  ChatMessageEntitiy toEntity(String clientID) {

    
    return ChatMessageEntitiy(
        id: id,
        text: text,
        type: type,
        senderName: senderName,
        time: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(time)),
        url: url,
        isSender: (uid == clientID));
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {


    return ChatMessage(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      type: map['type'] ?? 0,
      time: map['time'] ?? '',
      senderName: map['senderName'] ?? '',
      url: map['url'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  factory ChatMessage.fromEntity(ChatMessageEntitiy entitiy) {
    return ChatMessage(
      id: entitiy.id ?? '',
      text: entitiy.text ?? '',
      senderName: entitiy.senderName,
      type: entitiy.type ?? 0,
      time: entitiy.time ?? '',
      url: entitiy.url ?? '',
      uid: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      text,
      type,
      time,
      senderName,
      url,
      uid,
    ];
  }
}
