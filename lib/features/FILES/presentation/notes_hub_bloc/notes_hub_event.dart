part of 'notes_hub_bloc.dart';

abstract class NotesHubEvent extends Equatable {
  const NotesHubEvent();
}

class TestEvent extends NotesHubEvent {
  @override
  List<Object> get props => [];
}

class GetNotesHubInitialData extends NotesHubEvent {
  final NotebookModel thisNotebook;

  GetNotesHubInitialData(this.thisNotebook);
  @override
  List<Object> get props => [thisNotebook];
}

class AddNewRecord extends NotesHubEvent {
  final int type;
  final NotebookModel notebook;
  final BuildContext context;

  AddNewRecord(this.type, this.notebook, this.context);

  @override
  List<Object> get props => [type, notebook, ];
}
