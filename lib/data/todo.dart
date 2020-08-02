import 'dart:math';

class Todo {
  int id;
  //description is the text we see on
  //main screen card text
  String description;
  int event_id;
  int position;
  DateTime saved_ts;
  //isDone used to mark what Todo item is completed
  bool isDone = false;
  //When using curly braces { } we note dart that
  //the parameters are optional
  Todo({this.id,this.event_id,  this.saved_ts,this.position, this.description, this.isDone = false});
  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
    //This will be used to convert JSON objects that
    //are coming from querying the database and converting
    //it into a Todo object
    id: data['id'],
    position: data['position'],
    event_id:data['event_id'],
    saved_ts :DateTime.parse(data['saved_ts']),
    description: data['description'],
    //Since sqlite doesn't have boolean type for true/false
    //we will 0 to denote that it is false
    //and 1 for true
    isDone: data['is_done'] == 0 ? false : true,
  );
  Map<String, dynamic> toDatabaseJson() => {
    //This will be used to convert Todo objects that
    //are to be stored into the datbase in a form of JSON
    "id": this.id,
    "description": this.description,
    "is_done": this.isDone == false ? 0 : 1,
    "position":this.position,
    "event_id":this.event_id,
    'saved_ts':this.saved_ts.toIso8601String()
  };
}
