part of 'consultation_summary_bloc.dart';

abstract class ConsultationSummaryEvent extends Equatable {
  const ConsultationSummaryEvent();
}

class LoadClientSummary extends ConsultationSummaryEvent {
  final ClientConsultationModel consultation;

  LoadClientSummary(this.consultation);
  @override
  List<Object> get props => [consultation];
}
