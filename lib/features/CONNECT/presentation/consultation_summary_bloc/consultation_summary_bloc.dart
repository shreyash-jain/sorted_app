import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
part 'consultation_summary_event.dart';
part 'consultation_summary_state.dart';

class ConsultationSummaryBloc
    extends Bloc<ConsultationSummaryEvent, ConsultationSummaryState> {
  ConsultationSummaryBloc() : super(ConsultationSummaryInitial());
  @override
  Stream<ConsultationSummaryState> mapEventToState(
    ConsultationSummaryEvent event,
  ) async* {
    if (event is LoadClientSummary) {
      List<String> topic = [];

      ClientConsultationModel client = event.consultation;

      // Make state fields for payments

      yield ConsultationSummaryLoaded(client);
    }
  }
}
