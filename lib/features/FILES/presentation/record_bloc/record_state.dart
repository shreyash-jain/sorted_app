part of 'record_bloc.dart';

abstract class RecordState extends Equatable {
  const RecordState();
}

class RecordLoading extends RecordState {
  @override
  List<Object> get props => [];
}

class RecordLoaded extends RecordState {
  final List<String> categories;
  final List<String> categoriesDescription;
  final List<NotebookModel> everydayNotebooks;
  final List<NotebookModel> educationNotebooks;
  final List<NotebookModel> financeNotebooks;
  final List<NotebookModel> friendsNotebooks;
  final List<NotebookModel> selfloveNotebooks;
  final List<NotebookModel> blogsNotebooks;
  final List<NotebookModel> healthNotebooks;
  final List<NoteModel> recentNotes;

  RecordLoaded(
      this.everydayNotebooks,
      this.educationNotebooks,
      this.financeNotebooks,
      this.friendsNotebooks,
      this.selfloveNotebooks,
      this.blogsNotebooks,
      this.healthNotebooks,
      this.recentNotes, this.categories, this.categoriesDescription);
  @override
  List<Object> get props => [
        recentNotes,
        everydayNotebooks,
        educationNotebooks,
        categoriesDescription,
        financeNotebooks,
        friendsNotebooks,
        selfloveNotebooks,
        categories,
        blogsNotebooks,
        healthNotebooks
      ];
}

class RecordError extends RecordState {
  final String message;

  RecordError({this.message});

  @override
  List<Object> get props => [message];
}
