part of 'diary_bloc.dart';
abstract class DiaryState extends Equatable {
  const DiaryState();
}
class DiaryInitial extends DiaryState {
  @override
  List<Object> get props => [];
}
