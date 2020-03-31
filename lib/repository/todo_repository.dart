import 'package:notes/data/todo.dart';
import 'package:notes/dao/todo_dao.dart';


class TodoRepository {
  final todoDao = TodoDao();

  Future getAllTodos(int query) => todoDao.getTodos(query);

  Future insertTodo(Todo todo) => todoDao.createTodo(todo);

  Future updateTodo(Todo todo) => todoDao.updateTodo(todo);

  Future deleteTodoById(int id) => todoDao.deleteTodo(id);

  //We are not going to use this in the demo
  Future deleteAllTodos() => todoDao.deleteAllTodos();
}
