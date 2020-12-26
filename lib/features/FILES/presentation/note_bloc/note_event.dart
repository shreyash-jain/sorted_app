part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();
}

class TestEvent extends NoteEvent {
  @override
  List<Object> get props => [];
}

class GetNote extends NoteEvent {
  final NoteModel note;
  GetNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNoteElements extends NoteEvent {
  final NoteModel note;
  UpdateNoteElements(this.note);

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

class AddHeading extends NoteEvent {
  final int position;
  final FormFieldBlock formField;
  AddHeading({
    this.formField,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, formField];
}

class AddSlider extends NoteEvent {
  final int position;
  final SliderBlock sliderData;
  AddSlider({
    this.sliderData,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, sliderData];
}

class AddDate extends NoteEvent {
  final int position;
  final FormFieldBlock dateData;
  AddDate({
    this.dateData,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, dateData];
}

class AddAuther extends NoteEvent {
  final int position;
  final FormFieldBlock autherData;
  AddAuther({
    this.autherData,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, autherData];
}

class AddSequence extends NoteEvent {
  final int position;
  final SequenceBlock data;
  AddSequence({
    this.data,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, data];
}

class AddYoutubeVideo extends NoteEvent {
  final int position;
  final YoutubeBlock data;
  AddYoutubeVideo({
    this.data,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, data];
}

class AddTable extends NoteEvent {
  final int position;

  AddTable({
    this.position = 0,
  });
  @override
  List<Object> get props => [position];
}

class AddPassword extends NoteEvent {
  final int position;
  final FormFieldBlock item;

  AddPassword({
    this.item,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, item];
}

class AddCalendar extends NoteEvent {
  final int position;
  final CalendarBlock data;
  AddCalendar({
    this.data,
    this.position = 0,
  });
  @override
  List<Object> get props => [position, data];
}

class UpdateAir extends NoteEvent {
  final bool inAir;

  UpdateAir({
    this.inAir,
  });
  @override
  List<Object> get props => [inAir];
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
