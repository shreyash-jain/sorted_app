part of 'class_timetable_bloc.dart';

abstract class ClassTimetableState extends Equatable {
  const ClassTimetableState();
}

class TimetableInitial extends ClassTimetableState {
  @override
  List<Object> get props => [];
}

class TimetableLoaded extends ClassTimetableState {
  final List<WeekdayClass> days;
  final ClassModel classroom;

  TimetableLoaded(this.days, this.classroom);
  @override
  List<Object> get props => [days, classroom];
}

