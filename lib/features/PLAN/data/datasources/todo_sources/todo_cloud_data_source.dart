import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sqflite/sqflite.dart';

abstract class TodoCloud {
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(TodoModel todo);
  Future<void> addTodoItem(TodoItemModel todoitem);
  Future<void> updateTodoItem(TodoItemModel todoitem);
  Future<void> deleteTodoItem(TodoItemModel todoitem);

  Future<void> addLinkTodoitemToTodo(
      TodoModel todo, TodoItemModel todoitem, int id);
  Future<void> removeLinkTodoitemFromTodo(int id);
}

class TodoCloudDataSourceImpl implements TodoCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  TodoCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Future<void> addLinkTodoitemToTodo(
      TodoModel todo, TodoItemModel todoitem, int id) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(todo.getItemsTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "todo_id": todo.id,
      "todoitem_id": todoitem.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(todo.getTable())
        .doc(todo.id.toString());

    ref
        .set(todo.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addTodoItem(TodoItemModel todoitem) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(todoitem.getTable())
        .doc(todoitem.id.toString());

    ref
        .set(todoitem.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteTodo(TodoModel todo) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(todo.getTable())
        .doc(todo.id.toString());

    ref
        .delete()
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteTodoItem(TodoItemModel todoitem) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(todoitem.getTable())
        .doc(todoitem.id.toString());

    ref
        .delete()
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> removeLinkTodoitemFromTodo(int id) async {
    User user = auth.currentUser;
    TodoModel todo;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(todo.getItemsTable())
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(todo.getTable())
        .doc(todo.id.toString());

    ref
        .update(todo.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateTodoItem(TodoItemModel todoitem) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(todoitem.getTable())
        .doc(todoitem.id.toString());

    ref
        .set(todoitem.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }
}
