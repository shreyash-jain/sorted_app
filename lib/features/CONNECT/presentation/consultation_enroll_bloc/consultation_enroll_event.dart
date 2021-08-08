part of 'consultation_enroll_bloc.dart';

abstract class ConsultationEnrollEvent extends Equatable {
  const ConsultationEnrollEvent();
}

class GetExpertDetails extends ConsultationEnrollEvent {
  final String trainerId;

  GetExpertDetails(this.trainerId);

  @override
  List<Object> get props => [trainerId];
}

class EnrollRequestEvent extends ConsultationEnrollEvent {
  final ConsultationPackageModel package;
  final ClientConsultationModel consultation;
  final DateTime startDate;

  EnrollRequestEvent(this.package, this.consultation, this.startDate);

  @override
  List<Object> get props => [package, consultation];
}
