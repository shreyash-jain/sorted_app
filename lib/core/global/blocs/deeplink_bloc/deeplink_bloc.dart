import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/global/models/deep_link_data/deep_link_data.dart';
part 'deeplink_event.dart';
part 'deeplink_state.dart';

class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
  DeeplinkBloc() : super(DeeplinkInitial());
  @override
  Stream<DeeplinkState> mapEventToState(
    DeeplinkEvent event,
  ) async* {
    if (event is AddDeeplinkClassData) {
      print("bloc data from deep link   -   >   none");
      yield DeeplinkInitial();
      
      
      yield DeeplinkLoaded(event.type, event.classEnrollData);
    } else if (event is ResetData) {
      yield DeeplinkInitial();
    }
  }
}
