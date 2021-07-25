part of 'class_enroll_bloc.dart';

abstract class ClassEnrollEvent extends Equatable {
  const ClassEnrollEvent();
}

class GetClassDetails extends ClassEnrollEvent {
  final String classId;

  GetClassDetails(this.classId);

  @override
  List<Object> get props => [classId];
}

class EnrollRequestEvent extends ClassEnrollEvent {
  final ClassModel classroom;

  EnrollRequestEvent(this.classroom);

  @override
  // TODO: implement props
  List<Object> get props => [classroom];
}
