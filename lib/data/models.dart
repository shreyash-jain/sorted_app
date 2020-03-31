import 'dart:math';

class NotesModel {
  int id;
  String title;
  String content;
  bool isImportant;
  DateTime date;
  int book_id;

  NotesModel(
      {this.id,
        this.title,
        this.content,
        this.isImportant,
        this.date,
        this.book_id});

  NotesModel.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.book_id = map['book_id'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = DateTime.parse(map['date']);
    this.isImportant = map['isImportant'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'content': this.content,
      'book_id': this.book_id,
      'isImportant': this.isImportant == true ? 1 : 0,
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
