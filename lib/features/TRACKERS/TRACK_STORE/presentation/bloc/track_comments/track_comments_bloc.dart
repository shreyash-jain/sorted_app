import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track_comment.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';

part 'track_comments_event.dart';
part 'track_comments_state.dart';

class TrackCommentsBloc extends Bloc<TrackCommentsEvent, TrackCommentsState> {
  final TrackStoreRepository repository;
  TrackCommentsBloc(this.repository) : super(TrackCommentsInitial());

  @override
  Stream<TrackCommentsState> mapEventToState(
    TrackCommentsEvent event,
  ) async* {
    if (event is GetTrackCommentsEvent) {
      if (event.trackComments.isEmpty) {
        yield GetTrackCommentsLoadingState();
      } else {
        yield GetTrackCommentsLoadingPaginationState();
      }
      final trackCommentsResult = await repository.getCommentsByTrackId(
        event.track_id,
        event.trackComments.length,
        event.size,
      );
      bool failed = false;
      List<TrackComment> comments;
      trackCommentsResult.fold(
        (failure) => failed = true,
        (trackComments) => comments = trackComments,
      );
      if (failed) {
        yield GetTrackCommentsFailedState();
      } else {
        yield GetTrackCommentsLoadedState(
          comments: event.trackComments + comments,
        );
      }
    }
  }
}
