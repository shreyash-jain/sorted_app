part of 'consultation_summary_bloc.dart';

abstract class ConsultationSummaryState extends Equatable {
  const ConsultationSummaryState();
}

class ConsultationSummaryInitial extends ConsultationSummaryState {
  @override
  List<Object> get props => [];
}

class ConsultationSummaryLoaded extends ConsultationSummaryState {
  ClientConsultationModel consultation;

  ConsultationSummaryLoaded(
    this.consultation,
  );
  @override
  List<Object> get props => [consultation];
}
