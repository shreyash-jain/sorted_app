import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
part 'interest_event.dart';
part 'interest_state.dart';

class UserInterestBloc extends Bloc<UserInterestEvent, UserInterestState> {
  UserInterestBloc({@required this.repository, @required this.flowBloc})
      : super(
          flowBloc.state is LoginState
              ? LoadedState((flowBloc.state as LoginState).userActivities)
              : LoadingState(),
        );

  final UserIntroductionBloc flowBloc;
  final UserIntroductionRepository repository;

  @override
  Stream<UserInterestState> mapEventToState(
    UserInterestEvent event,
  ) async* {
    if (event is Add) {
      final List<UserAModel> updatedUserActivities =
          List.from((state as LoadedState).activities)..add(event.activity);
      print(updatedUserActivities);
      flowBloc.add(UpdateUserActivities(updatedUserActivities));
      yield LoadedState(updatedUserActivities);
    } else if (event is Remove) {
      final List<UserAModel> updatedUserActivities = (state as LoadedState)
          .activities
          .where((element) => element.aId != event.activity.aId)
          .toList();
      flowBloc.add(UpdateUserActivities(updatedUserActivities));
      yield LoadedState(updatedUserActivities);
    }
  }
}
