part of 'fit_info_bloc.dart';

abstract class FitInfoState extends Equatable {
  const FitInfoState();
}

class FitInfoInitial extends FitInfoState {
  @override
  List<Object> get props => [];
}

class FitInfoLoaded extends FitInfoState {
  final List<String> images;
  final TrackModel track;
  final TrackSummary summary;

  FitInfoLoaded(this.images, this.track, this.summary);
  @override
  List<Object> get props => [images];
}

class FitInfoError extends FitInfoState {
  final String message;

  FitInfoError(this.message);

  @override
  List<Object> get props => [message];
}
