import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';
import '../../domain/entities/market_banner.dart';
import '../../domain/entities/market_heading.dart';

part 'track_store_event.dart';
part 'track_store_state.dart';

class TrackStoreBloc extends Bloc<TrackStoreEvent, TrackStoreState> {
  final TrackStoreRepository repository;
  TrackStoreBloc(this.repository) : super(TrackStoreInitial());
  @override
  Stream<TrackStoreState> mapEventToState(TrackStoreEvent event) async* {
    if (event is GetMarketsEvent) {
      yield GetMarketsLoadingState();

      final marketBannersResult = await repository.getMarketBanners();
      final marketHeadingsResult = await repository.getMarketHeadings();
      print('we got the data jajaja');
      yield* marketBannersResult.fold((failure) async* {
        yield GetMarketsFailedState();
      }, (marketBanners) async* {
        yield* marketHeadingsResult.fold((failure) async* {
          yield GetMarketsFailedState();
        }, (marketHeadings) async* {
          print('Hello from bloc');
          yield GetMarketsLoadedState(
            marketBanners: marketBanners,
            marketHeadings: marketHeadings,
          );
        });
      });
    }
  }
}
