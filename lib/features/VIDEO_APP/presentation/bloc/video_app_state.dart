part of 'video_app_bloc.dart';
abstract class VideoAppState extends Equatable {
  const VideoAppState();
}
class VideoAppInitial extends VideoAppState {
  @override
  List<Object> get props => [];
}
