
import 'package:notes/data/todo.dart';
import 'package:notes/repository/todo_repository.dart';


import 'dart:async';

class TodoBloc {
  //Get instance of the Repository
  final _todoRepository = TodoRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _todoController = StreamController<List<Todo>>.broadcast();

  get todos => _todoController.stream;

  TodoBloc(int query) {
    getTodos(query);
  }

  getTodos(int query) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _todoController.sink.add(await _todoRepository.getAllTodos(query));
  }

  addTodo(Todo todo,int query) async {
    await _todoRepository.insertTodo(todo);
    getTodos(query);
  }

  updateTodo(Todo todo,int query) async {
    await _todoRepository.updateTodo(todo);
    getTodos(query);
  }

  deleteTodoById(int id,int query) async {
    _todoRepository.deleteTodoById(id);
    getTodos(query);
  }

  dispose() {
    _todoController.close();
  }
}
