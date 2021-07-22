import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'connect_event.dart';
part 'connect_state.dart';
class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  ConnectBloc() : super(ConnectInitial());
  @override
  Stream<ConnectState> mapEventToState(
    ConnectEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
