import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/PROFILE/domain/repositories/profile_repository.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  ProfileBloc(this.repository) : super(ProfileInitial());
  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadProfile) {
      yield ProfileLoaded(
          bmi: 22.7,
          fitnessStrings: ["I do Exercise", "I do Yoga", "I ride Cycle"],
          mindfulStrings: ["I meditate", "I love my work"],
          productivityStrings: [
            "Read 15 articles",
            "Reading \"Getting work done\""
          ],
          personalityStrings: ["Spititual", "Calm", "Ambivert"],
          foodStrings: ["Vegetarian", "Sattvik"],
          sleepScore: 7.6,
          mentalHealthScore: 5.6,
          productivityScore: 8.9,
          vata: .1,
          pitta: .8,
          kapha: 1,
          sleepString: "Early bird");
    }
  }
}
