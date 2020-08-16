import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'user_introduction_event.dart';
part 'user_introduction_state.dart';
class UserIntroductionBloc extends Bloc<UserIntroductionEvent, UserIntroductionState> {
  UserIntroductionBloc() : super(UserIntroductionInitial());
  @override
  Stream<UserIntroductionState> mapEventToState(
    UserIntroductionEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
