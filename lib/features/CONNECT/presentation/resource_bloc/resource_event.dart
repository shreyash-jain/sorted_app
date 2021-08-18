part of 'resource_bloc.dart';

abstract class ResourceEvent extends Equatable {
  const ResourceEvent();
}

class LoadClassResources extends ResourceEvent {
  final ClassModel classroom;

  LoadClassResources(this.classroom);
  @override
  List<Object> get props => [classroom];
}

class LoadConsultationResources extends ResourceEvent {
  final ClientConsultationModel consultation;

  LoadConsultationResources(this.consultation);
  @override
  List<Object> get props => [consultation];
}
