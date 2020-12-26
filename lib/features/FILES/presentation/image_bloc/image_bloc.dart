import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/image_edit.dart';
import 'package:zefyr/zefyr.dart';
part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final NoteRepository noteRepository;
  final NoteBloc noteBloc;
  ImageBloc(this.noteRepository, this.noteBloc) : super(ImageInitial());
  @override
  Stream<ImageState> mapEventToState(
    ImageEvent event,
  ) async* {
    if (event is GetImage) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      ImageBlock imageBlock;
      var textboxOrFailure =
          await noteRepository.getImageOfId(event.block.itemId);
      textboxOrFailure.fold((l) {
        failure = l;
      }, (r) {
        imageBlock = r;
      });
      print("whats url " + imageBlock.id.toString());
      print("whats url " + imageBlock.url);
      Size size = await _calculateImageDimension(imageBlock.url);
      if (failure == null) yield ImageLoaded(imageBlock, event.block, size);
    } else if (event is StartUploadImage) {
      File result;
      Failure failure;

      result = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        print(result.path);
        print(result.uri);
        Navigator.push(
            event.context,
            FadeRoute(
                page: ImageEdit(
              blockInfo: event.blockInfo,
              imageBlock: event.image,
              imageBloc: this,
              initialFile: result,
            )));
      }
    } else if (event is UpdateImage) {
      yield ImageLoading();
      File editedImage = event.image;
      DateTime now = DateTime.now();
      Failure failure;
      ImageBlock selectedImageBlock = event.imageBlock;

      if (editedImage != null) {
        //var decodedImage = await decodeImageFromList(result.readAsBytesSync());
        ImageModel newImage = new ImageModel(
            caption: "",
            id: selectedImageBlock.id,
            localPath: (editedImage.path),
            savedTs: now,
            position: 0);

        selectedImageBlock =
            selectedImageBlock.copyWith(imagePath: editedImage.path);

        var imageOrFailure =
            await noteRepository.storeImage(newImage, editedImage);

        imageOrFailure.fold((l) {
          failure = l;
          print("error in store");
        }, (r) {
          newImage = r;
        });

        ImageBlock imageBlock = ImageBlock(
            id: newImage.id,
            url: newImage.url,
            remotePath: newImage.storagePath,
            savedTs: newImage.savedTs.millisecondsSinceEpoch);

        await noteRepository.updateImageBlock(imageBlock);
        Size size = await _calculateImageDimension(imageBlock.url);
        if (failure == null)
          yield ImageLoaded(imageBlock, event.blockInfo, size);
      }
    }
  }

  Future<File> urlToFile(ImageBlock image) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file =
        new File("IMG-" + '$tempPath' + rng.nextDouble().toString() + '.jpg');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(image.url);
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  Future<Size> _calculateImageDimension(String url) {
    Completer<Size> completer = Completer();
    Image image = new Image(
        image: CachedNetworkImageProvider(url)); // I modified this line
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
