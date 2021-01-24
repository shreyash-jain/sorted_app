import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
part 'affirmation_pv_event.dart';
part 'affirmations_pv_state.dart';

const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String NETWORK_FAILURE_MESSAGE = 'Network Failure';
const String NATIVE_DATABASE_FAILURE_MESSAGE = "Database error";
const String FAILURE_MESSAGE = "Uncatched error";

class AffirmationPVBloc extends Bloc<AffirmationPVEvent, AffirmationPVState> {
  final HomeRepository repository;
  final AffirmationBloc outerBloc;
  AudioPlayer audioPlayer;

  AffirmationPVBloc(this.repository, this.outerBloc)
      : super((outerBloc.state is LoadedState)
            ? LoadedPVState(
                affirmations: (outerBloc.state as LoadedState).affirmations)
            : LoadingPVState()) {
    audioPlayer = AudioPlayer();
  }

  String mapFailureToString(Failure failure) {
    if (failure == ServerFailure()) {
      return SERVER_FAILURE_MESSAGE;
    } else if (failure == NativeDatabaseException()) {
      return NATIVE_DATABASE_FAILURE_MESSAGE;
    } else if (failure == CacheFailure()) {
      return CACHE_FAILURE_MESSAGE;
    } else if (failure == NetworkFailure()) {
      return NETWORK_FAILURE_MESSAGE;
    } else
      return FAILURE_MESSAGE;
  }

  @override
  Stream<AffirmationPVState> mapEventToState(
    AffirmationPVEvent event,
  ) async* {
    if (event is Play) {
      await audioPlayer.play(
          'https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/inspiration_music%2Fbensound-anewbeginning.mp3?alt=media&token=cb491c08-6b46-464a-9ccd-4531c498633a');
      print("play");
    } else if (event is Pause) {
      int result = await audioPlayer.pause();

      print("pause");
    } else if (event is AddToFav) {
      print("AddToFav");
      if (!event.affirmations[event.index].isFav) {
        AffirmationModel affirmation = new AffirmationModel(
            id: event.affirmations[event.index].cloudId,
            text: event.affirmations[event.index].text,
            imageUrl: event.affirmations[event.index].imageUrl,
            category: event.affirmations[event.index].category);
        repository.addToFav(affirmation);
        event.affirmations[event.index] =
            event.affirmations[event.index].copyWith(isFav: true);
        repository.updateCurrentAffirmation(event.affirmations[event.index]);
        outerBloc.add(UpdateAffirmation(event.affirmations));
        print("reached AddToFav");
        yield LoadedPVState(affirmations: event.affirmations);
      }
    } else if (event is RemoveFromFav) {
      print("RemoveFromFav");
      if (event.affirmations[event.index].isFav) {
        AffirmationModel affirmation = new AffirmationModel(
            id: event.affirmations[event.index].cloudId,
            text: event.affirmations[event.index].text,
            imageUrl: event.affirmations[event.index].imageUrl,
            category: event.affirmations[event.index].category);
        repository.removeFromFav(affirmation);

        event.affirmations[event.index] =
            event.affirmations[event.index].copyWith(isFav: false);
        repository.updateCurrentAffirmation(event.affirmations[event.index]);
        outerBloc.add(UpdateAffirmation(event.affirmations));
        print("reached RemoveFromFav");
        yield LoadedPVState(affirmations: event.affirmations);
      }
    } else if (event is PageChanged) {
      print("PageChanged");
      if (!event.affirmations[event.toPage].read) {
        List<DayAffirmation> oldAffirmations = event.affirmations;
        event.affirmations[event.toPage] = event.affirmations[event.toPage]
            .copyWith(read: true, lastSeen: DateTime.now());
        repository.updateCurrentAffirmation(event.affirmations[event.toPage]);

        outerBloc.add(UpdateAffirmation(event.affirmations));
      }
    }
  }

  @override
  Future<void> close() async {
    await audioPlayer.release();

    return super.close();
  }

  Stream<AffirmationPVState> doOnLoad() async* {
    print(doOnLoad.toString() + " " + "");
    Failure failure;
  }
}
