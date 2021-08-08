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
    if (event is AddDeeplinkData) {
      print("bloc data from deep link   -   >   none");
      yield DeeplinkInitial();
      if (event.type.type == 1)
        yield DeeplinkClassLoaded(
          event.type,
          event.classEnrollData,
        );
      else if (event.type.type == 2)
        yield DeeplinkConsultationLoaded(
          event.type,
          event.consultationEnrollData,
        );
      else if (event.type.type == 3) {
        yield DeeplinkPackageLoaded(
          event.type,
          event.packageEnrollData,
        );
      }
    } else if (event is ResetData) {
      yield DeeplinkInitial();
    }
  }
}
