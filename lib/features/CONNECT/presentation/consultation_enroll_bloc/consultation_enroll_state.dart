part of 'consultation_enroll_bloc.dart';

abstract class ConsultationEnrollState extends Equatable {
  const ConsultationEnrollState();
}

class ConsultationEnrollInitial extends ConsultationEnrollState {
  @override
  List<Object> get props => [];
}

class ConsultationEnrollLoaded extends ConsultationEnrollState {
  final List<ConsultationPackageModel> packages;
  final List<int> userEnrollState;
  final ExpertProfileModel expertProfile;
  final List<List<String>> topics;
  final bool isLoading;
  final ExpertCalendarModel calendarModel;

  ConsultationEnrollLoaded(this.packages, this.userEnrollState,
      this.expertProfile, this.topics, this.isLoading, this.calendarModel);
  @override
  List<Object> get props => [
        isLoading,
        packages,
        userEnrollState,
        expertProfile,
        topics,
        calendarModel
      ];
}

class ConsultationEnrollError extends ConsultationEnrollState {
  final String message;

  ConsultationEnrollError(this.message);
  @override
  List<Object> get props => [message];
}

/// userEnrollState
// 0 -> class not enrolled
// 1 -> class already enrolled, but not accepted
// 2 => class already accepted
