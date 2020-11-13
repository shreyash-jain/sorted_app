import 'dart:convert';

import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  int id;
  int numBlocks;
  String title;
  int icon;
  int decoration;
  int numLogs;
  int savedTs;
  int startDate;
  int numReviews;
  int numTags;
  int notebookId;
  String noteEmoji;
  int canDelete;
  int isDeleted;
  String cover;
  NoteModel({
    this.id = 0,
    this.numBlocks = 0,
    this.title = '',
    this.icon = 0,
    this.decoration = 0,
    this.numLogs = 0,
    this.savedTs = 0,
    this.startDate = 0,
    this.numReviews = 0,
    this.numTags = 0,
    this.notebookId = 0,
    this.noteEmoji = '📔',
    this.cover = 'https://picsum.photos/800/500',
  });

  NoteModel copyWith({
    int id,
    int numBlocks,
    String title,
    int icon,
    int decoration,
    int numLogs,
    int savedTs,
    int startDate,
    int numReviews,
    int numTags,
    int notebookId,
    String noteEmoji,
    String cover,
  }) {
    return NoteModel(
      id: id ?? this.id,
      numBlocks: numBlocks ?? this.numBlocks,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      decoration: decoration ?? this.decoration,
      numLogs: numLogs ?? this.numLogs,
      savedTs: savedTs ?? this.savedTs,
      startDate: startDate ?? this.startDate,
      numReviews: numReviews ?? this.numReviews,
      numTags: numTags ?? this.numTags,
      notebookId: notebookId ?? this.notebookId,
      noteEmoji: noteEmoji ?? this.noteEmoji,
      cover: cover ?? this.cover,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numBlocks': numBlocks,
      'title': title,
      'icon': icon,
      'decoration': decoration,
      'numLogs': numLogs,
      'savedTs': savedTs,
      'startDate': startDate,
      'numReviews': numReviews,
      'numTags': numTags,
      'notebookId': notebookId,
      'noteEmoji': noteEmoji,
      'cover': cover,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NoteModel(
      id: map['id'],
      numBlocks: map['numBlocks'],
      title: map['title'],
      icon: map['icon'],
      decoration: map['decoration'],
      numLogs: map['numLogs'],
      savedTs: map['savedTs'],
      startDate: map['startDate'],
      numReviews: map['numReviews'],
      numTags: map['numTags'],
      notebookId: map['notebookId'],
      noteEmoji: map['noteEmoji'],
      cover: map['cover'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
  String getTable() => "Notes";
  String getTableOfBlocks() => "Notes_Blocks";
  String getTableOfTags() => "Notes_Tags";
  String getTableOfLogs() => "Notes_Logs";
  String getTableOfReviews() => "Notes_Reviews";

  @override
  List<Object> get props {
    return [
      id,
      numBlocks,
      title,
      icon,
      decoration,
      numLogs,
      savedTs,
      startDate,
      numReviews,
      numTags,
      notebookId,
      noteEmoji,
      cover,
    ];
  }
}
