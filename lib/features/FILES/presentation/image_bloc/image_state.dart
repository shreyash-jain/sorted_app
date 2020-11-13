part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();
}

class ImageInitial extends ImageState {
  @override
  List<Object> get props => [];
}

class ImageLoaded extends ImageState {
  final ImageBlock imageBlock;
  final BlockInfo blockInfo;

  ImageLoaded(this.imageBlock, this.blockInfo);
  @override
  List<Object> get props => [imageBlock, blockInfo];
}

class TextboxError extends ImageState {
  final String message;

  TextboxError({this.message});

  @override
  List<Object> get props => [message];
}
