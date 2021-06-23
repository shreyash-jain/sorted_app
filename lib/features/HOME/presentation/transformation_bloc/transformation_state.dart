part of 'transformation_bloc.dart';

abstract class TransformationState extends Equatable {
  const TransformationState();
}

class TransformationInitial extends TransformationState {
  @override
  List<Object> get props => [];
}

class HomePageTransformationLoaded extends TransformationState {
  final TransformationModel trans;

  HomePageTransformationLoaded(
      this.trans);

  List<Object> get props => [trans];
}

class TransformationError extends TransformationState {
  final String message;

  TransformationError(this.message);
  @override
  List<Object> get props => [message];
}
