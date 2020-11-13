part of 'todolist_bloc.dart';

abstract class TodolistEvent extends Equatable {
  const TodolistEvent();
}

class UpdateTodolist extends TodolistEvent {
  final BlockInfo block;
  UpdateTodolist(this.block);

  @override
  List<Object> get props => [block];
}

class AddTodoItem extends TodolistEvent {
  final String todo;
  AddTodoItem(this.todo);

  @override
  List<Object> get props => [todo];
}

class EditTodoItem extends TodolistEvent {
  final TodoItemModel todo;
  EditTodoItem(this.todo);

  @override
  List<Object> get props => [todo];
}



class MoveUpEvent extends TodolistEvent {
 final int position;
  final TodoItemModel todo;
  MoveUpEvent(this.position, this.todo);

  @override
  List<Object> get props => [position,todo];
}

class InvertTodoState extends TodolistEvent {
  final int position;
  final TodoItemModel todo;
  InvertTodoState(this.position, this.todo);

  @override
  List<Object> get props => [position,todo];
}

class MoveDownEvent extends TodolistEvent {
  final int position;
  final TodoItemModel todo;
  MoveDownEvent(this.position, this.todo);

  @override
  List<Object> get props => [position,todo];
}

class DeleteEvent extends TodolistEvent {
  final int position;
   final TodoItemModel todo;
  DeleteEvent(this.position, this.todo);

  @override
  List<Object> get props => [position];
}
class Duplicate extends TodolistEvent {
  final int position;
  final TodoItemModel todo;
  Duplicate(this.position, this.todo);

  @override
  List<Object> get props => [position,todo];
}

class UpdatePositionTodo extends TodolistEvent {
  final List<TodoItemModel> todos;
  UpdatePositionTodo(this.todos);

  @override
  List<Object> get props => [todos];
}
