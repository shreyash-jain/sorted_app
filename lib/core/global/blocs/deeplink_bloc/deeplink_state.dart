part of 'deeplink_bloc.dart';

abstract class DeeplinkState extends Equatable {
  const DeeplinkState();
}

class DeeplinkInitial extends DeeplinkState {
  @override
  List<Object> get props => [];
}

class DeeplinkLoaded extends DeeplinkState {
  final DeepLinkType type;
  final ClassEnrollData classEnrollData;
  

  DeeplinkLoaded(this.type, this.classEnrollData);

  @override
  
  List<Object> get props => [type, classEnrollData];
}
