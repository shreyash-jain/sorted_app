import 'dart:convert';

import 'package:equatable/equatable.dart';

class DayAffirmation extends Equatable {
  final DateTime lastSeen;
  final String text;
  final bool read;
  final bool isFav;
  final int waitSeconds;
  final String imageUrl;
  final String sImageUrl;
  final String photoGrapherName;
  final String downloadLink;
  final String profileLink;
  final String thumbnailUrl;
  final int id;
  final String category;
  final int cloudId;
  DayAffirmation({
    this.lastSeen,
    this.text = '',
    this.read = false,
    this.isFav = false,
    this.waitSeconds = 0,
    this.imageUrl = '',
    this.sImageUrl = '',
    this.photoGrapherName = '',
    this.downloadLink = '',
    this.profileLink = '',
    this.thumbnailUrl = '',
    this.id,
    this.category = '',
    this.cloudId = 0,
  });

  DayAffirmation copyWith({
    DateTime lastSeen,
    String text,
    bool read,
    bool isFav,
    int waitSeconds,
    String imageUrl,
    String sImageUrl,
    String photoGrapherName,
    String downloadLink,
    String profileLink,
    String thumbnailUrl,
    int id,
    String category,
    int cloudId,
  }) {
    return DayAffirmation(
      lastSeen: lastSeen ?? this.lastSeen,
      text: text ?? this.text,
      read: read ?? this.read,
      isFav: isFav ?? this.isFav,
      waitSeconds: waitSeconds ?? this.waitSeconds,
      imageUrl: imageUrl ?? this.imageUrl,
      sImageUrl: sImageUrl ?? this.sImageUrl,
      photoGrapherName: photoGrapherName ?? this.photoGrapherName,
      downloadLink: downloadLink ?? this.downloadLink,
      profileLink: profileLink ?? this.profileLink,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      id: id ?? this.id,
      category: category ?? this.category,
      cloudId: cloudId ?? this.cloudId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastSeen': lastSeen?.toIso8601String(),
      'text': text,
      'read': read == true ? 1 : 0,
      'isFav': isFav == true ? 1 : 0,
      'waitSeconds': waitSeconds,
      'imageUrl': imageUrl,
      'sImageUrl': sImageUrl,
      'photoGrapherName': photoGrapherName,
      'downloadLink': downloadLink,
      'profileLink': profileLink,
      'thumbnailUrl': thumbnailUrl,
      'id': id,
      'category': category,
      'cloudId': cloudId,
    };
  }

  factory DayAffirmation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DayAffirmation(
      lastSeen: DateTime.parse(map['lastSeen']),
      text: map['text'],
      read: map['read'] == 1 ? true : false,
      isFav: map['isFav'] == 1 ? true : false,
      waitSeconds: map['waitSeconds'],
      imageUrl: map['imageUrl'],
      sImageUrl: map['sImageUrl'],
      photoGrapherName: map['photoGrapherName'],
      downloadLink: map['downloadLink'],
      profileLink: map['profileLink'],
      thumbnailUrl: map['thumbnailUrl'],
      id: map['id'],
      category: map['category'],
      cloudId: map['cloudId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DayAffirmation.fromJson(String source) =>
      DayAffirmation.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      lastSeen,
      text,
      read,
      isFav,
      waitSeconds,
      imageUrl,
      sImageUrl,
      photoGrapherName,
      downloadLink,
      profileLink,
      thumbnailUrl,
      id,
      category,
      cloudId,
    ];
  }
}
