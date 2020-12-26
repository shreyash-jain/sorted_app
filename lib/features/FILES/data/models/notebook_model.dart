import 'dart:convert';

import 'package:equatable/equatable.dart';

class NotebookModel extends Equatable {
  int id;
  int numNotes;
  String description;
  String title;
  String icon;
  String color;
  int numLogs;
  int savedTs;
  String noteEmoji;
  int canDelete;
  int isDeleted;
  String cover;
  int isCustom;
  int isPublic;
  int templeteId;
  String assetPath;
  int listCategory;
  NotebookModel({
   this.id = 0,
    this.numNotes = 0,
    this.title = 'Custom Notebook',
    this.icon = '📓',
    this.color = '',
    this.numLogs = 0,
    this.savedTs = 0,
    this.noteEmoji = '📓',
    this.canDelete = 0,
    this.isDeleted = 0,
    this.cover = 'https://picsum.photos/800/500',
    this.isCustom = 0,
    this.isPublic = 0,
    this.templeteId = 0,
    this.assetPath = '',
    this.description = '',
    this.listCategory = 0,
  });
  

  NotebookModel copyWith({
    int id,
    int numNotes,
    String description,
    String title,
    String icon,
    String color,
    int numLogs,
    int savedTs,
    String noteEmoji,
    int canDelete,
    int isDeleted,
    String cover,
    int isCustom,
    int isPublic,
    int templeteId,
    String assetPath,
    int listCategory,
  }) {
    return NotebookModel(
      id: id ?? this.id,
      numNotes: numNotes ?? this.numNotes,
      description: description ?? this.description,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      numLogs: numLogs ?? this.numLogs,
      savedTs: savedTs ?? this.savedTs,
      noteEmoji: noteEmoji ?? this.noteEmoji,
      canDelete: canDelete ?? this.canDelete,
      isDeleted: isDeleted ?? this.isDeleted,
      cover: cover ?? this.cover,
      isCustom: isCustom ?? this.isCustom,
      isPublic: isPublic ?? this.isPublic,
      templeteId: templeteId ?? this.templeteId,
      assetPath: assetPath ?? this.assetPath,
      listCategory: listCategory ?? this.listCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numNotes': numNotes,
      'description': description,
      'title': title,
      'icon': icon,
      'color': color,
      'numLogs': numLogs,
      'savedTs': savedTs,
      'noteEmoji': noteEmoji,
      'canDelete': canDelete,
      'isDeleted': isDeleted,
      'cover': cover,
      'isCustom': isCustom,
      'isPublic': isPublic,
      'templeteId': templeteId,
      'assetPath': assetPath,
      'listCategory': listCategory,
    };
  }

  factory NotebookModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return NotebookModel(
      id: map['id'],
      numNotes: map['numNotes'],
      description: map['description'],
      title: map['title'],
      icon: map['icon'],
      color: map['color'],
      numLogs: map['numLogs'],
      savedTs: map['savedTs'],
      noteEmoji: map['noteEmoji'],
      canDelete: map['canDelete'],
      isDeleted: map['isDeleted'],
      cover: map['cover'],
      isCustom: map['isCustom'],
      isPublic: map['isPublic'],
      templeteId: map['templeteId'],
      assetPath: map['assetPath'],
      listCategory: map['listCategory'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotebookModel.fromJson(String source) => NotebookModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      numNotes,
      description,
      title,
      icon,
      color,
      numLogs,
      savedTs,
      noteEmoji,
      canDelete,
      isDeleted,
      cover,
      isCustom,
      isPublic,
      templeteId,
      assetPath,
      listCategory,
    ];
  }
}
