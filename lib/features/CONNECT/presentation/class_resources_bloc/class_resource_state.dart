part of 'class_resource_bloc.dart';

abstract class ClassResourceState extends Equatable {
  const ClassResourceState();
}

class ClientInitial extends ClassResourceState {
  @override
  List<Object> get props => [];
}

class ClassResourcesLoaded extends ClassResourceState {
  final List<ResourceMessage> messages;
  final ClassModel classroom;

  ClassResourcesLoaded(this.messages, this.classroom);

  @override
 
  List<Object> get props => [messages, classroom];
}


class ClassResourcesError extends ClassResourceState {
  final String message;


  ClassResourcesError(this.message);

  @override
 
  List<Object> get props => [message];
}
