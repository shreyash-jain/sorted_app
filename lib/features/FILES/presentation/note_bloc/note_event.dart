part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();
}

class TestEvent extends NoteEvent {
  @override
  List<Object> get props => [];
}

class UpdateNote extends NoteEvent {
  final NoteModel note;
  UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateBlockPosition extends NoteEvent {
  final List<BlockInfo> blocks;
  UpdateBlockPosition(this.blocks);

  @override
  List<Object> get props => [blocks];
}

class OpenAllBlocks extends NoteEvent {
  final NotesLoaded state;
  final int position;

  OpenAllBlocks(this.state, this.position);

  @override
  List<Object> get props => [state, position];
}

class AddImageBlock extends NoteEvent {
  final int position;
  AddImageBlock({
    this.position = 0,
  });
  @override
  List<Object> get props => [position];
}

class AddRichTextBlock extends NoteEvent {
  final int position;
  AddRichTextBlock({
    this.position = 0,
  });
  @override
  List<Object> get props => [position];
}

class AddTodolistBlock extends NoteEvent {
  final int position;
  AddTodolistBlock({
    this.position = 0,
  });
  @override
  List<Object> get props => [position];
}

class AddColossalBlock extends NoteEvent {
  final int position;
  AddColossalBlock({
    this.position = 0,
  });
  @override
  List<Object> get props => [position];
}

class EditSingleColossalImage extends NoteEvent {
  final int multiIndex;
  final File image;
  final EditColossal colossalState;
  EditSingleColossalImage(
      {this.image, this.multiIndex = 0, this.colossalState});
  @override
  List<Object> get props => [multiIndex, colossalState, image];
}
class UpdateSingleColossalImage extends NoteEvent {
  final int multiIndex;
  final File image;
  final EditColossal colossalState;
  UpdateSingleColossalImage(
      {this.image, this.multiIndex = 0, this.colossalState});
  @override
  List<Object> get props => [multiIndex, colossalState, image];
}


class AddLinkBlock extends NoteEvent {
  final int position;
  final LinkModel link;
  AddLinkBlock({
    this.link,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, link];
}

class UploadImageThenGoToNote extends NoteEvent {
  final NotesLoaded state;
  final int position;
  final File image;

  UploadImageThenGoToNote(this.state, this.position, this.image);
  @override
  List<Object> get props => [state, position, image];
}

class UploadMultipleImageThenGoToNote extends NoteEvent {
  final NotesLoaded state;
  final int position;
  final List<File> images;

  UploadMultipleImageThenGoToNote(this.state, this.position, this.images);
  @override
  List<Object> get props => [state, position, images];
}

class GoBackFromSelect extends NoteEvent {
  @override
  List<Object> get props => [];
}

class ChangeVisibility extends NoteEvent {
  final bool visible;
  ChangeVisibility(this.visible);

  @override
  List<Object> get props => [visible];
}

class OpenTodoitemMenu extends NoteEvent {
  final Function() openMenu;
  OpenTodoitemMenu(this.openMenu);

  @override
  List<Object> get props => [openMenu];
}

class UpdateBlock extends NoteEvent {
  final BlockInfo block;
  UpdateBlock(this.block);

  @override
  List<Object> get props => [block];
}
