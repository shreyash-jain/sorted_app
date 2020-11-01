import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/domain/entities/tab_model.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
part 'tab_event.dart';
part 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  final TaskRepository taskRepository;
  TabBloc(this.taskRepository) : super(TabLoading());
  @override
  Stream<TabState> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is UpdateTasks) {
      Failure failure;
      List<TaskModel> tasks;
      if (event.tab.type == 0) {
        // For Status :
        var tasksOrError =
            await taskRepository.getTasksofStatus(event.tab.search);
        tasksOrError.fold((l) {
          failure = l;
        }, (r) {
          tasks = r;
        });

        if (failure == null) {
          yield TabLoaded(tab: event.tab, tasks: tasks);
        } else {
          print("tab failure");
          print(failure);
        }
      }
      if (event.tab.type == 1) {
        // For Tag :
        var tasksOrError = await taskRepository.getTasksofTag(event.tab.search);
        tasksOrError.fold((l) {
          failure = l;
        }, (r) {
          tasks = r;
        });

        if (failure == null) {
          yield TabLoaded(tab: event.tab, tasks: tasks);
        }
        else {
          print("tab failure");
          print(failure);
        }
      }
    }
  }
}
