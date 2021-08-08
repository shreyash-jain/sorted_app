part of 'deeplink_bloc.dart';

abstract class DeeplinkState extends Equatable {
  const DeeplinkState();
}

class DeeplinkInitial extends DeeplinkState {
  @override
  List<Object> get props => [];
}

class DeeplinkClassLoaded extends DeeplinkState {
  final DeepLinkType type;
  final ClassEnrollData classEnrollData;

  DeeplinkClassLoaded(this.type, this.classEnrollData);

  @override
  List<Object> get props => [type, classEnrollData];
}

class DeeplinkConsultationLoaded extends DeeplinkState {
  final DeepLinkType type;

  final ConsultationEnrollData consultationEnrollData;

  DeeplinkConsultationLoaded(this.type, this.consultationEnrollData);

  @override
  List<Object> get props => [type, consultationEnrollData];
}

class DeeplinkPackageLoaded extends DeeplinkState {
  final DeepLinkType type;

  final PackageEnrollData packageEnrollData;

  DeeplinkPackageLoaded(this.type, this.packageEnrollData);

  @override
  List<Object> get props => [type, packageEnrollData];
}
