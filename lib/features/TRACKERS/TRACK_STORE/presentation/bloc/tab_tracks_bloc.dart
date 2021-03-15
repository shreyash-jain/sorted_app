import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/market_tab.dart';
import '../../domain/entities/track.dart';
import '../../domain/repositories/track_store_repository.dart';
part 'tab_tracks_event.dart';
part 'tab_tracks_state.dart';

class TabTracksBloc extends Bloc<TabTracksEvent, TabTracksState> {
  final TrackStoreRepository repository;
  TabTracksBloc(this.repository) : super(TabTracksInitial());

  @override
  Stream<TabTracksState> mapEventToState(
    TabTracksEvent event,
  ) async* {
    if (event is GetTabTracksEvent) {
      yield GetTabTracksLoadingState();
      bool failed = false;
      final marketTabsResult = await repository.getTabTracks(event.tracks);

      List<Track> tracksDetail;

      marketTabsResult.fold((failure) {
        failed = true;
      }, (tracks) {
        tracksDetail = tracks;
      });

      if (failed) {
        yield GetTabTracksFailedState();
      } else {
        yield GetTabTracksLoadedState(
          tracksDetail: tracksDetail,
        );
      }
    }
  }
}
