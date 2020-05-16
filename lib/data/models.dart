import 'dart:math';

class NotesModel {
  int id;
  String title;
  String content;
  bool isImportant;
  DateTime date;
  int book_id;
  String c_summary;
  String c_keywords;
  double s_value;
  DateTime saved_ts;

  NotesModel(
      {this.id,
        this.title,
        this.content,
        this.isImportant,
        this.date,
        this.saved_ts,
        this.c_keywords,
        this.c_summary,
        this.s_value,
        this.book_id});

  NotesModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.book_id = map['book_id'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
    this.isImportant = map['isImportant'] == 1 ? true : false;
    this.saved_ts =DateTime.parse(map['saved_ts']);
    this.c_keywords=map['c_keywords'];
    this.c_summary=map['c_summary'];
    this.s_value=map['s_value'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'content': this.content,
      'book_id': this.book_id,
      'isImportant': this.isImportant == true ? 1 : 0,
      'saved_ts':this.saved_ts.toIso8601String(),
      'c_summary':this.c_summary,
      'c_keywords':this.c_keywords,
      's_value':this.s_value,
      'date': this.date.toIso8601String()
    };
  }

  NotesModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
    this.content = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
    this.isImportant = Random().nextBool();
    this.date = DateTime.now().add(Duration(hours: Random().nextInt(100)));
    this.book_id = Random(10).nextInt(1000) + 1;
  }
}
