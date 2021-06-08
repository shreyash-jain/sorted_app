import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'video_app_event.dart';
part 'video_app_state.dart';
class VideoAppBloc extends Bloc<VideoAppEvent, VideoAppState> {
  VideoAppBloc() : super(VideoAppInitial());
  @override
  Stream<VideoAppState> mapEventToState(
    VideoAppEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
