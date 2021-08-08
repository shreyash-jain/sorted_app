part of 'package_enroll_bloc.dart';

abstract class PackageEnrollState extends Equatable {
  const PackageEnrollState();
}

class PackageEnrollInitial extends PackageEnrollState {
  @override
  List<Object> get props => [];
}

class PackageEnrollLoaded extends PackageEnrollState {
  final ConsultationPackageModel package;
  final int userEnrollState;
  final ExpertProfileModel expertProfile;
  final List<String> topics;
  final bool isLoading;
  final ExpertCalendarModel calendarModel;

  PackageEnrollLoaded(this.package, this.userEnrollState,
      this.expertProfile, this.topics, this.isLoading, this.calendarModel);
  @override
  List<Object> get props => [
        isLoading,
        package,
        userEnrollState,
        expertProfile,
        topics,
        calendarModel
      ];
}

class PackageEnrollError extends PackageEnrollState {
  final String message;

  PackageEnrollError(this.message);
  @override
  List<Object> get props => [message];
}

/// userEnrollState
// 0 -> class not enrolled
// 1 -> class already enrolled, but not accepted
// 2 => class already accepted
