import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/models/auth_user.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    UserIntroductionRepository userIntroRepository,
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        assert(userIntroRepository != null),
        _authenticationRepository = authenticationRepository,
        _userIntroRepository = userIntroRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserIntroductionRepository _userIntroRepository;
  StreamSubscription<NativeUser> _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      var fOrD = await _userIntroRepository.getUserDetailsNative();
      yield* _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      Either<Failure, User> user =
          await _authenticationRepository.currentUser();
      user.fold((l) => print("user already Logged out"),
          (r) => unawaited(_authenticationRepository.logOut()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  Stream<AuthenticationState> _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) async* {
    if (event.user == NativeUser.empty) {
      yield const AuthenticationState.unauthenticated();
    } else {
      print("check native user details");
      var fOrD = await _userIntroRepository.getUserDetailsNative();
      yield fOrD.fold((l) => const AuthenticationState.unauthenticated(), (r) {
        if (r.id == "") {
          print("auth but not recognized ");
          return const AuthenticationState.unauthenticated();
        } else {
          print("auth but recognized ");
          
          CacheDataClass.cacheData.setUserDetail(r);
          return AuthenticationState.authenticated(event.user);
        }
      });
    }
  }
}
