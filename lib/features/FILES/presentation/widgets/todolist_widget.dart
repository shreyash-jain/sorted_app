import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
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
import 'package:sorted/features/FILES/presentation/todolist_bloc/todolist_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class TodoitemWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(TodoItemModel biometric, int position, BuildContext context,
      TodolistBloc todoBloc) openMenu;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(int decoration) updateDecoration;

  const TodoitemWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
    this.openMenu,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TodoitemWidgetState();
}

class TodoitemWidgetState extends State<TodoitemWidget> {
  double height = 10;

  NotusDocument document;

  var _focusNode = FocusNode();
  TodolistBloc bloc;
  TextEditingController newTodoItemController = TextEditingController();

  FocusNode newTodoFocus = FocusNode();

  ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("Load todolist " + widget.blockInfo.toString());
    bloc = BlocProvider.of<TodolistBloc>(context);
    BlocProvider.of<TodolistBloc>(context)
      ..add(UpdateTodolist(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(child:
        BlocBuilder<TodolistBloc, TodolistState>(builder: (context, state) {
      if (state is TodoError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is TodolistInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is TodolistLoaded) {
        print("update state");
        return MeasureSize(
            onChange: (Size size) {
              print("child measured");
              if (state.blockInfo.height != size.height)
                widget.updateBlockInfo(
                    widget.blockInfo.copyWith(height: size.height));
            },
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     FadeRoute(
                //         page: TextboxEdit(
                //       textboxBlock: toSendBlock,
                //       textboxBloc: BlocProvider.of<TextboxBloc>(context),
                //     )));
                print("edit");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: Gparam.widthPadding,
                              ),
                              Icon(
                                OMIcons.doneOutline,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(0),
                                ),
                                child: Text(
                                  state.todo.title,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Gparam.textSmall,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        OMIcons.moreVert,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (state.todos != null && state.todos.length > 0)
                    Container(
                        width: Gparam.width, child: buildTodoList(state.todos)),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(0),
                      borderRadius: new BorderRadius.all(Radius.circular(12.0)),
                      border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(.2),
                          width: 2),
                    ),
                    child: TextField(
                      controller: newTodoItemController,
                      focusNode: newTodoFocus,
                      maxLines: 1,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        height: 1.2,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: Gparam.textSmaller,
                      ),
                      onSubmitted: (newValue) {
                        print("newTodoItemController.text");
                        print(newTodoItemController.text);
                        bloc.add(AddTodoItem(newValue.trim()));
                        newTodoItemController.clear();
                        newTodoFocus.canRequestFocus = true;
                        newTodoFocus.requestFocus();
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          OMIcons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'Add Todo',
                        hintStyle: TextStyle(
                          fontFamily: "Montserrat",
                          height: 1.2,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w300,
                          fontSize: Gparam.textSmaller,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ));
      }
    }));
  }

  buildTodoList(List<TodoItemModel> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                              GestureDetector(
                                  onTap: () {
                                    bloc.add(
                                        InvertTodoState(index, items[index]));
                                  },
                                  child: ListTodoCard(
                                      items[index], index, openItemMenu)),
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

  openItemMenu(TodoItemModel todo, int position, BuildContext context) {
    widget.openMenu(todo, position, context, (bloc));
  }
}

class ListTodoCard extends StatefulWidget {
  final TodoItemModel todo;
  final int position;
  final Function(TodoItemModel biometric, int position, BuildContext context)
      openMenu;

  ListTodoCard(this.todo, this.position, this.openMenu);

  @override
  _ListTodoCard createState() => _ListTodoCard();
}

class _ListTodoCard extends State<ListTodoCard> {
  @override
  Widget build(BuildContext context) {
    print("building " + widget.todo.state.toString());
    return Column(
      children: [
        new Divider(
          color: Theme.of(context).primaryColor.withAlpha(78),
        ),
        Row(
          children: [
            Container(
              width: Gparam.width * 3 / 4,
              margin: EdgeInsets.symmetric(
                  horizontal: Gparam.widthPadding, vertical: 3),
              child: Row(
                children: <Widget>[
                  SizedBox(width: Gparam.widthPadding / 3),
                  Stack(
                    children: [
                      Container(
                          width: 20.0,
                          height: 25.0,
                          decoration: new BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            shape: BoxShape.circle,
                          )),
                      if (widget.todo.state == 1)
                        Icon(
                          OMIcons.done,
                          color: Theme.of(context).primaryColor,
                        ),
                    ],
                  ),
                  SizedBox(width: Gparam.widthPadding / 3),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: Gparam.width,
                        alignment: Alignment.center,
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Text(
                                      widget.todo.todoItem,
                                      maxLines: 2,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "Montserrat",
                                        height: 1,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Gparam.textSmaller,
                                      ),
                                    ),
                                  ),
                                ),
                                 Align(
                                  alignment: Alignment.center,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 1400),
                                    curve: Curves.decelerate,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).scaffoldBackgroundColor.withAlpha(160),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    height: 4,
                                    width: (widget.todo.state == 1)
                                        ? Gparam.width * 3 / 4
                                        : 0,
                                  ),
                                ),
                               
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                widget.openMenu(widget.todo, widget.position, context);
              },
              child: Icon(
                OMIcons.moreHoriz,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
