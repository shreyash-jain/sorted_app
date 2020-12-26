part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class GetImage extends ImageEvent {
  final BlockInfo block;
  GetImage(this.block);

  @override
  List<Object> get props => [block];
}

class UpdateImage extends ImageEvent {
  final File image;
  final ImageBlock imageBlock;
  final BlockInfo blockInfo;
  UpdateImage(this.image, this.imageBlock, this.blockInfo);

  @override
  List<Object> get props => [image, imageBlock, blockInfo];
}

class StartUploadImage extends ImageEvent {
  final BuildContext context;
  final BlockInfo blockInfo;
  final ImageBlock image;
  StartUploadImage(this.image, this.context, this.blockInfo);

  @override
  List<Object> get props => [image, context, blockInfo];
}
