import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_cloud_data_source.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_native_data_source.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_native_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_remote_api_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_shared_pref_data_source.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart' as ph;
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_shared_pref_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/todo_sources/todo_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/todo_sources/todo_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/todo_sources/todo_shared_pref_data_source.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoCloud remoteTodoDataSource;
  final TodoNative nativeTodoDataSource;
  final TodoSharedPref sharedPrefTodo;
  final NetworkInfo networkInfo;

  final _random = new Random();

  TodoRepositoryImpl({
    @required this.remoteTodoDataSource,
    @required this.nativeTodoDataSource,
    @required this.networkInfo,
    @required this.sharedPrefTodo,
  });

  @override
  Future<Either<Failure, void>> addTodo(TodoModel todo) async {
    try {
      await nativeTodoDataSource.addTodo(todo);
      try {
        await remoteTodoDataSource.addTodo(todo);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addTodoitem(TodoItemModel todoitem) async {
    try {
      await nativeTodoDataSource.addTodoItem(todoitem);
      try {
        await remoteTodoDataSource.addTodoItem(todoitem);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(TodoModel todo) async {
    try {
      await nativeTodoDataSource.deleteTodo(todo);
      try {
        await remoteTodoDataSource.deleteTodo(todo);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodoitem(TodoItemModel todoitem) async {
    try {
      await nativeTodoDataSource.deleteTodoItem(todoitem);
      try {
        await remoteTodoDataSource.deleteTodoItem(todoitem);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, TodoModel>> getTodolist(int todolistId) async {
    try {
      return Right(await nativeTodoDataSource.getTodo(todolistId));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<TodoItemModel>>> getTodos(int todolistId) async {
    try {
      TodoModel todo = new TodoModel(id: todolistId);
      return Right(await nativeTodoDataSource.getTodoItemsOfTodo(todo));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> linkTodoAndTodoitem(
      TodoModel todo, TodoItemModel todoitem, int id) async {
    try {
      await nativeTodoDataSource.addLinkTodoitemToTodo(todo, todoitem, id);
      try {
        await remoteTodoDataSource.addLinkTodoitemToTodo(todo, todoitem, id);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> removeLinkTodoAndTodoitem(
      TodoModel todo, TodoItemModel todoitem) async {
    // try {
    //   await nativeTodoDataSource.removeLinkTodoitemFromTodo(todo, todoitem);
    //   try {
    //     await remoteTodoDataSource.removeLinkTodoitemFromTodo(id)
    //   } on Exception {
    //     return Left(ServerFailure());
    //   }
    // } on Exception {
    //   return Left(NativeDatabaseException());
    // }
  }

  @override
  Future<Either<Failure, void>> updateTodo(TodoModel todo) async {
    try {
      await nativeTodoDataSource.updateTodo(todo);
      try {
        await remoteTodoDataSource.updateTodo(todo);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateTodoitem(TodoItemModel todoitem) async {
    try {
      await nativeTodoDataSource.updateTodoItem(todoitem);
      try {
        await remoteTodoDataSource.updateTodoItem(todoitem);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }
}
