import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'user_recommendation_event.dart';
part 'user_recommendation_state.dart';
class UserRecommendationBloc extends Bloc<UserRecommendationEvent, UserRecommendationState> {
  UserRecommendationBloc() : super(UserRecommendationInitial());
  @override
  Stream<UserRecommendationState> mapEventToState(
    UserRecommendationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
