part of 'cover_bloc.dart';

abstract class CoverState extends Equatable {
  const CoverState();
}

class CoverLoading extends CoverState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends CoverState {
  @override
  List<Object> get props => [];
}

class StartSearchState extends CoverState {
  @override
  List<Object> get props => [];
}

class SearchLoaded extends CoverState {
  final List<UnsplashImage> images;
  SearchLoaded({this.images});
  @override
  List<Object> get props => [images];
}

class CoverLoaded extends CoverState {
  final List<String> gradientUrls;
  final List<String> inspireUrls;
  final List<String> studyUrls;
  final List<String> workUrls;
  CoverLoaded(
      {this.studyUrls, this.workUrls, this.gradientUrls, this.inspireUrls});

  @override
  List<Object> get props => [gradientUrls, inspireUrls, studyUrls, workUrls];
}

class ErrorCover extends CoverState {
  final String message;

  ErrorCover({this.message});

  @override
  List<Object> get props => [message];
}
