part of 'notes_bloc.dart';
abstract class NotesState extends Equatable {
  const NotesState();
}
class NotesInitial extends NotesState {
  @override
  List<Object> get props => [];
}
