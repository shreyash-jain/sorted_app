part of 'package_enroll_bloc.dart';

abstract class PackageEnrollEvent extends Equatable {
  const PackageEnrollEvent();
}

class GetExpertDetails extends PackageEnrollEvent {
  final String packageId;

  GetExpertDetails(this.packageId);

  @override
  List<Object> get props => [packageId];
}

class EnrollRequestEvent extends PackageEnrollEvent {
  final ConsultationPackageModel package;
  final ClientConsultationModel consultation;
  final DateTime startDate;

  EnrollRequestEvent(this.package, this.consultation, this.startDate);

  @override
  List<Object> get props => [package, consultation, startDate];
}
