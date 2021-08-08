part of 'class_noticeboard_bloc.dart';

abstract class ClassNoticeboardState extends Equatable {
  const ClassNoticeboardState();
}

class NoticeboardInitial extends ClassNoticeboardState {
  @override
  List<Object> get props => [];
}

class ClassNoticeboardLoaded extends ClassNoticeboardState {
  final List<NoticeboardMessage> messages;
  final ClassModel classroom;

  ClassNoticeboardLoaded(this.messages, this.classroom);

  @override
  List<Object> get props => [messages, classroom];
}

class ClassNoticeError extends ClassNoticeboardState {
  final String message;

  ClassNoticeError(this.message);

  @override
  List<Object> get props => [message];
}

class NoticeboardEmpty extends ClassNoticeboardState {
  @override

  List<Object> get props => [];
}
