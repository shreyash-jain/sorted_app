part of 'resource_bloc.dart';

abstract class ResourceState extends Equatable {
  const ResourceState();
}

class ResourceInitial extends ResourceState {
  @override
  List<Object> get props => [];
}

class ResourceLoaded extends ResourceState {
  final List<ResourceMessage> messages;

  ResourceLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ResourceError extends ResourceState {
  final String message;

  ResourceError(this.message);

  @override
  List<Object> get props => [message];
}

class ResourceEmpty extends ResourceState {
  @override
  List<Object> get props => [];
}
