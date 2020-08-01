import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'finances_event.dart';
part 'finances_state.dart';
class FinancesBloc extends Bloc<FinancesEvent, FinancesState> {
  FinancesBloc() : super(FinancesInitial());
  @override
  Stream<FinancesState> mapEventToState(
    FinancesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
