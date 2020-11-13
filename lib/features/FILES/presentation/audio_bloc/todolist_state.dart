part of 'todolist_bloc.dart';

abstract class TodolistState extends Equatable {
  const TodolistState();
}

class TodolistInitial extends TodolistState {
  @override
  List<Object> get props => [];
}

class TodolistLoaded extends TodolistState {
  final TodoModel todo;
  final List<TodoItemModel> todos;
  final BlockInfo blockInfo;

  TodolistLoaded(this.todos, this.blockInfo, this.todo);
  @override
  List<Object> get props => [todo, blockInfo, todos];
}

class TodoError extends TodolistState {
  final String message;

  TodoError({this.message});

  @override
  List<Object> get props => [message];
}