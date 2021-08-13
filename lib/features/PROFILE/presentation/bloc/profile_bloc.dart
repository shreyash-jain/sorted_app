import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/models/health_profile.dart';
import 'package:sorted/core/global/models/user_details.dart';

import 'package:sorted/features/PROFILE/domain/repositories/profile_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/health_profile.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  final AuthenticationRepository authenticationRepository;
  ProfileBloc(this.repository, this.authenticationRepository)
      : super(ProfileInitial());
  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadProfile) {
      yield ProfileInitial();
      var userDetails = CacheDataClass.cacheData.getUserDetail();
      if (userDetails == null) {
        userDetails = UserDetail();
      }

      Failure failure;
      HealthProfile profile = HealthProfile();

      var errorOrProfile = await repository.getFitnessProfileFromCloud();
      errorOrProfile.fold((l) => failure = l, (r) => profile = r);
      if (failure == null) {
        //print("hello  " + profile.mindfulness_skills.toString());
        yield ProfileLoaded(profile, userDetails ?? UserDetail());
      }
    } else if (event is Signout) {

      
      authenticationRepository.logOut();
    }
  }
}
