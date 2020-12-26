import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:sorted/core/global/widgets/dashed_box.dart';
import 'package:sorted/features/FILES/presentation/widgets/calendar_element.dart';
import 'package:sorted/features/FILES/presentation/widgets/floating_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_widget.dart';
import 'package:zefyr/zefyr.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';

class NoteLoadedWidget extends StatefulWidget {
  final NotesLoaded state;
  final NoteBloc noteBloc;
  const NoteLoadedWidget({
    Key key,
    this.state,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => NoteLoadedWidgetState();
}

class NoteLoadedWidgetState extends State<NoteLoadedWidget>
    with SingleTickerProviderStateMixin {
  double height = 10;

  NotusDocument document;
  TextboxBlock textboxBlock;

  var _focusNode = FocusNode();

  ScrollController _listScrollController;
  double _containerMaxHeight = 56, _offset, _delta = 0, _oldOffset = 0;

  @override
  void initState() {
    _listScrollController = new ScrollController(
        // NEW
        );

    super.initState();
  }

  NotusDocument _loadDocument(String text) {
    return NotusDocument.fromJson(jsonDecode(text));
  }

  Widget _buildItem(IconData icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28),
        Text(title, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  buildItemDragTarget(targetPosition, double height) {
    return DragTarget<BlockInfo>(
      // Will accept others, but not himself
      onWillAccept: (BlockInfo data) {
        return widget.state.board.isEmpty ||
            data.id != widget.state.blocks[targetPosition].id;
      },
      onLeave: (object) {
        //print((object as Item).listId + "  onleave");
      },
      // Moves the card into the position
      onAccept: (BlockInfo data) {
        print("Accepted");
        print(data.id);
        setState(() {
          if (widget.state.blocks != null) {
            int index = widget.state.blocks.indexOf(data);
            widget.state.blocks.remove(data);

            //data.listId = listId;

            if (widget.state.blocks.length > targetPosition) {
              if (index < targetPosition) {
                widget.state.blocks.insert(targetPosition, data);
              } else {
                widget.state.blocks.insert(targetPosition + 1, data);
              }

              print("shtr  " +
                  index.toString() +
                  "  " +
                  (targetPosition + 1).toString());
              print("case 11");
            } else {
              widget.state.blocks.add(data);
              print("case 22");
            }
            print(widget.state.blocks.length.toString() + " length");

            widget.noteBloc.add(UpdateBlockPosition(widget.state.blocks));
          }
        });
      },
      builder: (BuildContext context, List<BlockInfo> data,
          List<dynamic> rejectedData) {
        if (data.isEmpty) {
          // The area that accepts the draggable
          return Container(
            //color:Colors.green.withOpacity(.5),
            height: height,
          );
        } else {
          return Column(
            // What's shown when hovering on it
            children: [
              Container(
                height: height,
              ),
              ...data.map((BlockInfo item) {
                //print("list id" + item.listId.toString());
                return Opacity(
                  opacity: 0.5,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                            height: 60,
                            width: Gparam.width * 0.85,
                            margin: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Text("Drop here")),
                      ),
                      Center(
                        child: Container(
                          height: 60,
                          width: Gparam.width * 0.85,
                          margin: EdgeInsets.all(8),
                          child: DashedRect(
                            color: Theme.of(context).highlightColor,
                            strokeWidth: 1.0,
                            gap: 8.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()
            ],
          );
        }
      },
    );
  }

  // void getBlockWidgets(List<BlockInfo> blocks) {

  //   if (blocks != null && blocks.length > 0) {
  //     int i = 0;
  //     print("sequence");
  //     blocks.forEach((element) {
  //       print(i);
  //       i++;
  //       print(element);
  //       if (element.type == 0) {
  //         blockWidgets.add(
  //           BlocProvider(
  //               create: (_) => TextboxBloc(sl(), widget.noteBloc)
  //                 ..add(UpdateTextbox(element)),
  //               child: TextboxWidget(
  //                 blockInfo: element,
  //                 noteBloc: widget.noteBloc,
  //                 updateBlockInfo: updateBlockInfo,
  //                 updateDecoration: updateDecoration,
  //               )),
  //         );
  //       }
  //     });
  //   }

  //   return;
  // }

  updateBlockInfo(BlockInfo blockInfo) {
    widget.noteBloc.add(UpdateBlock(blockInfo));
  }

  updateDecoration(int decoration) {}
  String horseUrl = 'https://i.stack.imgur.com/Dw6f7.png';
  String cowUrl = 'https://i.stack.imgur.com/XPOr3.png';
  String camelUrl = 'https://i.stack.imgur.com/YN0m7.png';
  String sheepUrl = 'https://i.stack.imgur.com/wKzo8.png';
  String goatUrl = 'https://i.stack.imgur.com/Qt4JP.png';

  @override
  Widget build(BuildContext context) {
    buildKanbanList(List<BlockInfo> items) {
      print("rebuild buildKanbanList");
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _listScrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: _listScrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: ListView.builder(
                          controller: _listScrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            // A stack that provides:
                            // * A draggable object
                            // * An area for incoming draggables
                            return Stack(
                              children: [
                                LongPressDraggable<BlockInfo>(
                                  data: items[index],
                                  feedbackOffset: Offset.fromDirection(500),
                                  onDragCompleted: () {
                                    if (widget.state.inAir)
                                      widget.noteBloc
                                          .add(UpdateAir(inAir: false));
                                  },
                                  onDraggableCanceled: (v, o) {
                                    if (widget.state.inAir)
                                      widget.noteBloc
                                          .add(UpdateAir(inAir: false));
                                  },
                                  onDragEnd: (value) {
                                    if (widget.state.inAir)
                                      widget.noteBloc
                                          .add(UpdateAir(inAir: false));
                                  },
                                  onDragStarted: () {
                                    if (!widget.state.inAir)
                                      widget.noteBloc
                                          .add(UpdateAir(inAir: true));
                                  },
                                  child: widget.state.board[items[index].id],
                                  childWhenDragging: Opacity(
                                    // The card that's left behind
                                    opacity: 1,
                                    child: widget.state.board[items[index].id],
                                  ),
                                  feedback: FloatingWidget(
                                    child: Material(
                                      child: Container(
                                        // A card floating around
                                        height: (items[index].height >
                                                Gparam.height / 2)
                                            ? Gparam.height / 2
                                            : items[index].height,
                                        width: Gparam.width,
                                        child: SingleChildScrollView(
                                          child: widget
                                              .state.board[items[index].id],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                buildItemDragTarget(index, items[index].height),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Gparam.width,
            child: buildKanbanList(widget.state.blocks),
          ),
        ],
      ),
    );
  }
}
