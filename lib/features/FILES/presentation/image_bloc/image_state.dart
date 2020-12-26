part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();
}

class ImageInitial extends ImageState {
  @override
  List<Object> get props => [];
}

class ImageLoading extends ImageState {
  @override
  List<Object> get props => [];
}

class ImageLoaded extends ImageState {
  final ImageBlock imageBlock;
  final BlockInfo blockInfo;
  final Size size;

  ImageLoaded(this.imageBlock, this.blockInfo, this.size);
  @override
  List<Object> get props => [imageBlock, blockInfo, size];
}

class ImageError extends ImageState {
  final String message;

  ImageError({this.message});

  @override
  List<Object> get props => [message];
}
