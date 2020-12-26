import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/repositories/todo_items_lib.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/todo_item_menu.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:zefyr/zefyr.dart';
part 'todolist_event.dart';
part 'todolist_state.dart';

class TodolistBloc extends Bloc<TodolistEvent, TodolistState> {
  final NoteRepository noteRepository;
  final TodoRepository todoRepository;
  final NoteBloc noteBloc;
  List<TodoItemModel> searchItems;
  TodolistBloc(this.noteRepository, this.noteBloc, this.todoRepository)
      : super(TodolistInitial());
  @override
  Stream<TodolistState> mapEventToState(
    TodolistEvent event,
  ) async* {
    if (event is UpdateTodolist) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      TodoModel todo;
      var todoOrFailure = await todoRepository.getTodolist(event.block.itemId);
      todoOrFailure.fold((l) {
        failure = l;
      }, (r) {
        todo = r;
      });
      List<TodoItemModel> todos;
      var todosOrFailure = await todoRepository.getTodos(todo.id);
      todosOrFailure.fold((l) {
        failure = l;
      }, (r) {
        todos = r;
      });
      if (failure == null) yield TodolistLoaded(todos, event.block, todo, null);

      if (todo.searchId == 1) {
        // print("shre search  " + TodoLib.lib.getGroceriesItem().toString());
        searchItems = TodoLib.lib.getGroceriesItem();
        print("shre search  " + searchItems.toString());
      }
    } else if (event is UpdatePositionTodo) {
      // print("update at bloc");
      // print((state as TodolistLoaded).textboxBlock.text);
      // await noteRepository.updateTextbox(event.textblock);
      // print(event.textblock.text);

      // yield TodolistLoaded(
      //     event.textblock, (state as TodolistLoaded).blockInfo);
    } else if (event is SearchEvent) {
      TodolistLoaded nowState = (state as TodolistLoaded);
      String currentText = event.text;
      if (nowState.todo.searchId == 1) {
        // print("shre search  " + TodoLib.lib.getGroceriesItem().toString());
        searchItems = TodoLib.lib.getGroceriesItem();
      }

      if (searchItems != null && currentText.isNotEmpty) {
        print(searchItems);
        List<TodoItemModel> suggestedList = searchItems;
        suggestedList.retainWhere((element) => (element.todoItem
            .toLowerCase()
            .contains(currentText.toLowerCase())));
        print(suggestedList);
        if (suggestedList.length > 0)
          yield TodolistLoaded(
              nowState.todos, nowState.blockInfo, nowState.todo, suggestedList);
      } else {
        yield TodolistLoaded(
            nowState.todos, nowState.blockInfo, nowState.todo, []);
      }
    } else if (event is AddTodoItem) {
      TodolistLoaded nowState = (state as TodolistLoaded);
      DateTime d = DateTime.now();
      List<TodoItemModel> todos = [];
      if ((state as TodolistLoaded).todos == null ||
          (state as TodolistLoaded).todos.length == 0) {
        todos = [];
      } else
        todos = (state as TodolistLoaded).todos;
      TodoItemModel newTodo = TodoItemModel(
          todoItem: event.todo,
          description: "",
          id: d.millisecondsSinceEpoch,
          state: 0,
          position: 0,
          savedTs: d);

      todos.add(newTodo);
      yield TodolistLoaded(todos, nowState.blockInfo, nowState.todo, null);
      todoRepository.addTodoitem(newTodo).then((value) {
        todoRepository.linkTodoAndTodoitem(
            nowState.todo, newTodo, d.millisecondsSinceEpoch);
      });
    } else if (event is AddTodoFromSuggestion) {
      DateTime now = DateTime.now();
      TodoItemModel thisTodo = event.todo;
      thisTodo =
          thisTodo.copyWith(savedTs: now, id: now.millisecondsSinceEpoch);
      TodolistLoaded nowState = (state as TodolistLoaded);
      List<TodoItemModel> todos = [];
      if ((state as TodolistLoaded).todos == null ||
          (state as TodolistLoaded).todos.length == 0) {
        todos = [];
      } else
        todos = (state as TodolistLoaded).todos;
      todos.add(thisTodo);
      yield TodolistLoaded(todos, nowState.blockInfo, nowState.todo, null);
      todoRepository.addTodoitem(thisTodo).then((value) {
        todoRepository.linkTodoAndTodoitem(
            nowState.todo, thisTodo, now.millisecondsSinceEpoch);
      });
    } else if (event is MoveUpEvent) {
      //Todo: Update positions in db
      TodolistState currentState = (state as TodolistLoaded);
      if (event.position > 0 &&
          event.position < (currentState as TodolistLoaded).todos.length) {
        List<TodoItemModel> updatedTodos =
            (currentState as TodolistLoaded).todos;
        TodoItemModel removedTodo = updatedTodos.removeAt(event.position);
        updatedTodos.insert(event.position - 1, removedTodo);
        print(updatedTodos);
        yield TodolistInitial();

        yield TodolistLoaded(
            updatedTodos,
            (currentState as TodolistLoaded).blockInfo,
            (currentState as TodolistLoaded).todo,
            null);
      }
    } else if (event is MoveDownEvent) {
      //Todo: Update positions in db
      TodolistState currentState = (state as TodolistLoaded);
      if (event.position >= 0 &&
          event.position < (currentState as TodolistLoaded).todos.length - 1) {
        List<TodoItemModel> updatedTodos =
            (currentState as TodolistLoaded).todos;
        TodoItemModel removedTodo = updatedTodos.removeAt(event.position);
        updatedTodos.insert(event.position + 1, removedTodo);
        print(updatedTodos);
        yield TodolistInitial();

        yield TodolistLoaded(
            updatedTodos,
            (currentState as TodolistLoaded).blockInfo,
            (currentState as TodolistLoaded).todo,
            null);
      }
    } else if (event is Duplicate) {
      TodolistState currentState = (state as TodolistLoaded);
      if (event.position >= 0 &&
          event.position < (currentState as TodolistLoaded).todos.length) {
        List<TodoItemModel> updatedTodos =
            (currentState as TodolistLoaded).todos;
        TodoItemModel toAddTodo = updatedTodos[event.position]
            .copyWith(id: updatedTodos[event.position].id + 1);
        //Todo: Add new Todo to db
        updatedTodos.insert(event.position + 1, toAddTodo);
        print(updatedTodos);
        yield TodolistInitial();

        yield TodolistLoaded(
            updatedTodos,
            (currentState as TodolistLoaded).blockInfo,
            (currentState as TodolistLoaded).todo,
            null);
      }
    } else if (event is MoveUpEvent) {
      TodolistState currentState = (state as TodolistLoaded);
      if (event.position > 0 &&
          event.position < (currentState as TodolistLoaded).todos.length) {
        List<TodoItemModel> updatedTodos =
            (currentState as TodolistLoaded).todos;
        TodoItemModel removedTodo = updatedTodos.removeAt(event.position);
        updatedTodos.insert(event.position - 1, removedTodo);
        print(updatedTodos);
        yield TodolistInitial();

        yield TodolistLoaded(
            updatedTodos,
            (currentState as TodolistLoaded).blockInfo,
            (currentState as TodolistLoaded).todo,
            null);
      }
    } else if (event is InvertTodoState) {
      TodolistState currentState = (state as TodolistLoaded);

      List<TodoItemModel> updatedTodos = (currentState as TodolistLoaded).todos;
      TodoItemModel removedTodo = updatedTodos.removeAt(event.position);
      removedTodo =
          removedTodo.copyWith(state: (removedTodo.state == 0) ? 1 : 0);
      updatedTodos.insert(event.position, removedTodo);
      print(updatedTodos);
      yield TodolistInitial();

      yield TodolistLoaded(
          updatedTodos,
          (currentState as TodolistLoaded).blockInfo,
          (currentState as TodolistLoaded).todo,
          null);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
