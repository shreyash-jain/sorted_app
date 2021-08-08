part of 'class_summary_bloc.dart';

abstract class ClassSummaryEvent extends Equatable {
  const ClassSummaryEvent();
}

class LoadClassSummary extends ClassSummaryEvent {
  final ClassModel classroom;

  LoadClassSummary(this.classroom);
  @override
  List<Object> get props => [];
}

