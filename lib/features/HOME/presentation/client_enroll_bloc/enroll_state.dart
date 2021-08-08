part of 'enroll_bloc.dart';

abstract class ClientEnrollState extends Equatable {
  const ClientEnrollState();
}

class ClientEnrollInitial extends ClientEnrollState {
  @override
  List<Object> get props => [];
}

class ClientEnrollLoaded extends ClientEnrollState {
  final List<ClassModel> requestedClasses;
  final List<ClassModel> enrolledClasses;

  ClientEnrollLoaded(this.requestedClasses, this.enrolledClasses);
  @override
  List<Object> get props => [requestedClasses, enrolledClasses];
}

class ClientEnrollError extends ClientEnrollState {
  final String message;

  ClientEnrollError(this.message);

  @override
  List<Object> get props => [message];
}
