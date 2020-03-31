import 'dart:async';
import 'package:notes/services/database.dart';
import 'package:notes/data/todo.dart';

class TodoDao {
  final dbProvider = NotesDatabaseService.db;

  //Adds new Todo records
  Future<int> createTodo(Todo todo) async {
    final db = await dbProvider.database;
    var result = db.insert(todoTABLE, todo.toDatabaseJson());
    return result;
  }

  //Get All Todo items
  //Searches if query string was passed
  Future<List<Todo>> getTodos( int query) async {
    final db = await dbProvider.database;
    print("kaisemujhe");
    print(query);
    List<Map<String, dynamic>> result;


      print ("yaha pe");
        result = await db.query(todoTABLE,

            where: 'event_id = ?',
            whereArgs: [query]);


    List<Todo> todos = result.isNotEmpty
        ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
        : [];
    return todos;
  }

  //Update Todo record
  Future<int> updateTodo(Todo todo) async {
    final db = await dbProvider.database;

    var result = await db.update(todoTABLE, todo.toDatabaseJson(),
        where: "id = ?", whereArgs: [todo.id]);

    return result;
  }

  //Delete Todo records
  Future<int> deleteTodo(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(todoTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllTodos() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      todoTABLE,
    );

    return result;
  }
}
