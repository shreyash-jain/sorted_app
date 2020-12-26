import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as ht;
import 'package:path/path.dart' as p;
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/FILES/data/models/block_calendar.dart';
import 'package:sorted/features/FILES/data/models/block_column.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_image_colossal.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_sequence.dart';
import 'package:sorted/features/FILES/data/models/block_slider.dart';
import 'package:sorted/features/FILES/data/models/block_table.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/block_youtube.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/calendar_bloc/calendar_bloc.dart';
import 'package:sorted/features/FILES/presentation/colossal_bloc/colossal_bloc.dart';
import 'package:sorted/features/FILES/presentation/date_bloc/date_bloc.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/link_bloc/link_bloc.dart';
import 'package:sorted/features/FILES/presentation/password_bloc/password_bloc.dart';
import 'package:sorted/features/FILES/presentation/sequence_bloc/sequence_bloc.dart';
import 'package:sorted/features/FILES/presentation/slider_bloc/slider_bloc.dart';
import 'package:sorted/features/FILES/presentation/table_bloc/table_bloc.dart';
import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/todolist_bloc/todolist_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/add_column.dart';
import 'package:sorted/features/FILES/presentation/widgets/auther_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/calendar_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/colossal_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/date_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/heading_menu.dart';
import 'package:sorted/features/FILES/presentation/widgets/heading_widget.dart';

import 'package:sorted/features/FILES/presentation/widgets/image_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/link_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/password_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/sequence_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/slider_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/todo_item_menu.dart';
import 'package:sorted/features/FILES/presentation/widgets/todolist_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/youtube_widget.dart';
import 'package:sorted/features/FILES/presentation/youtube_bloc/todolist_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_link.dart';
import 'package:string_validator/string_validator.dart';
part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;
  final TodoRepository todoRepository;
  LinkedHashMap<int, Widget> typeToWidgetMap = LinkedHashMap();

  var _newMediaLinkAddressController = TextEditingController();
  NoteBloc(this.noteRepository, this.todoRepository) : super(NoteLoading());

  Widget richTextWidget(BlockInfo element) {
    //! type : 0
    return BlocProvider(
        create: (_) => TextboxBloc(sl(), this),
        child: TextboxWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget imageWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => ImageBloc(sl(), this),
        child: ImageWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget todoWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => TodolistBloc(sl(), this, sl()),
        child: TodoitemWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
          openMenu: openTodoItemMenu,
        ));
  }

  Widget linkWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => LinkBloc(sl(), this),
        child: LinkWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget colossalWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => ColossalBloc(sl(), this),
        child: ColossalWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget formfieldWidget(BlockInfo element) {
    return SizedBox();
  }

  Widget headingWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => HeadingBloc(sl(), this),
        child: HeadingWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          openMenu: openHeadingMenu,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget sliderWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => SliderBloc(sl(), this),
        child: SliderWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          openMenu: openSliderMenu,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget passwordWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => PasswordBloc(sl(), this),
        child: PasswordWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget sequenceWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => SequenceBloc(sl(), this),
        child: SequenceWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          openMenu: openSequenceMenu,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget dateWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => DateBloc(sl(), this),
        child: DateWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget autherWidget(BlockInfo element) {
    return AutherWidget(
      key: ObjectKey(element.id),
      blockInfo: element,
      noteBloc: this,
      updateBlockInfo: updateBlockInfo,
      updateDecoration: updateDecoration,
    );
  }

  Widget checkboxWidget(BlockInfo element) {
    return SizedBox();
  }

  Widget tableWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => TableBloc(sl(), this),
        child: TableWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget calendarWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => CalendarBloc(sl(), this, sl()),
        child: CalendarWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  Widget youtubeWidget(BlockInfo element) {
    return BlocProvider(
        create: (_) => YoutubeBloc(sl(), this),
        child: YoutubeWidget(
          key: ObjectKey(element.id),
          blockInfo: element,
          noteBloc: this,
          updateBlockInfo: updateBlockInfo,
          updateDecoration: updateDecoration,
        ));
  }

  @override
  Stream<NoteState> mapEventToState(
    NoteEvent event,
  ) async* {
    if (event is TestEvent) {
      NoteModel newNote = new NoteModel(id: 1, title: "First note");
      await noteRepository.addNote(newNote);
      TextboxBlock textbox1 = TextboxBlock.startTextbox(1, "title1");
      TextboxBlock textbox2 = TextboxBlock.startTextbox(2, "title2");
      await noteRepository.addTextbox(textbox1);
      await noteRepository.addTextbox(textbox2);

      BlockInfo b1 = BlockInfo(id: 1, position: 0, type: 0, itemId: 1);
      BlockInfo b2 = BlockInfo(id: 2, position: 1, type: 0, itemId: 2);
      await noteRepository.addBlockInfo(b1);
      await noteRepository.addBlockInfo(b2);

      await noteRepository.linkNoteAndBlock(newNote, b1, 1);
      await noteRepository.linkNoteAndBlock(newNote, b2, 2);
    } else if (event is UpdateNoteElements) {
      print("pp1" + event.note.toString());
      print("pp12" + (state as NotesLoaded).note.toString());

      yield NotesLoaded(
          (state as NotesLoaded).blocks,
          event.note,
          (state as NotesLoaded).board,
          (state as NotesLoaded).isBottomNavVisible,
          false);
      print("pp1" + event.note.toString());

      noteRepository.updateNote(event.note);
    } else if (event is GetNote) {
      Failure failure;
      List<BlockInfo> blocks;
      var blocksOrFailure = await noteRepository.getBlocksOfNote(event.note);
      blocksOrFailure.fold((l) {
        failure = l;
      }, (r) {
        blocks = r;
        print(blocks.length);
      });
      Widget wid;
      LinkedHashMap<int, Widget> board = LinkedHashMap();
      print("position blocks.length  " + blocks.length.toString());
      if (failure == null)
        blocks.forEach((element) {
          print("position " + element.position.toString());
          if (element.type == 0) {
            wid = richTextWidget(element);
          } else if (element.type == 2) {
            wid = imageWidget(element);
          } else if (element.type == 3) {
            wid = todoWidget(element);
          } else if (element.type == 4) {
            wid = linkWidget(element);
          } else if (element.type == 5) {
            wid = colossalWidget(element);
          } else if (element.type == 6) {
            wid = headingWidget(element);
          } else if (element.type == 7) {
            wid = sliderWidget(element);
          } else if (element.type == 8) {
            wid = tableWidget(element);
          } else if (element.type == 9) {
            wid = sequenceWidget(element);
          } else if (element.type == 10) {
            wid = dateWidget(element);
          } else if (element.type == 11) {
            wid = calendarWidget(element);
          } else if (element.type == 12) {
            wid = youtubeWidget(element);
          } else if (element.type == 13) {
            wid = autherWidget(element);
          } else if (element.type == 14) {
            wid = passwordWidget(element);
          }

          board.addAll({
            element.id: wid,
          });
        });

      if (failure == null)
        yield NotesLoaded(blocks, event.note, board, true, false);
    } else if (event is UpdateBlockPosition) {
      print("UpdateBlockPosition");
      print((state as NotesLoaded).blocks);
      print(event.blocks);
      yield NotesLoaded(
          event.blocks,
          (state as NotesLoaded).note,
          (state as NotesLoaded).board,
          (state as NotesLoaded).isBottomNavVisible,
          false);
      for (int i = 0; i < event.blocks.length; i++) {
        if (event.blocks[i].position != i) {
          noteRepository.updateBlockInfo(event.blocks[i].copyWith(position: i));
        }
      }
    } else if (event is UpdateAir) {
      print("UpdateAir  " + event.inAir.toString());
      print((state as NotesLoaded).blocks);

      yield NotesLoaded(
          (state as NotesLoaded).blocks,
          (state as NotesLoaded).note,
          (state as NotesLoaded).board,
          (state as NotesLoaded).isBottomNavVisible,
          event.inAir);
    } else if (event is UpdateBlock) {
      List<BlockInfo> newBlocks = [];
      List<BlockInfo> currentBlocks = (state as NotesLoaded).blocks;
      int index = currentBlocks.indexOf(event.block);
      print(event.block);
      print(currentBlocks);
      if (index == -1) {
        currentBlocks.forEach((element) {
          if (element.id != event.block.id) {
            newBlocks.add(element);
          } else {
            newBlocks.add(element.copyWith(height: event.block.height));
          }
        });
        print("state changed due to height");
        yield NotesLoaded(
            newBlocks,
            (state as NotesLoaded).note,
            (state as NotesLoaded).board,
            (state as NotesLoaded).isBottomNavVisible,
            false);
      }
    } else if (event is ChangeVisibility) {
      print("ChangeVisbility");
      yield NotesLoaded(
          (state as NotesLoaded).blocks,
          (state as NotesLoaded).note,
          (state as NotesLoaded).board,
          event.visible,
          false);
    } else if (event is OpenAllBlocks) {
      print("OpenAllBlocks");
      yield OpenSelectBlock(event.state, event.position);
    } else if (event is GoBackFromSelect) {
      yield (state as OpenSelectBlock).prevNotesLoadedState;
    } else if (event is EditSingleColossalImage) {
      yield EditImageBlock(
          event.colossalState.prevNotesLoadedState,
          event.colossalState.position,
          event.image,
          false,
          event.multiIndex,
          event.colossalState);
    } else if (event is UpdateSingleColossalImage) {
      List<File> prevFiles = event.colossalState.imageFiles;
      prevFiles[event.multiIndex] = event.image;

      yield EditColossal(event.colossalState.prevNotesLoadedState,
          event.colossalState.position, prevFiles, -1);
    } else if (event is AddColossalBlock) {
      List<File> result;
      Failure failure;

      result = await FilePicker.getMultiFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.length > 0) {}

      yield EditColossal((state as OpenSelectBlock).prevNotesLoadedState,
          event.position, result, -1);
    } else if (event is AddImageBlock) {
      File result;
      Failure failure;

      result = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        print(result.path);
        print(result.uri);

        print(p.basename(result.path));
      }

      yield EditImageBlock((state as OpenSelectBlock).prevNotesLoadedState,
          event.position, result, true, 0, null);
      // if (result != null) {
      //   //var decodedImage = await decodeImageFromList(result.readAsBytesSync());

      //   ImageModel newImage = new ImageModel(
      //       caption: "",
      //       id: now.millisecondsSinceEpoch,
      //       localPath: p.basename(result.path),
      //       savedTs: now,
      //       position: 0);
      //   print("before");
      //   NotesLoaded notesPrevState =
      //       (state as OpenSelectBlock).prevNotesLoadedState;

      //   List<BlockInfo> prevBlocks =
      //       (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      //   LinkedHashMap<int, Widget> prevBoard =
      //       (state as OpenSelectBlock).prevNotesLoadedState.board;
      //   BlockInfo loadingBlock = BlockInfo(
      //     height: 6,
      //     type: 1,
      //     id: -1,
      //     savedTs: now.millisecondsSinceEpoch,
      //     position: event.position,
      //     itemId: 0,
      //   );
      //   Widget w = Container(
      //       height: 6,
      //       child: LinearProgressIndicator(
      //         minHeight: 6,
      //       ));

      //   prevBoard.addAll({
      //     loadingBlock.id: w,
      //   });
      //   prevBlocks.insert(event.position, loadingBlock);
      //   print(prevBlocks.length.toString() + " blocks");
      //   print(prevBoard.length.toString() + " board");
      //   yield (NotesLoaded(
      //       prevBlocks,
      //       (state as OpenSelectBlock).prevNotesLoadedState.note,
      //       prevBoard,
      //       (state as OpenSelectBlock)
      //           .prevNotesLoadedState
      //           .isBottomNavVisible));

      //   var imageOrFailure = await noteRepository.storeImage(newImage, result);

      //   prevBoard.remove(-1);
      //   prevBlocks.removeAt(event.position);
      //   imageOrFailure.fold((l) {
      //     failure = l;
      //   }, (r) {
      //     newImage = r;
      //   });

      //   ImageBlock imageBlock = ImageBlock(
      //       id: newImage.id,
      //       url: newImage.url,
      //       remotePath: newImage.storagePath,
      //       savedTs: newImage.savedTs.millisecondsSinceEpoch);

      //   loadingBlock = BlockInfo(
      //     height: 160,
      //     type: 2,
      //     id: now.millisecondsSinceEpoch,
      //     savedTs: now.millisecondsSinceEpoch,
      //     position: event.position,
      //     itemId: imageBlock.id,
      //   );
      //   await noteRepository.addImageBlock(imageBlock);
      //   w = BlocProvider(
      //       create: (_) => ImageBloc(sl(), this),
      //       child: ImageWidget(
      //         key: ObjectKey(loadingBlock.id),
      //         blockInfo: loadingBlock,
      //         noteBloc: this,
      //         updateBlockInfo: updateBlockInfo,
      //         updateDecoration: updateDecoration,
      //       ));

      //   prevBoard.addAll({
      //     loadingBlock.id: w,
      //   });
      //   prevBlocks.insert(event.position, loadingBlock);

      //   yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
      //       notesPrevState.isBottomNavVisible));
      //   await noteRepository.addBlockInfo(loadingBlock);

      //   noteRepository.linkNoteAndBlock(
      //       notesPrevState.note, loadingBlock, now.millisecondsSinceEpoch);
      // }
    } else if (event is UploadMultipleImageThenGoToNote) {
      DateTime now = DateTime.now();
      ImageModel newImage;
      EditColossal nowState = state as EditColossal;
      List<BlockInfo> prevBlocks = nowState.prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          nowState.prevNotesLoadedState.board;
      Failure failure;
      List<ImageBlock> imageBlocks = [];

      var result = event.images;
      var documentDirectory = await getApplicationDocumentsDirectory();

      if (result != null && result.length > 0) {
        //var decodedImage = await decodeImageFromList(result.readAsBytesSync());
        ColossalBlock thisColossal =
            new ColossalBlock(id: now.millisecondsSinceEpoch);
        for (int i = 0; i < result.length; i++) {
          String localPath =
              documentDirectory.path + "/" + p.basename(result[i].path);
          File file = new File(localPath);

          var savedFile = await result[i].copy(localPath);
          print(savedFile.toString() + "  shreyash");

          ImageBlock thisBlock = ImageBlock(
              id: now.millisecondsSinceEpoch + i,
              colossalId: thisColossal.id,
              imagePath: savedFile.path);
          imageBlocks.add(thisBlock);
          await noteRepository.addImageBlock(thisBlock);
        }

        await noteRepository.addImagesInColossal(thisColossal, imageBlocks);
        Widget w = SizedBox(
          height: 0,
        );
        BlockInfo newBlock = BlockInfo(
          height: 200,
          type: 5,
          id: now.millisecondsSinceEpoch,
          savedTs: now.millisecondsSinceEpoch,
          position: event.position,
          itemId: thisColossal.id,
        );

        w = BlocProvider(
            create: (_) => ColossalBloc(sl(), this),
            child: ColossalWidget(
              key: ObjectKey(newBlock.id),
              blockInfo: newBlock,
              noteBloc: this,
              updateBlockInfo: updateBlockInfo,
              updateDecoration: updateDecoration,
            ));

        prevBoard.addAll({
          newBlock.id: w,
        });
        prevBlocks.insert(event.position, newBlock);

        yield (NotesLoaded(
            prevBlocks,
            nowState.prevNotesLoadedState.note,
            prevBoard,
            nowState.prevNotesLoadedState.isBottomNavVisible,
            false));
        await noteRepository.addBlockInfo(newBlock);

        noteRepository.linkNoteAndBlock(nowState.prevNotesLoadedState.note,
            newBlock, now.millisecondsSinceEpoch);

        uploadImageAndSaveData(result, imageBlocks, thisColossal);
      }
    } else if (event is UploadImageThenGoToNote) {
      DateTime now = DateTime.now();
      Failure failure;
      var result = event.image;
      print("UploadImageThenGoToNote " + event.image.path);
      print("UploadImageThenGoToNote " + event.image.uri.toString());
      print("UploadImageThenGoToNote " + event.image.absolute.toString());
      print("UploadImageThenGoToNote");
      if (result != null) {
        //var decodedImage = await decodeImageFromList(result.readAsBytesSync());

        ImageModel newImage = new ImageModel(
            caption: "",
            id: now.millisecondsSinceEpoch,
            localPath: (result.path),
            savedTs: now,
            position: 0);
        print("before");
        NotesLoaded notesPrevState = event.state;

        List<BlockInfo> prevBlocks = notesPrevState.blocks;
        LinkedHashMap<int, Widget> prevBoard = notesPrevState.board;
        BlockInfo loadingBlock;
        Widget w = SizedBox(
          height: 0,
        );

        print(prevBlocks.length.toString() + " blocks");
        print(prevBoard.length.toString() + " board");

        var imageOrFailure = await noteRepository.storeImage(newImage, result);

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

        loadingBlock = BlockInfo(
          height: 160,
          type: 2,
          id: now.millisecondsSinceEpoch,
          savedTs: now.millisecondsSinceEpoch,
          position: event.position,
          itemId: imageBlock.id,
        );
        await noteRepository.addImageBlock(imageBlock);
        w = BlocProvider(
            create: (_) => ImageBloc(sl(), this),
            child: ImageWidget(
              key: ObjectKey(loadingBlock.id),
              blockInfo: loadingBlock,
              noteBloc: this,
              updateBlockInfo: updateBlockInfo,
              updateDecoration: updateDecoration,
            ));

        prevBoard.addAll({
          loadingBlock.id: w,
        });
        prevBlocks.insert(event.position, loadingBlock);

        yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
            notesPrevState.isBottomNavVisible, false));
        await noteRepository.addBlockInfo(loadingBlock);

        noteRepository.linkNoteAndBlock(
            notesPrevState.note, loadingBlock, now.millisecondsSinceEpoch);
      }
    } else if (event is AddRichTextBlock) {
      DateTime now = DateTime.now();

      TextboxBlock textboxBlock = TextboxBlock(
          id: now.millisecondsSinceEpoch,
          title: "New Textbox",
          savedTs: now.millisecondsSinceEpoch);

      BlockInfo textBlock = BlockInfo(
        height: 160,
        type: 0,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: textboxBlock.id,
      );
      await noteRepository.addTextbox(textboxBlock);

      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;
      Widget w = BlocProvider(
          create: (_) => TextboxBloc(sl(), this),
          child: TextboxWidget(
            key: ObjectKey(textBlock.id),
            blockInfo: textBlock,
            noteBloc: this,
            updateBlockInfo: updateBlockInfo,
            updateDecoration: updateDecoration,
          ));

      prevBoard.addAll({
        textBlock.id: w,
      });
      prevBlocks.insert(event.position, textBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(textBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, textBlock, now.millisecondsSinceEpoch);
    } else if (event is AddDate) {
      DateTime now = DateTime.now();

      FormFieldBlock dateBlock = FormFieldBlock(
          id: now.millisecondsSinceEpoch,
          field: now.toIso8601String(),
          savedTs: now.millisecondsSinceEpoch);

      BlockInfo seqBlockInfo = BlockInfo(
        height: 160,
        type: 10,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: dateBlock.id,
      );
      await noteRepository.addFormFieldBlock(dateBlock);

      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;
      Widget w = dateWidget(seqBlockInfo);

      prevBoard.addAll({
        seqBlockInfo.id: w,
      });
      prevBlocks.insert(event.position, seqBlockInfo);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(seqBlockInfo);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, seqBlockInfo, now.millisecondsSinceEpoch);
    } else if (event is AddAuther) {
      DateTime now = DateTime.now();

      BlockInfo autherBlockInfo = BlockInfo(
        height: 80,
        type: 13,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: 0,
      );

      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;
      Widget w = autherWidget(autherBlockInfo);

      prevBoard.addAll({
        autherBlockInfo.id: w,
      });
      prevBlocks.insert(event.position, autherBlockInfo);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(autherBlockInfo);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, autherBlockInfo, now.millisecondsSinceEpoch);
    } else if (event is AddTodolistBlock) {
      print("AddTodolistBlock shreyash");
      DateTime now = DateTime.now();

      TodoModel todo = TodoModel(
          id: now.millisecondsSinceEpoch,
          title: "List",
          numTodoItems: 0,
          savedTs: now);

      BlockInfo todoBlock = BlockInfo(
        height: 0,
        type: 3,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: todo.id,
      );
      print(todoBlock.toString() + "  AddTodolistBlock shreyash");
      await todoRepository.addTodo(todo);
      print(todoBlock.toString() + "  AddTodolistBlock shreyash");
      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;
      Widget w = BlocProvider(
          create: (_) => TodolistBloc(sl(), this, sl()),
          child: TodoitemWidget(
            key: ObjectKey(todoBlock.id),
            blockInfo: todoBlock,
            noteBloc: this,
            updateBlockInfo: updateBlockInfo,
            openMenu: openTodoItemMenu,
            updateDecoration: updateDecoration,
          ));

      prevBoard.addAll({
        todoBlock.id: w,
      });
      prevBlocks.insert(event.position, todoBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(todoBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, todoBlock, now.millisecondsSinceEpoch);
    } else if (event is AddCalendar) {
      print("AddCalendar shreyash");
      DateTime now = DateTime.now();

      CalendarBlock calendar = CalendarBlock(
          id: now.millisecondsSinceEpoch,
          title: "Calendar",
          savedTs: now.millisecondsSinceEpoch);

      BlockInfo calendarBlock = BlockInfo(
        height: 0,
        type: 11,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: calendar.id,
      );

      await noteRepository.addCalendarBlock(calendar);
      print(calendarBlock.toString() + "  AddTodolistBlock shreyash");
      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;
      Widget w = calendarWidget(calendarBlock);

      prevBoard.addAll({
        calendarBlock.id: w,
      });
      prevBlocks.insert(event.position, calendarBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(calendarBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, calendarBlock, now.millisecondsSinceEpoch);
    } else if (event is AddLinkBlock) {
      print("AddLinkBlock shreyash");
      DateTime now = DateTime.now();
      LinkModel new_link = await _getUrlData(event.link);
      print("new_link");
      print("new_link " + new_link.toString());

      BlockInfo todoBlock = BlockInfo(
        height: 0,
        type: 4,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: new_link.id,
      );
      print(todoBlock.toString() + "  AddTodolistBlock shreyash");

      await noteRepository.addLinkBlock(new_link);
      print(todoBlock.toString() + "  AddTodolistBlock shreyash");
      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;
      Widget w = BlocProvider(
          create: (_) => LinkBloc(sl(), this),
          child: LinkWidget(
            key: ObjectKey(todoBlock.id),
            blockInfo: todoBlock,
            noteBloc: this,
            updateBlockInfo: updateBlockInfo,
            updateDecoration: updateDecoration,
          ));

      prevBoard.addAll({
        todoBlock.id: w,
      });
      prevBlocks.insert(event.position, todoBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(todoBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, todoBlock, now.millisecondsSinceEpoch);
    } else if (event is AddHeading) {
      print("AddHeading shreyash");
      DateTime now = DateTime.now();
      FormFieldBlock thisFormField = event.formField;
      thisFormField = thisFormField.copyWith(type: 1);

      BlockInfo formBlock = BlockInfo(
        height: 0,
        type: 6,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: thisFormField.id,
      );
      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;

      await noteRepository.addFormFieldBlock(thisFormField);

      Widget w = headingWidget(formBlock);

      prevBoard.addAll({
        formBlock.id: w,
      });
      prevBlocks.insert(event.position, formBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(formBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, formBlock, now.millisecondsSinceEpoch);
    } else if (event is AddPassword) {
      print("AddPassword shreyash");
      DateTime now = DateTime.now();
      FormFieldBlock thisFormField = event.item;
      thisFormField = thisFormField.copyWith(type: 1);

      BlockInfo formBlock = BlockInfo(
        height: 0,
        type: 14,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: thisFormField.id,
      );
      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;

      await noteRepository.addFormFieldBlock(thisFormField);

      Widget w = passwordWidget(formBlock);

      prevBoard.addAll({
        formBlock.id: w,
      });
      prevBlocks.insert(event.position, formBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(formBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, formBlock, now.millisecondsSinceEpoch);
    } else if (event is AddSlider) {
      print("AddHeading shreyash");
      DateTime now = DateTime.now();
      SliderBlock thisSlider = event.sliderData;

      BlockInfo formBlock = BlockInfo(
        height: 0,
        type: 7,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: thisSlider.id,
      );
      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;

      await noteRepository.addSliderBlock(thisSlider);

      Widget w = sliderWidget(formBlock);

      prevBoard.addAll({
        formBlock.id: w,
      });
      prevBlocks.insert(event.position, formBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(formBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, formBlock, now.millisecondsSinceEpoch);
    } else if (event is AddTable) {
      DateTime now = DateTime.now();

      TableBlock tableBlock = TableBlock(
          id: now.millisecondsSinceEpoch,
          rows: 2,
          cols: 2,
          title: "Table",
          savedTs: now.millisecondsSinceEpoch);

      BlockInfo blockInfo = BlockInfo(
        height: 0,
        type: 8,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: tableBlock.id,
      );
      await noteRepository.addTableBlock(tableBlock);
      ColumnBlock columnBlock1 = ColumnBlock(
          id: now.millisecondsSinceEpoch,
          tableId: tableBlock.id,
          width: Gparam.width / 3,
          title: "Name",
          isFirstCol: 1,
          position: 0);
      await noteRepository.addTableColumn(columnBlock1);
      TableItemBlock item1 = TableItemBlock(
          id: now.millisecondsSinceEpoch,
          colId: columnBlock1.id,
          value: "Item1",
          savedTs: now.millisecondsSinceEpoch);
      await noteRepository.addTableColumnItem(item1);
      TableItemBlock item2 = TableItemBlock(
          id: now.millisecondsSinceEpoch + 1,
          colId: columnBlock1.id,
          value: "Item2",
          savedTs: now.millisecondsSinceEpoch);
      await noteRepository.addTableColumnItem(item2);

      ColumnBlock columnBlock2 = ColumnBlock(
          id: now.millisecondsSinceEpoch + 1,
          tableId: tableBlock.id,
          width: Gparam.width / 3,
          title: "Value",
          isFirstCol: 0,
          position: 1);
      await noteRepository.addTableColumn(columnBlock2);
      TableItemBlock item3 = TableItemBlock(
          id: now.millisecondsSinceEpoch + 3,
          colId: columnBlock2.id,
          value: "value1",
          savedTs: now.millisecondsSinceEpoch);
      await noteRepository.addTableColumnItem(item3);
      TableItemBlock item4 = TableItemBlock(
          id: now.millisecondsSinceEpoch + 4,
          colId: columnBlock2.id,
          value: "value2",
          savedTs: now.millisecondsSinceEpoch);
      await noteRepository.addTableColumnItem(item4);

      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;
      Widget w = tableWidget(blockInfo);

      prevBoard.addAll({
        blockInfo.id: w,
      });
      prevBlocks.insert(event.position, blockInfo);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(blockInfo);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, blockInfo, now.millisecondsSinceEpoch);
    } else if (event is AddYoutubeVideo) {
      print("AddHeading shreyash");
      DateTime now = DateTime.now();
      YoutubeBlock ytBlock = event.data;

      BlockInfo formBlock = BlockInfo(
        height: 0,
        type: 12,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: event.position,
        itemId: ytBlock.id,
      );
      NotesLoaded notesPrevState =
          (state as OpenSelectBlock).prevNotesLoadedState;

      List<BlockInfo> prevBlocks =
          (state as OpenSelectBlock).prevNotesLoadedState.blocks;
      LinkedHashMap<int, Widget> prevBoard =
          (state as OpenSelectBlock).prevNotesLoadedState.board;

      await noteRepository.addYoutubeBlock(ytBlock);

      Widget w = youtubeWidget(formBlock);

      prevBoard.addAll({
        formBlock.id: w,
      });
      prevBlocks.insert(event.position, formBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible, false));
      await noteRepository.addBlockInfo(formBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, formBlock, now.millisecondsSinceEpoch);
    }
  }

  updateBlockInfo(BlockInfo blockInfo) {
    this.add(UpdateBlock(blockInfo));
  }

  updateDecoration(int decoration) {}

  openTodoItemMenu(TodoItemModel todo, int position, BuildContext context,
      TodolistBloc todoBloc) {
    print("tester");
    _todoItemBottomSheet(context, position, todo, (todoBloc));
  }

  uploadImageAndSaveData(List<File> images, List<ImageBlock> imageblocks,
      ColossalBlock colossal) async {
    DateTime now = DateTime.now();
    ImageModel newImage;
    Failure failure;
    for (int i = 0; i < images.length; i++) {
      newImage = new ImageModel(
          caption: "",
          id: imageblocks[i].id,
          localPath: (images[i].path),
          savedTs: now,
          position: 0);
      print("before");

      var imageOrFailure = await noteRepository.storeImage(newImage, images[i]);
      imageOrFailure.fold((l) {
        failure = l;
        print("error in store");
      }, (r) {
        newImage = r;
      });

      ImageBlock imageBlock = ImageBlock(
          id: newImage.id,
          url: newImage.url,
          colossalId: colossal.id,
          imagePath: newImage.localPath,
          remotePath: newImage.storagePath,
          savedTs: newImage.savedTs.millisecondsSinceEpoch);

      await noteRepository.updateImageBlock(imageBlock);
    }
  }

  void _todoItemBottomSheet(context, position, todo, TodolistBloc todoBloc) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return TodoItemMenu(
                position: position,
                todoBloc: todoBloc,
                moveUp: moveUp,
                moveDown: moveDown,
                duplicate: duplicate,
                todo: todo,
                delete: delete);
          });
        });
  }

  moveUp(TodoItemModel todo, int position, TodolistBloc bloc) {
    bloc.add(MoveUpEvent(position, todo));
  }

  moveDown(TodoItemModel todo, int position, TodolistBloc bloc) {
    bloc.add(MoveDownEvent(position, todo));
  }

  duplicate(TodoItemModel todo, int position, TodolistBloc bloc) {
    bloc.add(Duplicate(position, todo));
  }

  delete(TodoItemModel todo, int position, TodolistBloc bloc) {
    bloc.add(DeleteEvent(position, todo));
  }

  Future<LinkModel> _getUrlData(LinkModel link) async {
    if (!isURL(link.url)) {
      return link;
    }

    final store = await CacheStore.getInstance();
    var response = await store.getFile(link.url).catchError((error) {
      return null;
    });
    if (response == null) {
      return link;
    }

    var document = parse(await response.readAsString());
    Map data = {};
    _extractOGData(document, data, 'og:title');
    _extractOGData(document, data, 'og:description');
    _extractOGData(document, data, 'og:site_name');
    _extractOGData(document, data, 'og:image');

    if (data != null && data.isNotEmpty) {
      link = link.copyWith(image: data['og:image']);
      link = link.copyWith(title: data['og:title']);
      link = link.copyWith(siteName: data['og:site_name']);
      link = link.copyWith(description: data['og:description']);
    }
    return link;
  }

  void _extractOGData(ht.Document document, Map data, String parameter) {
    var titleMetaTag = document.getElementsByTagName("meta")?.firstWhere(
        (meta) => meta.attributes['property'] == parameter,
        orElse: () => null);
    if (titleMetaTag != null) {
      data[parameter] = titleMetaTag.attributes['content'];
    }
  }

  void _headingBottomSheet(context, int decoration, HeadingBlock headingBlock,
      HeadingBloc headingBloc) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return HeadingMenu(
              changeDecoration: sideHeading,
              decoration: decoration,
              headingBlock: headingBlock,
              headingBloc: headingBloc,
            );
          });
        });
  }

  openHeadingMenu(BuildContext context, int decoration, HeadingBloc headingBloc,
      HeadingBlock headingBlock) {
    _headingBottomSheet(context, decoration, headingBlock, headingBloc);
  }

  sideHeading(
      int decoration, HeadingBloc headingBloc, HeadingBlock headingBlock) {
    headingBloc.add(UpdateDecoration(decoration, headingBlock));
  }

  openSliderMenu(BuildContext context, int decoration, SliderBloc sliderBloc,
      SliderBlock sliderBlock) {}

  openColumnMenu(ColumnBlock blockInfo) {}

  openSequenceMenu(BuildContext context, int decoration,
      SequenceBloc sliderBloc, SequenceBlock sliderBlock) {}
}
