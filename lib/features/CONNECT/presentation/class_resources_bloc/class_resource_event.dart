part of 'class_resource_bloc.dart';

abstract class ClassResourceEvent extends Equatable {
  const ClassResourceEvent();
}

class GetClassMembers extends ClassResourceEvent {
  final ClassModel classroom;

  GetClassMembers(this.classroom);

  @override
  List<Object> get props => [classroom];
}
