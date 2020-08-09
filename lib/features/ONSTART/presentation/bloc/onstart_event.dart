part of 'onstart_bloc.dart';
abstract class OnstartEvent extends Equatable {
   @override
  List<Object> get props => [];
}
class GetLocalAuthDone extends OnstartEvent {}