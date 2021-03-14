part of 'track_store_search_bloc.dart';

abstract class TrackStoreSearchEvent extends Equatable {
  const TrackStoreSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchEvent extends TrackStoreSearchEvent {
  final String word;
  const SearchEvent({this.word});

  @override
  List<Object> get props => [word];
}

class GetSuggestionsEvent extends TrackStoreSearchEvent {
  @override
  List<Object> get props => [];
}

class AddSuggestionEvent extends TrackStoreSearchEvent {
  final int id;
  final String name;
  final String icon;
  AddSuggestionEvent({this.id, this.name, this.icon});
  @override
  List<Object> get props => [];
}

class GetTrackDetailsEvent extends TrackStoreSearchEvent {
  final int track_id;
  GetTrackDetailsEvent({this.track_id});
  @override
  List<Object> get props => [track_id];
}
