part of 'transformation_bloc.dart';

abstract class TransformationEvent extends Equatable {
  const TransformationEvent();
}

class LoadTransformation extends TransformationEvent {
  @override
  List<Object> get props => [];
}

