part of 'track_store_search_bloc.dart';

abstract class TrackStoreSearchState extends Equatable {
  const TrackStoreSearchState();

  @override
  List<Object> get props => [];
}

class TrackStoreSearchInitial extends TrackStoreSearchState {}

class SearchLoadingState extends TrackStoreSearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadedState extends TrackStoreSearchState {
  final List<Track> searchedTracks;
  const SearchLoadedState({this.searchedTracks});
  @override
  List<Object> get props => [searchedTracks];
}

class SearchFailedState extends TrackStoreSearchState {
  @override
  List<Object> get props => [];
}

class SuggestionsLoadedState extends TrackStoreSearchState {
  final List<TrackBrief> briefTracks;
  const SuggestionsLoadedState({this.briefTracks});
  @override
  List<Object> get props => [briefTracks];
}

class SuggestionsFailedState extends TrackStoreSearchState {
  @override
  List<Object> get props => [];
}

class AddSuggestionFailedState extends TrackStoreSearchState {
  @override
  List<Object> get props => [];
}

class GetTrackDetailsFailedState extends TrackStoreSearchState {
  @override
  List<Object> get props => [];
}

class GetTrackDetailsLoadedState extends TrackStoreSearchState {
  final Track track;
  GetTrackDetailsLoadedState(this.track);
  @override
  List<Object> get props => [track];
}

class GetTrackDetailsLoadingState extends TrackStoreSearchState {
  @override
  List<Object> get props => [];
}
