part of 'pep_talk_bloc.dart';
abstract class PeptalkEvent extends Equatable {
  const PeptalkEvent();
}


class GetPeptalk extends PeptalkEvent{
  @override

  List<Object> get props => [];

}