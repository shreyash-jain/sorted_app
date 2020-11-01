import 'dart:math';

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';

import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

abstract class TodoNative {
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(TodoModel todo);
  Future<void> addTodoItem(TodoItemModel todoitem);
  Future<void> updateTodoItem(TodoItemModel todoitem);
  Future<void> deleteTodoItem(TodoItemModel todoitem);
  Future<void> addLinkTodoitemToTodo(
      TodoModel todo, TodoItemModel todoitem, int id);
  Future<int> removeLinkTodoitemFromTodo(
      TodoModel todo, TodoItemModel todoitem);
  Future<List<TodoItemModel>> getTodoItemsOfTodo(TodoModel todo);
  Future<List<TodoItemModel>> getCompletedTodoItemsOfTodo(TodoModel todo);
  Future<List<TodoItemModel>> getInCompletedTodoItemsOfTodo(TodoModel todo);
}

class TodoNativeDataSourceImpl implements TodoNative {
  final SqlDatabaseService nativeDb;

  TodoNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<void> addLinkTodoitemToTodo(
      TodoModel todo, TodoItemModel todoitem, int id) async {
     final db = await nativeDb.database;
    if ((await db.query(todo.getItemsTable(),
                where: "todo_id=? and todoitem_id=?",
                whereArgs: [todo.id, todoitem.id]))
            .length ==
        0)
      await db.insert(todo.getItemsTable(), {
        "todo_id": todo.id,
        "todoitem_id": todoitem.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    final db = await nativeDb.database;
    if ((await db.query(todo.getTable(), where: "id= ?", whereArgs: [todo.id]))
            .length ==
        0)
      await db.insert(todo.getTable(), todo.toMap());
    else
      await db.update(todo.getTable(), todo.toMap(),
          where: "id = ?", whereArgs: [todo.id]);
  }

  @override
  Future<void> addTodoItem(TodoItemModel todoitem) async {
     final db = await nativeDb.database;
    if ((await db.query(todoitem.getTable(), where: "id= ?", whereArgs: [todoitem.id]))
            .length ==
        0)
      await db.insert(todoitem.getTable(), todoitem.toMap());
    else
      await db.update(todoitem.getTable(), todoitem.toMap(),
          where: "id = ?", whereArgs: [todoitem.id]);
  }

  @override
  Future<void> deleteTodo(TodoModel todo) async {
    final db = await nativeDb.database;
    if ((await db.query(todo.getTable(), where: "id=?", whereArgs: [todo.id]))
            .length >
        0) db.delete(todo.getTable(), where: "id=?", whereArgs: [todo.id]);
  }

  @override
  Future<void> deleteTodoItem(TodoItemModel todoitem) async {
     final db = await nativeDb.database;
    if ((await db.query(todoitem.getTable(), where: "id=?", whereArgs: [todoitem.id]))
            .length >
        0) db.delete(todoitem.getTable(), where: "id=?", whereArgs: [todoitem.id]);
  }

  @override
  Future<List<TodoItemModel>> getCompletedTodoItemsOfTodo(TodoModel todo) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM TodoItems t INNER JOIN Todos_TodoItems gt ON gt.todoitem_id = t.id WHERE state=0 and todo_id=${todo.id}");

    List<TodoItemModel> todoitems = result.isNotEmpty
        ? result.map((item) => TodoItemModel.fromMap(item)).toList()
        : [];
    return todoitems;
  }

  @override
  Future<List<TodoItemModel>> getInCompletedTodoItemsOfTodo(TodoModel todo) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM TodoItems t INNER JOIN Todos_TodoItems gt ON gt.todoitem_id = t.id WHERE state=0 and todo_id=${todo.id}");

    List<TodoItemModel> todoitems = result.isNotEmpty
        ? result.map((item) => TodoItemModel.fromMap(item)).toList()
        : [];
    return todoitems;
  }

  @override
  Future<List<TodoItemModel>> getTodoItemsOfTodo(TodoModel todo) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM TodoItems t INNER JOIN Todos_TodoItems gt ON gt.todoitem_id = t.id WHERE todo_id=${todo.id}");

    List<TodoItemModel> todoitems = result.isNotEmpty
        ? result.map((item) => TodoItemModel.fromMap(item)).toList()
        : [];
    return todoitems;
  }

  @override
  Future<int> removeLinkTodoitemFromTodo(
      TodoModel todo, TodoItemModel todoitem) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(
        todo.getItemsTable(),
        columns: ['id'],
        where: "todo_id = ? and todoitem_id=?",
        whereArgs: [todo.id, todoitem.id]);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(todo.getItemsTable(),
          where: "todo_id=? and todoitem_id=?", whereArgs: [todo.id, todoitem.id]);
    }
    return id;
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
   final db = await nativeDb.database;
  
        if ((await db.query(todo.getTable(), where: "id= ?", whereArgs: [todo.id]))
            .length >
        0)
      await db.update(todo.getTable(), todo.toMap(),
          where: "id = ?", whereArgs: [todo.id]);
  }

  @override
  Future<void> updateTodoItem(TodoItemModel todoitem) async {
    final db = await nativeDb.database;
    if ((await db.query(todoitem.getTable(), where: "id= ?", whereArgs: [todoitem.id]))
            .length >
        0)
      await db.update(todoitem.getTable(), todoitem.toMap(),
          where: "id = ?", whereArgs: [todoitem.id]);
  }
}
