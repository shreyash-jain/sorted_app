import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';
import '../../../domain/entities/track.dart';
import '../../../domain/entities/track_brief.dart';

part 'track_store_search_event.dart';
part 'track_store_search_state.dart';

class TrackStoreSearchBloc
    extends Bloc<TrackStoreSearchEvent, TrackStoreSearchState> {
  final TrackStoreRepository repository;
  TrackStoreSearchBloc(this.repository) : super(TrackStoreSearchInitial());

  @override
  Stream<TrackStoreSearchState> mapEventToState(
    TrackStoreSearchEvent event,
  ) async* {
    final currentState = state;
    if (event is SearchEvent) {
      print("from search bloc!!");
      yield SearchLoadingState();
      final searchedTracksResult = await repository.searchForTracks(event.word);
      List<Track> searchedTracks;
      bool failed = false;
      searchedTracksResult.fold((failure) {
        failed = true;
      }, (tracks) {
        searchedTracks = tracks;
      });
      if (failed) {
        yield SearchFailedState();
      } else {
        yield SearchLoadedState(searchedTracks: searchedTracks);
      }
    }
    if (event is GetSuggestionsEvent) {
      yield SearchLoadingState();
      final suggestionsResult = await repository.getRecentSearchs();
      bool failed = false;
      List<TrackBrief> tracks;
      suggestionsResult.fold(
        (failure) => failed = true,
        (suggestions) => tracks = suggestions,
      );
      if (failed) {
        yield SuggestionsFailedState();
      } else {
        yield SuggestionsLoadedState(briefTracks: tracks);
      }
    }
    if (event is AddSuggestionEvent) {
      final result = await repository.addTrackToRecentSearchs(
        id: event.id,
        icon: event.icon,
        name: event.name,
      );
      bool failed = false;
      result.fold(
        (failure) => failed = true,
        (r) {},
      );
      if (failed) {
        yield AddSuggestionFailedState();
      }
    }
    if (event is GetTrackDetailsEvent) {
      yield SearchLoadingState();
      final trackResult = await repository.getTrackDetailsById(event.track_id);
      Track track;
      bool failed = false;
      trackResult.fold(
        (failure) => failed = true,
        (trackDetails) => track = trackDetails,
      );
      if (failed) {
        yield GetTrackDetailsFailedState();
      } else {
        yield GetTrackDetailsLoadedState(track);
      }
    }
  }
}
