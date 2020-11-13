import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

abstract class TodoRepository {
  /// Gets the affirmations from cloud and favourates and also adds to local
  ///
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TodoItemModel>>> getTodos(int todolistId);

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, TodoModel>> getTodolist(int todolistId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> addTodoitem(TodoItemModel todoitem);
    /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> updateTodoitem(TodoItemModel todoitem);
      /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> deleteTodoitem(TodoItemModel todoitem);
    /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> addTodo(TodoModel todo);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> updateTodo(TodoModel todo);

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> deleteTodo(TodoModel todo);
  Future<Either<Failure, void>> linkTodoAndTodoitem(
      TodoModel todo, TodoItemModel todoitem, int id);

  Future<Either<Failure, void>> removeLinkTodoAndTodoitem(
      TodoModel todo, TodoItemModel todoitem);


}
