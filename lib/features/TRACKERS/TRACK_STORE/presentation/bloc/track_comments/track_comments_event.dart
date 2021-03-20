part of 'track_comments_bloc.dart';

abstract class TrackCommentsEvent extends Equatable {
  const TrackCommentsEvent();

  @override
  List<Object> get props => [];
}

class GetTrackCommentsEvent extends TrackCommentsEvent {
  final List<TrackComment> trackComments;
  final int size;
  final int track_id;
  const GetTrackCommentsEvent({
    @required this.trackComments,
    this.size = 25,
    this.track_id
  });
  @override
  List<Object> get props => [trackComments, track_id, size];
}
