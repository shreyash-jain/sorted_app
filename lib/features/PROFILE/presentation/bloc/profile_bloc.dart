import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/PROFILE/data/models/profile.dart';
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
      yield ProfileInitial();
      var userDetails = CacheDataClass.cacheData.getUserDetail();
      Failure failure;
      ProfileModel profile = ProfileModel();

      var errorOrProfile = await repository.getProfileFromCloud();
      errorOrProfile.fold((l) => failure = l, (r) => profile = r);
      if (failure == null) {
        print("hello  " + profile.mindfulness_skills.toString());
        yield ProfileLoaded(profile,userDetails??UserDetail());
      }
    }
  }
}
