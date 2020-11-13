part of 'textbox_bloc.dart';

abstract class TextboxEvent extends Equatable {
  const TextboxEvent();
}

class UpdateTextbox extends TextboxEvent {
  final BlockInfo block;
  UpdateTextbox(this.block);

  @override
  List<Object> get props => [block];
}

class UpdateText extends TextboxEvent {
  final TextboxBlock textblock;
  UpdateText(this.textblock);

  @override
  List<Object> get props => [textblock];
}

