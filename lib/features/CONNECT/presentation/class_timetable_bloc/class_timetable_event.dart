part of 'class_timetable_bloc.dart';

abstract class ClassTimetableEvent extends Equatable {
  const ClassTimetableEvent();
}

class GetTimetable extends ClassTimetableEvent {
  final ClassModel classroom;

  GetTimetable(this.classroom);
  @override
  List<Object> get props => [classroom];
}





