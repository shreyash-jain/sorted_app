part of 'onstart_bloc.dart';

abstract class OnstartState extends Equatable {
   @override
  List<Object> get props => [];
}

class InitState extends OnstartState {}
class AccessDenied extends OnstartState {}
class AccessGranted extends OnstartState {
  


}
class Loading extends OnstartState {}
class Error extends OnstartState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}