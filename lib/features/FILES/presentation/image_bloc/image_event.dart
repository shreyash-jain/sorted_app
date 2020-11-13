part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class UpdateImage extends ImageEvent {
  final BlockInfo block;
  UpdateImage(this.block);

  @override
  List<Object> get props => [block];
}

class UpdateText extends ImageEvent {
  final TextboxBlock textblock;
  UpdateText(this.textblock);

  @override
  List<Object> get props => [textblock];
}

