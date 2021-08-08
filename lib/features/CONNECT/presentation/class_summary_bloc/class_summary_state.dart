part of 'class_summary_bloc.dart';

abstract class ClassSummaryState extends Equatable {
  const ClassSummaryState();
}

class ClassSummaryInitial extends ClassSummaryState {
  @override
  List<Object> get props => [];
}

class ClassSummaryLoaded extends ClassSummaryState {
  final ClassModel classroom;
  final List<String> topics;
  final ClassTimetableModel timetableModel;
  final ClassPrivateModel classFeeModel;
  final bool isLoading;

  ClassSummaryLoaded(this.classroom, this.topics, this.timetableModel,
      this.classFeeModel, this.isLoading);
  @override
  List<Object> get props =>
      [classroom, topics, timetableModel, classFeeModel, isLoading];
}

class ClassSummaryError extends ClassSummaryState {
  final String message;

  ClassSummaryError(this.message);
  @override
  List<Object> get props => [message];
}
