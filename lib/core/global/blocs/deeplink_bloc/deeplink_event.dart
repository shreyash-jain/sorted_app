part of 'deeplink_bloc.dart';

abstract class DeeplinkEvent extends Equatable {
  const DeeplinkEvent();
}

class AddDeeplinkClassData extends DeeplinkEvent {
  final DeepLinkType type;
  final ClassEnrollData classEnrollData;

  AddDeeplinkClassData(this.type, this.classEnrollData);

  @override
 
  List<Object> get props => [type, classEnrollData];
}


class ResetData extends DeeplinkEvent {
  @override
  
  List<Object> get props => [];

}