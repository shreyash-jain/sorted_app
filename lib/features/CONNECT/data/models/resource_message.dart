import 'dart:convert';

import 'package:equatable/equatable.dart';

class ResourceMessage extends Equatable {
  String id;
  int time;
  int type;
  String text;
  String resourceUrl;
  String resourceId;
  ResourceMessage({
    this.id = '',
    this.time = 0,
    this.type = 0,
    this.text = '',
    this.resourceUrl = '',
    this.resourceId = '',
  });

  ResourceMessage copyWith({
    String id,
    int time,
    int type,
    String text,
    String resourceUrl,
    String resourceId,
  }) {
    return ResourceMessage(
      id: id ?? this.id,
      time: time ?? this.time,
      type: type ?? this.type,
      text: text ?? this.text,
      resourceUrl: resourceUrl ?? this.resourceUrl,
      resourceId: resourceId ?? this.resourceId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'type': type,
      'text': text,
      'resourceUrl': resourceUrl,
      'resourceId': resourceId,
    };
  }

  factory ResourceMessage.fromMap(Map<String, dynamic> map) {
    return ResourceMessage(
      id: map['id'] ?? '',
      time: map['time'] ?? 0,
      type: map['type'] ?? 0,
      text: map['text'] ?? '',
      resourceUrl: map['resourceUrl'] ?? '',
      resourceId: map['resourceId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResourceMessage.fromJson(String source) => ResourceMessage.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      time,
      type,
      text,
      resourceUrl,
      resourceId,
    ];
  }
}
