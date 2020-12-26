part of 'notes_hub_bloc.dart';

abstract class NotesHubState extends Equatable {
  const NotesHubState();
}

class NotesHubLoading extends NotesHubState {
  @override
  List<Object> get props => [];
}

class NotesHubLoaded extends NotesHubState {
  final NotebookModel thisNotebook;
  final List<NoteModel> notes;
  final List<String> notesText;
  final List<String> notesUrl;
  final List<bool> hasList;
  final List<bool> hasTable;
  final List<bool> hasCalendar;

  NotesHubLoaded(this.thisNotebook, this.notes, this.notesText, this.notesUrl,
      this.hasList, this.hasTable, this.hasCalendar);
  @override
  List<Object> get props => [
        thisNotebook,
        notes,
        notesText,
        notesUrl,
        hasList,
        hasTable,
        hasCalendar
      ];
}

class NotesHubError extends NotesHubState {
  final String message;

  NotesHubError({this.message});

  @override
  List<Object> get props => [message];
}
