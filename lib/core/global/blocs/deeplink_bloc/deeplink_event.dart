part of 'deeplink_bloc.dart';

abstract class DeeplinkEvent extends Equatable {
  const DeeplinkEvent();
}

class AddDeeplinkData extends DeeplinkEvent {
  final DeepLinkType type;
  final ClassEnrollData classEnrollData;
  final ConsultationEnrollData consultationEnrollData;
  final PackageEnrollData packageEnrollData;

  AddDeeplinkData(this.type,
      {this.classEnrollData,
      this.consultationEnrollData,
      this.packageEnrollData});

  @override
  List<Object> get props => [type, classEnrollData];
}

class ResetData extends DeeplinkEvent {
  @override
  List<Object> get props => [];
}
