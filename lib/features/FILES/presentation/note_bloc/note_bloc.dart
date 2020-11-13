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
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/colossal_bloc/colossal_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/link_bloc/link_bloc.dart';
import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/todolist_bloc/todolist_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/image_loading%20copy.dart';
import 'package:sorted/features/FILES/presentation/widgets/image_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/link_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/todo_item_menu.dart';
import 'package:sorted/features/FILES/presentation/widgets/todolist_widget.dart';
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

  var _newMediaLinkAddressController = TextEditingController();
  NoteBloc(this.noteRepository, this.todoRepository) : super(NoteLoading());
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
    } else if (event is UpdateNote) {
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
      if (failure == null)
        blocks.forEach((element) {
          if (element.type == 0) {
            wid = BlocProvider(
                create: (_) => TextboxBloc(sl(), this),
                child: TextboxWidget(
                  key: ObjectKey(element.id),
                  blockInfo: element,
                  noteBloc: this,
                  updateBlockInfo: updateBlockInfo,
                  updateDecoration: updateDecoration,
                ));
          } else if (element.type == 2) {
            wid = BlocProvider(
                create: (_) => ImageBloc(sl(), this),
                child: ImageWidget(
                  key: ObjectKey(element.id),
                  blockInfo: element,
                  noteBloc: this,
                  updateBlockInfo: updateBlockInfo,
                  updateDecoration: updateDecoration,
                ));
          } else if (element.type == 3) {
            wid = BlocProvider(
                create: (_) => TodolistBloc(sl(), this, sl()),
                child: TodoitemWidget(
                  key: ObjectKey(element.id),
                  blockInfo: element,
                  noteBloc: this,
                  updateBlockInfo: updateBlockInfo,
                  updateDecoration: updateDecoration,
                  openMenu: openMenu,
                ));
          } else if (element.type == 4) {
            wid = BlocProvider(
                create: (_) => LinkBloc(sl(), this),
                child: LinkWidget(
                  key: ObjectKey(element.id),
                  blockInfo: element,
                  noteBloc: this,
                  updateBlockInfo: updateBlockInfo,
                  updateDecoration: updateDecoration,
                ));
          }

          board.addAll({
            element.id: wid,
          });
        });

      if (failure == null) yield NotesLoaded(blocks, event.note, board, true);
    } else if (event is UpdateBlockPosition) {
      print("UpdateBlockPosition");
      print((state as NotesLoaded).blocks);
      print(event.blocks);
      yield NotesLoaded(
          event.blocks,
          (state as NotesLoaded).note,
          (state as NotesLoaded).board,
          (state as NotesLoaded).isBottomNavVisible);
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
            (state as NotesLoaded).isBottomNavVisible);
      }
    } else if (event is ChangeVisibility) {
      print("ChangeVisbility");
      yield NotesLoaded(
          (state as NotesLoaded).blocks,
          (state as NotesLoaded).note,
          (state as NotesLoaded).board,
          event.visible);
    } else if (event is OpenAllBlocks) {
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
      Failure failure;
      var result = event.images;

      if (result != null && result.length > 0) {
        //var decodedImage = await decodeImageFromList(result.readAsBytesSync());
        for (int i = 0; i < result.length; i++) {
          yield (EditColossal(nowState.prevNotesLoadedState, nowState.position,
              nowState.imageFiles, i));
          newImage = new ImageModel(
              caption: "",
              id: now.millisecondsSinceEpoch + i,
              localPath: p.basename(result[i].path),
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

          var imageOrFailure =
              await noteRepository.storeImage(newImage, result[i]);
        }
        yield (nowState.prevNotesLoadedState);
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
            localPath: p.basename(result.path),
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
            notesPrevState.isBottomNavVisible));
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
          notesPrevState.isBottomNavVisible));
      await noteRepository.addBlockInfo(textBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, textBlock, now.millisecondsSinceEpoch);
    } else if (event is AddTodolistBlock) {
      print("AddTodolistBlock shreyash");
      DateTime now = DateTime.now();

      TodoModel todo = TodoModel(
          id: now.millisecondsSinceEpoch,
          title: "Todolist",
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
            openMenu: openMenu,
            updateDecoration: updateDecoration,
          ));

      prevBoard.addAll({
        todoBlock.id: w,
      });
      prevBlocks.insert(event.position, todoBlock);

      yield (NotesLoaded(prevBlocks, notesPrevState.note, prevBoard,
          notesPrevState.isBottomNavVisible));
      await noteRepository.addBlockInfo(todoBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, todoBlock, now.millisecondsSinceEpoch);
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
      //Todo: add link to db
      // await noteRepository.addLink(link);
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
          notesPrevState.isBottomNavVisible));
      await noteRepository.addBlockInfo(todoBlock);

      noteRepository.linkNoteAndBlock(
          notesPrevState.note, todoBlock, now.millisecondsSinceEpoch);
    }
  }

  updateBlockInfo(BlockInfo blockInfo) {
    this.add(UpdateBlock(blockInfo));
  }

  updateDecoration(int decoration) {}

  openMenu(TodoItemModel todo, int position, BuildContext context,
      TodolistBloc todoBloc) {
    print("tester");
    _NewLinkBottomSheet(context, position, todo, (todoBloc));
  }

  void _NewLinkBottomSheet(context, position, todo, TodolistBloc todoBloc) {
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
}
