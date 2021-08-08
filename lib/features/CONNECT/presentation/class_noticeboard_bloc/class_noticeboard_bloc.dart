import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/CONNECT/data/models/noticeboard_message.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
part 'class_noticeboard_event.dart';
part 'class_noticeboard_state.dart';

class ClassNoticeboardBloc
    extends Bloc<ClassNoticeboardEvent, ClassNoticeboardState> {
  final ConnectRepository repository;
  ClassNoticeboardBloc(this.repository) : super(NoticeboardInitial());

  @override
  Stream<ClassNoticeboardState> mapEventToState(
    ClassNoticeboardEvent event,
  ) async* {
    if (event is GetInitialMessages) {
      Failure failure;

      List<NoticeboardMessage> messages;
      var result = await repository.getNoticeBoardMessages(event.classroom);

      result.fold((l) => failure = l, (r) {
        messages = r;
      });

      if (failure != null) {
        yield ClassNoticeError(Failure.mapToString(failure));
      } else {
        if (messages.length > 0) {
          messages.sort((a, b) => b.time.compareTo(a.time));
          yield (ClassNoticeboardLoaded(messages, event.classroom));
        } else {
          yield NoticeboardEmpty();
        }
      }
    } else if (event is ReloadMessages) {
      print("LoadStateFromMessages");
      if (event.messages.length > 0)
        yield (ClassNoticeboardLoaded(event.messages, event.classroom));
      else
        yield NoticeboardEmpty();
    }
  }
}
