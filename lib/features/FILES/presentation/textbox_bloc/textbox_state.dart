part of 'textbox_bloc.dart';

abstract class TextboxState extends Equatable {
  const TextboxState();
}

class TextboxInitial extends TextboxState {
  @override
  List<Object> get props => [];
}

class Textboxloaded extends TextboxState {
  final TextboxBlock textboxBlock;
  final BlockInfo blockInfo;

  Textboxloaded(this.textboxBlock, this.blockInfo);
  @override
  List<Object> get props => [textboxBlock, blockInfo];
}

class TextboxError extends TextboxState {
  final String message;

  TextboxError({this.message});

  @override
  List<Object> get props => [message];
}
