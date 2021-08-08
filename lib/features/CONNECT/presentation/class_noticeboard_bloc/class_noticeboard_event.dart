part of 'class_noticeboard_bloc.dart';

abstract class ClassNoticeboardEvent extends Equatable {
  const ClassNoticeboardEvent();
}

class GetInitialMessages extends ClassNoticeboardEvent {
  final ClassModel classroom;

  GetInitialMessages(this.classroom);

  @override
  List<Object> get props => [classroom];
}

class ReloadMessages extends ClassNoticeboardEvent {
  final List<NoticeboardMessage> messages;
  final ClassModel classroom;

  ReloadMessages(this.messages, this.classroom);

  @override
  List<Object> get props => [messages, classroom];
}


