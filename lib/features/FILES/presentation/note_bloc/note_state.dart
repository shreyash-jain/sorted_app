part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();
}

class NoteLoading extends NoteState {
  @override
  List<Object> get props => [];
}

class NotesLoaded extends NoteState {
  final List<BlockInfo> blocks;
  final NoteModel note;
  final LinkedHashMap<int, Widget> board;
  final bool isBottomNavVisible;

  NotesLoaded(this.blocks, this.note, this.board, this.isBottomNavVisible);
  @override
  List<Object> get props => [blocks, note, isBottomNavVisible, board];
}

class OpenSelectBlock extends NoteState {
  final NotesLoaded prevNotesLoadedState;
  final int position;

  OpenSelectBlock(this.prevNotesLoadedState, this.position);
  @override
  List<Object> get props => [prevNotesLoadedState, position];
}

class EditImageBlock extends NoteState {
  final NotesLoaded prevNotesLoadedState;
  final int position;
  final File imageFile;
  final bool isSingleImage;
  final int multiIndex;
  final EditColossal colossalState;

  EditImageBlock(this.prevNotesLoadedState, this.position, this.imageFile,
      this.isSingleImage, this.multiIndex, this.colossalState);
  @override
  List<Object> get props =>
      [prevNotesLoadedState, position, imageFile, multiIndex, colossalState];
}

class EditColossal extends NoteState {
  final NotesLoaded prevNotesLoadedState;
  final int position;
  final List<File> imageFiles;
  final int isUploading;

  EditColossal(this.prevNotesLoadedState, this.position, this.imageFiles,
      this.isUploading);
  @override
  List<Object> get props =>
      [prevNotesLoadedState, position, imageFiles, isUploading];
}

class NoteError extends NoteState {
  final String message;

  NoteError({this.message});

  @override
  List<Object> get props => [message];
}
