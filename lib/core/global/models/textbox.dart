import 'dart:convert';

import 'package:equatable/equatable.dart';

class TextboxModel extends Equatable {
  int id;
  int position;
  String text;
  DateTime date;
  String auther;
  DateTime savedTs;
  TextboxModel({
    this.id = 0,
    this.position = 0,
    this.text = '',
    this.date,
    this.auther = '',
    this.savedTs,
  });


  TextboxModel copyWith({
    int id,
    int position,
    String text,
    DateTime date,
    String auther,
    DateTime savedTs,
  }) {
    return TextboxModel(
      id: id ?? this.id,
      position: position ?? this.position,
      text: text ?? this.text,
      date: date ?? this.date,
      auther: auther ?? this.auther,
      savedTs: savedTs ?? this.savedTs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'position': position,
      'text': text,
      'date': date?.millisecondsSinceEpoch,
      'auther': auther,
      'savedTs': savedTs?.millisecondsSinceEpoch,
    };
  }

  factory TextboxModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TextboxModel(
      id: map['id'],
      position: map['position'],
      text: map['text'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      auther: map['auther'],
      savedTs: DateTime.fromMillisecondsSinceEpoch(map['savedTs']),
    );
  }

  String toJson() => json.encode(toMap());
   String getTable() => "Textboxes";

  factory TextboxModel.fromJson(String source) => TextboxModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      position,
      text,
      date,
      auther,
      savedTs,
    ];
  }
}
