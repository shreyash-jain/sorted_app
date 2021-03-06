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
