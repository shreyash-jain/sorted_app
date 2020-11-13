import 'dart:convert';

import 'package:equatable/equatable.dart';

class YoutubeBlock extends Equatable {
  int id;
  int savedTs;
  String videoId;
  String title;
  YoutubeBlock({
    this.id = 0,
    this.savedTs = 0,
    this.videoId = '',
    this.title = '',
  });
  

  YoutubeBlock copyWith({
    int id,
    int savedTs,
    String videoId,
    String title,
  }) {
    return YoutubeBlock(
      id: id ?? this.id,
      savedTs: savedTs ?? this.savedTs,
      videoId: videoId ?? this.videoId,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savedTs': savedTs,
      'videoId': videoId,
      'title': title,
    };
  }

  factory YoutubeBlock.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return YoutubeBlock(
      id: map['id'],
      savedTs: map['savedTs'],
      videoId: map['videoId'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory YoutubeBlock.fromJson(String source) => YoutubeBlock.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, savedTs, videoId, title];
}
