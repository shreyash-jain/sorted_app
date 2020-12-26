part of 'heading_bloc.dart';

abstract class HeadingState extends Equatable {
  const HeadingState();
}

class HeadingInitial extends HeadingState {
  @override
  List<Object> get props => [];
}

class HeadingLoaded extends HeadingState {
  final HeadingBlock heading;

  final BlockInfo blockInfo;

  HeadingLoaded(
    this.heading,
    this.blockInfo,
  );
  @override
  List<Object> get props => [heading, blockInfo];
}

class HeadingError extends HeadingState {
  final String message;

  HeadingError({this.message});

  @override
  List<Object> get props => [message];
}
