part of 'class_enroll_bloc.dart';

abstract class ClassEnrollState extends Equatable {
  const ClassEnrollState();
}

class ClassEnrollInitial extends ClassEnrollState {
  @override
  List<Object> get props => [];
}

class ClassEnrollLoaded extends ClassEnrollState {
  final ClassModel classroom;
  final int userEnrollState;
  final ExpertProfileModel expertProfile;
  final List<String> topics;
  final bool isLoading;

  ClassEnrollLoaded(
      this.classroom, this.userEnrollState, this.expertProfile, this.topics, this.isLoading);
  @override
  List<Object> get props => [isLoading, classroom, userEnrollState, expertProfile, topics];
}

class ClassEnrollError extends ClassEnrollState {
  final String message;

  ClassEnrollError(this.message);
  @override
  List<Object> get props => [message];
}

/// userEnrollState
// 0 -> class not enrolled
// 1 -> class already enrolled, but not accepted
// 2 => class already accepted
