import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/circular_progress.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/presentation/bloc/goal_page_bloc/goal_page_bloc.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:sorted/features/PLAN/presentation/bloc/task_page_bloc/task_page_bloc.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_attachment.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_event.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_link.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_tag.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_task.dart';
import 'package:sorted/features/PLAN/presentation/widgets/floating_widget.dart';

class TaskPage extends StatefulWidget {
  final TaskModel thisGoal;
  final PlanBloc planBloc;
  const TaskPage({Key key, this.thisGoal, this.planBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  Emoji emojiProfile = Emoji(name: "Heavy Plus Sign", emoji: "➕");
  bool showDescription = false;

  TaskPageBloc bloc;

  bool isShowSticker = false;

  var _newMediaLinkAddressController = TextEditingController();

  var deadlineDouble = 0.0;

  TextEditingController newTodoItemController = TextEditingController();

  FocusNode newTodoFocus = FocusNode();

  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);

  var _listScrollController;
  @override
  void initState() {
    bloc = TaskPageBloc(sl(), sl(), widget.planBloc)
      ..add(LoadTaskPage(widget.thisGoal));
    print(widget.thisGoal.taskImageId + "  haha");
    _listScrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );

    super.initState();
  }

  buildItemDragTarget(targetPosition, double height) {
    return DragTarget<TodoItemModel>(
      // Will accept others, but not himself
      onWillAccept: (TodoItemModel data) {
        return (bloc.state as TaskPageLoaded).toAddTodosItems.isEmpty ||
            data.id !=
                (bloc.state as TaskPageLoaded)
                    .toAddTodosItems[targetPosition]
                    .id;
      },
      onLeave: (object) {
        //print((object as Item).listId + "  onleave");
      },
      // Moves the card into the position
      onAccept: (TodoItemModel data) {
        setState(() {
          if ((bloc.state as TaskPageLoaded).toAddTodosItems != null) {
            List<TodoItemModel> todos =
                (bloc.state as TaskPageLoaded).toAddTodosItems;
            (bloc.state as TaskPageLoaded).toAddTodosItems.remove(data);
            //data.listId = listId;

            if (todos.length > targetPosition) {
              todos.insert(targetPosition + 1, data);
            } else {
              todos.add(data);
            }

            bloc.add(UpdateTodoItems(todos));
          }
        });
      },
      builder: (BuildContext context, List<TodoItemModel> data,
          List<dynamic> rejectedData) {
        if (data.isEmpty) {
          // The area that accepts the draggable
          return Container(
            height: height + 12,
          );
        } else {
          return Column(
            // What's shown when hovering on it
            children: [
              Container(
                height: height,
              ),
              ...data.map((TodoItemModel item) {
                //print("list id" + item.listId.toString());
                return Opacity(
                  opacity: 0.5,
                  child: ListTodoCard(item),
                );
              }).toList()
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildKanbanList(List<TodoItemModel> items) {
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
                                LongPressDraggable<TodoItemModel>(
                                  data: items[index],
                                  feedbackOffset: Offset.fromDirection(500),
                                  onDragCompleted: () {},
                                  onDragEnd: (value) {},
                                  child: ListTodoCard(items[index]),
                                  childWhenDragging: Opacity(
                                    // The card that's left behind
                                    opacity: 0.2,
                                    child: ListTodoCard(items[index]),
                                  ),
                                  feedback: Container(
                                    // A card floating around
                                    height: 53,
                                    width: Gparam.width,
                                    child: FloatingWidget(
                                        child: ListTodoCard(items[index])),
                                  ),
                                ),
                                buildItemDragTarget(index, 53),
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

    return Scaffold(body: SafeArea(child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return BlocProvider(
          create: (_) => bloc,
          child: Center(child: BlocBuilder<TaskPageBloc, TaskPageBlocState>(
              builder: (context, state) {
            if (state is TaskPageError) {
              return MessageDisplay(
                message: 'Start searching!',
              );
            } else if (state is TaskPageLoading) {
              return Center(child: LoadingWidget());
            } else if (state is TaskPageLoaded) {
              print(state.thisTask.coverImageid);
              return Container(
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Stack(children: [
                    Column(
                      children: [
                        SizedBox(height: Gparam.heightPadding),

                        Container(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isShowSticker = !isShowSticker;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Hero(
                                      tag: state.thisTask.id.toString(),
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Text(
                                                    (state.thisTask
                                                                .taskImageId !=
                                                            "0")
                                                        ? state.thisTask
                                                            .taskImageId
                                                        : emojiProfile.emoji,
                                                    style: TextStyle(
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  CircleProgress(
                                                    ringColor: Theme.of(context)
                                                        .backgroundColor
                                                        .withOpacity(.2),
                                                    radius: 30.0,
                                                    dotColor: Theme.of(context)
                                                        .primaryColor,
                                                    dotRadius: 3.0,
                                                    shadowWidth: 1.0,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    dotEdgeColor:
                                                        Theme.of(context)
                                                            .primaryColorLight,
                                                    progress:
                                                        state.thisTask.progress,
                                                    progressChanged: (value) {},
                                                  )
                                                ]),
                                            SizedBox(
                                              width: Gparam.widthPadding,
                                            ),
                                            Container(
                                                child: Flexible(
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                  text: state.thisTask.title,
                                                  style: TextStyle(
                                                      fontFamily: 'Milliard',
                                                      fontSize:
                                                          Gparam.textSmall,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Theme.of(context)
                                                          .highlightColor),
                                                ),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        if (state.tags != null)
                          Container(
                            height: 35,
                            alignment: Alignment.bottomLeft,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.tags.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == 0)
                                    return InkWell(
                                      onTap: () {
                                        _newTagBottomSheet(context);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.only(
                                              left: Gparam.widthPadding,
                                              right: 8),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(12.0)),
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .highlightColor
                                                    .withOpacity(.2),
                                                width: 1),
                                          ),
                                          child: Row(children: [
                                            RichText(
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              text: TextSpan(
                                                text: "Add ",
                                                style: TextStyle(
                                                  fontFamily: 'Milliard',
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .highlightColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: "Tag",
                                                      style: TextStyle(
                                                        fontFamily: "Milliard",
                                                        height: 1.2,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 10,
                                                      )),
                                                ],
                                              ),
                                            )
                                          ])),
                                    );
                                  return TagTile(
                                    tag: state.tags[index - 1],
                                    context: context,
                                    index: index - 1,
                                    onTapTag: onTapTag,
                                  );
                                }),
                            // ignore: missing_required_param
                          ),
                        SizedBox(
                          height: Gparam.heightPadding / 2,
                        ),
                        Container(
                            child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              width: Gparam.widthPadding,
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding),
                                alignment: Alignment.topLeft,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.pin_drop,
                                        size: 16,
                                        color: Theme.of(context).highlightColor,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                          text: "Created" + "  ",
                                          style: TextStyle(
                                            fontFamily: 'Milliard',
                                            color: Theme.of(context)
                                                .highlightColor,
                                            fontSize: Gparam.textVerySmall,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: countdownDays(
                                                    state.thisTask.savedTs),
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                )),
                                            TextSpan(
                                                text: countdownDaysUnit(
                                                    state.thisTask.savedTs),
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                )),
                                            TextSpan(
                                                text: " ago",
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                )),
                                          ],
                                        ),
                                      )
                                    ])),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding),
                                alignment: Alignment.topLeft,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 16,
                                          color:
                                              Theme.of(context).highlightColor),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          text: pastDeadline(
                                                  state.thisTask.deadLine) +
                                              " ",
                                          style: TextStyle(
                                            fontFamily: 'Milliard',
                                            color: Theme.of(context)
                                                .highlightColor,
                                            fontSize: Gparam.textVerySmall,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: countdownDays(
                                                    widget.thisGoal.deadLine),
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                )),
                                            TextSpan(
                                                text: countdownDaysUnit(
                                                    state.thisTask.deadLine),
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                )),
                                            if (isDeadlineClose(
                                                state.thisTask.deadLine))
                                              TextSpan(
                                                  text: " ‼ ",
                                                  style: TextStyle(
                                                    fontFamily: "Milliard",
                                                    height: 1.2,
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                  )),
                                            if (isDeadlineClose(
                                                state.thisTask.deadLine))
                                              TextSpan(
                                                  text: "near deadline",
                                                  style: TextStyle(
                                                    fontFamily: "Milliard",
                                                    height: 1.2,
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        Gparam.textVerySmall,
                                                  )),
                                          ],
                                        ),
                                      )
                                    ])),
                            SizedBox(
                              height: 6,
                            ),
                          ],
                        )),

                        Container(
                            height: 44,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: Gparam.widthPadding,
                                ),
                                InkWell(
                                    onTap: () {
                                      _NewAttachmentBottomSheet(context);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(16.0)),
                                          gradient: new LinearGradient(
                                              colors: [
                                                Theme.of(context).primaryColor,
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(.8)
                                              ],
                                              begin: FractionalOffset.topCenter,
                                              end:
                                                  FractionalOffset.bottomCenter,
                                              stops: [.2, .8],
                                              tileMode: TileMode.repeated),
                                        ),
                                        child: Row(children: [
                                          Icon(Icons.attachment,
                                              size: Gparam.textMedium,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          RichText(
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            text: TextSpan(
                                              text: "Add ",
                                              style: TextStyle(
                                                fontFamily: 'Milliard',
                                                fontSize: Gparam.textVerySmall,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: "Attachment",
                                                    style: TextStyle(
                                                      fontFamily: "Milliard",
                                                      height: 1.2,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize:
                                                          Gparam.textSmaller,
                                                    )),
                                              ],
                                            ),
                                          )
                                        ]))),
                                SizedBox(
                                  width: 6,
                                ),
                                Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(16.0)),
                                      gradient: new LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.8)
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          stops: [.2, .8],
                                          tileMode: TileMode.repeated),
                                    ),
                                    child: Row(children: [
                                      Icon(Icons.short_text,
                                          size: Gparam.textMedium,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          text: "Add ",
                                          style: TextStyle(
                                            fontFamily: 'Milliard',
                                            fontSize: Gparam.textVerySmall,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "Dependency",
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: Gparam.textSmaller,
                                                )),
                                          ],
                                        ),
                                      )
                                    ])),
                              ],
                            )),

                        // Container(
                        //     height: 44,
                        //     child: ListView(
                        //       scrollDirection: Axis.horizontal,
                        //       children: [
                        //         SizedBox(
                        //           width: Gparam.widthPadding,
                        //         ),
                        //         Container(
                        //           padding: EdgeInsets.all(8),
                        //           margin: EdgeInsets.all(6),
                        //           decoration: BoxDecoration(
                        //             borderRadius:
                        //                 new BorderRadius.all(Radius.circular(16.0)),
                        //             gradient: new LinearGradient(
                        //                 colors: [
                        //                   Colors.greenAccent,
                        //                   Colors.greenAccent.withOpacity(.9)
                        //                 ],
                        //                 begin: FractionalOffset.topCenter,
                        //                 end: FractionalOffset.bottomCenter,
                        //                 stops: [.2, .8],
                        //                 tileMode: TileMode.repeated),
                        //           ),
                        //           child: Text('school',
                        //               style: TextStyle(
                        //                 fontFamily: 'Milliard',
                        //                 fontWeight: FontWeight.w800,
                        //                 color: Colors.white,
                        //                 fontSize: Gparam.textVerySmall,
                        //               )),
                        //         ),
                        //         Container(
                        //           padding: EdgeInsets.all(8),
                        //           margin: EdgeInsets.all(6),
                        //           decoration: BoxDecoration(
                        //             borderRadius:
                        //                 new BorderRadius.all(Radius.circular(16.0)),
                        //             gradient: new LinearGradient(
                        //                 colors: [
                        //                   Colors.blueAccent,
                        //                   Colors.blueAccent.withOpacity(.9)
                        //                 ],
                        //                 begin: FractionalOffset.topCenter,
                        //                 end: FractionalOffset.bottomCenter,
                        //                 stops: [.2, .8],
                        //                 tileMode: TileMode.repeated),
                        //           ),
                        //           child: Text('work',
                        //               style: TextStyle(
                        //                 fontFamily: 'Milliard',
                        //                 fontWeight: FontWeight.w800,
                        //                 color: Colors.white,
                        //                 fontSize: Gparam.textVerySmall,
                        //               )),
                        //         ),
                        //         Container(
                        //           padding: EdgeInsets.all(8),
                        //           margin: EdgeInsets.all(6),
                        //           decoration: BoxDecoration(
                        //             borderRadius:
                        //                 new BorderRadius.all(Radius.circular(16.0)),
                        //             gradient: new LinearGradient(
                        //                 colors: [
                        //                   Colors.deepPurpleAccent,
                        //                   Colors.deepPurpleAccent.withOpacity(.9)
                        //                 ],
                        //                 begin: FractionalOffset.topCenter,
                        //                 end: FractionalOffset.bottomCenter,
                        //                 stops: [.2, .8],
                        //                 tileMode: TileMode.repeated),
                        //           ),
                        //           child: Text('cloud',
                        //               style: TextStyle(
                        //                 fontFamily: 'Milliard',
                        //                 fontWeight: FontWeight.w800,
                        //                 color: Colors.white,
                        //                 fontSize: Gparam.textVerySmall,
                        //               )),
                        //         ),
                        //         Container(
                        //           padding: EdgeInsets.all(8),
                        //           margin: EdgeInsets.all(6),
                        //           decoration: BoxDecoration(
                        //             borderRadius:
                        //                 new BorderRadius.all(Radius.circular(16.0)),
                        //             gradient: new LinearGradient(
                        //                 colors: [
                        //                   Colors.redAccent,
                        //                   Colors.redAccent.withOpacity(.9)
                        //                 ],
                        //                 begin: FractionalOffset.topCenter,
                        //                 end: FractionalOffset.bottomCenter,
                        //                 stops: [.2, .8],
                        //                 tileMode: TileMode.repeated),
                        //           ),
                        //           child: Text('boss',
                        //               style: TextStyle(
                        //                 fontFamily: 'Milliard',
                        //                 fontWeight: FontWeight.w800,
                        //                 color: Colors.white,
                        //                 fontSize: Gparam.textVerySmall,
                        //               )),
                        //         ),
                        //         Container(
                        //           padding: EdgeInsets.all(8),
                        //           margin: EdgeInsets.all(6),
                        //           decoration: BoxDecoration(
                        //             borderRadius:
                        //                 new BorderRadius.all(Radius.circular(16.0)),
                        //             gradient: new LinearGradient(
                        //                 colors: [
                        //                   Colors.pinkAccent,
                        //                   Colors.pinkAccent.withOpacity(.9)
                        //                 ],
                        //                 begin: FractionalOffset.topCenter,
                        //                 end: FractionalOffset.bottomCenter,
                        //                 stops: [.2, .8],
                        //                 tileMode: TileMode.repeated),
                        //           ),
                        //           child: Text('documentation',
                        //               style: TextStyle(
                        //                   fontFamily: 'Milliard',
                        //                   fontSize: Gparam.textVerySmall,
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.w800)),
                        //         ),
                        //         Container(
                        //           padding: EdgeInsets.all(8),
                        //           margin: EdgeInsets.all(6),
                        //           decoration: BoxDecoration(
                        //             borderRadius:
                        //                 new BorderRadius.all(Radius.circular(16.0)),
                        //             gradient: new LinearGradient(
                        //                 colors: [
                        //                   Colors.yellowAccent,
                        //                   Colors.yellowAccent.withOpacity(.9)
                        //                 ],
                        //                 begin: FractionalOffset.topCenter,
                        //                 end: FractionalOffset.bottomCenter,
                        //                 stops: [.2, .8],
                        //                 tileMode: TileMode.repeated),
                        //           ),
                        //           child: Text('database',
                        //               style: TextStyle(
                        //                   fontFamily: 'Milliard',
                        //                   fontSize: Gparam.textVerySmall,
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.w800)),
                        //         ),
                        //       ],
                        //     )),
                        SizedBox(
                          height: Gparam.heightPadding,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showDescription = !showDescription;
                            });
                            print("showDescription " +
                                showDescription.toString());
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding),
                              child: RichText(
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: (showDescription) ? 10 : 2,
                                  text: TextSpan(
                                      text: "Description\n",
                                      style: TextStyle(
                                          fontFamily: 'Milliard',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).highlightColor),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: state.thisTask.description,
                                          style: TextStyle(
                                            fontFamily: "Milliard",
                                            height: 1.2,
                                            color: Theme.of(context)
                                                .highlightColor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: Gparam.textVerySmall,
                                          ),
                                        )
                                      ]))),
                        ),

                        SizedBox(
                          height: Gparam.heightPadding,
                        ),

                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            child: RichText(
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: (showDescription) ? 10 : 2,
                                text: TextSpan(
                                    text: "Lets add some",
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        fontSize: Gparam.textVerySmall,
                                        fontWeight: FontWeight.w300,
                                        color:
                                            Theme.of(context).highlightColor),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " Subtasks",
                                        style: TextStyle(
                                          fontFamily: "Milliard",
                                          height: 1.2,
                                          color:
                                              Theme.of(context).highlightColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Gparam.textVerySmall,
                                        ),
                                      )
                                    ]))),
                        SizedBox(
                          height: Gparam.heightPadding,
                        ),
                        if (state.toAddTodosItems != null &&
                            state.toAddTodosItems.length > 0)
                          Container(
                            width: Gparam.width,
                            child: buildKanbanList(state.toAddTodosItems),
                          ),

                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withAlpha(0),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(12.0)),
                            border: Border.all(
                                color: Theme.of(context)
                                    .highlightColor
                                    .withOpacity(.2),
                                width: 2),
                          ),
                          child: TextField(
                            controller: newTodoItemController,
                            focusNode: newTodoFocus,
                            maxLines: 1,
                            cursorColor: Theme.of(context).primaryColor,
                            style: TextStyle(
                              fontFamily: "Milliard",
                              height: 1.2,
                              color: Theme.of(context).highlightColor,
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
                                OMIcons.doneOutline,
                                color: Theme.of(context).highlightColor,
                              ),
                              hintText: 'Enter Todo',
                              hintStyle: TextStyle(
                                fontFamily: "Milliard",
                                height: 1.2,
                                color: Theme.of(context).highlightColor,
                                fontWeight: FontWeight.w300,
                                fontSize: Gparam.textSmaller,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Gparam.heightPadding,
                        ),
                      ],
                    ),
                    Container(
                      height: Gparam.height,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            WillPopScope(
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      // your list goes here

                                      // Input content

                                      // Sticker
                                      (isShowSticker
                                          ? buildSticker(state.thisTask.title)
                                          : Container()),
                                    ],
                                  ),
                                ],
                              ),
                              onWillPop: onBackPress,
                            ),
                          ]),
                    )
                  ]),
                ),
              );
            }
          })));
    })));
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        // final String item = alphabetList.removeAt(oldIndex);
        // alphabetList.insert(newIndex, item);
      },
    );
  }

  Widget buildSticker(String goalTitle) {
    return EmojiPicker(
      rows: (Gparam.isHeightBig) ? 6 : 4,
      bgColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(210),
      indicatorColor: Theme.of(context).primaryColor,
      columns: 5,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: [
        "work",
        "book",
        "goal",
        ...goalTitle.toLowerCase().split(" "),
        "laptop",
        "pen"
      ],
      numRecommended: 30,
      onEmojiSelected: (emoji, category) {
        print(emoji);
        setState(() {
          emojiProfile = emoji;
        });
        bloc.add(UpdateTaskEmoji(emoji.emoji));

        onBackPress();
      },
    );
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  countdownDays(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays > 0) {
      if (rDays > 365)
        return (rDays / 356).floor().toString();
      else
        return rDays.toString();
    } else if (rDays < 0) {
      if (rDays < -365)
        return (rDays / -356).floor().toString();
      else
        return rDays.abs().toString();
    } else {
      return deadLine.difference(DateTime.now()).inHours.abs().toString();
    }
  }

  countdownDaysUnit(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays.abs();
    if (rDays > 0) {
      if (rDays > 365) {
        if (rDays / 365 > 1)
          return " years";
        else
          return " year";
      } else {
        if (rDays > 1)
          return " days";
        else
          return " day";
      }
    } else {
      return " hrs";
    }
  }

  pastDeadline(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays > 0) {
      return "Deadline in";
    } else if (rDays < 0) {
      return "Past deadline";
    } else {
      if (deadLine.isAfter(DateTime.now())) {
        return "Deadline in";
      } else
        return "Past deadline";
    }
  }

  void _newTagBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddTag(
              newMediaLinkAddressController: _newMediaLinkAddressController,
              width: Gparam.width / 2,
            );
          });
        });
  }

  void _NewAttachmentBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddAttachment(
              newMediaLinkAddressController: _newMediaLinkAddressController,
              deadlineDouble: deadlineToDouble(
                  (bloc.state as GoalPageLoaded).newTask.deadLine),
              priorityDouble: (bloc.state as GoalPageLoaded).newTask.priority,
              onDocumentAdd: () {},
              onImageAdd: () {
                setState(() {
                  print("image add 2");
                  Navigator.pop(context);

                  /// bloc.add(
                  //AddImageAttachment(_newMediaLinkAddressController.text));
                  // _newMediaLinkAddressController.clear();
                });
              },
              onLinkAdd: () {
                print("image add 2");
                Navigator.pop(context);
                _NewLinkBottomSheet(context);
              },
            );
          });
        });
  }

  void _NewEventBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddEvent(
                newMediaLinkAddressController: _newMediaLinkAddressController,
                deadlineDouble: deadlineToDouble(
                    (bloc.state as GoalPageLoaded).newEvent.deadLine),
                onDeadlineChanged: (double value) {
                  setState(() {
                    onDeadlineChanged(value);
                  });
                },
                onPriorityChanged: (double value) {
                  setState(() {
                    onPriorityChanged(value);
                  });
                },
                priorityDouble:
                    (bloc.state as GoalPageLoaded).newEvent.priority);
          });
        });
  }

  void _NewLinkBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddLink(
              textController: _newMediaLinkAddressController,
            );
          });
        });
  }

  isDeadlineClose(DateTime deadLine) {
    if (deadLine.difference(DateTime.now()).inDays < 5)
      return true;
    else
      return false;
  }

  onDeadlineChanged(double value) {
    DateTime newDt = DateTime.now();
    if (value < .3) {
      int hrs = (value * 24 / 0.3).floor();
      newDt = newDt.add(Duration(hours: hrs));
      //bloc.add(UpdateTaskDeadline(newDt));
    } else if (value < .6) {
      int days = ((value - 0.3) * 30 / .3).floor();
      newDt = newDt.add(Duration(days: days));
      //bloc.add(UpdateTaskDeadline(newDt));
    } else {
      int days = ((value - 0.6) * 360 / 0.4).floor();
      print(days);
      newDt = newDt.add(Duration(days: days));
      //bloc.add(UpdateTaskDeadline(newDt));
    }
  }

  double deadlineToDouble(DateTime deadLine) {
    print("deadlineToDouble");
    if (deadLine == null) deadLine = DateTime.now();
    print(deadLine);
    if (deadLine.difference(DateTime.now()).inHours < 24) {
      return ((deadLine.difference(DateTime.now()).inHours) / 24) * 0.3;
    } else if (deadLine.difference(DateTime.now()).inDays < 30) {
      return 0.3 + ((deadLine.difference(DateTime.now()).inDays) / 30) * 0.3;
    } else {
      return 0.6 + ((deadLine.difference(DateTime.now()).inDays) / 360) * 0.4;
    }
  }

  void onPriorityChanged(double value) {
    // bloc.add(UpdateTaskPriority(value));
  }

  int validator(TaskModel newTask) {
    if (newTask.title == null || newTask.title == "") {
      return 1;
    } else if (newTask.deadLine == null) {
      return 2;
    } else
      return 0;
  }

  String validatorString(TaskModel newTask) {
    if (newTask.title == null || newTask.title == "") {
      return "Start by adding a name to your task";
    } else if (newTask.deadLine == null) {
      return "Then add a deadline";
    } else
      return "Mention priority then all done";
  }

  Widget TagTile(
      {TagModel tag, BuildContext context, int index, Function onTapTag}) {
    String valueString =
        tag.color.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = new Color(value);
    Color getContrastColor(Color color) {
      double y =
          (299 * color.red + 587 * color.green + 114 * color.blue) / 1000;
      print(y);
      return y >= 128 ? Colors.black : Colors.white;
    }

    return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(left: 2, right: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: otherColor,
          borderRadius: new BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(.2), width: 1),
        ),
        child: Row(children: [
          RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            text: TextSpan(
              text: "#",
              style: TextStyle(
                fontFamily: 'Milliard',
                fontSize: 14,
                color: getContrastColor(otherColor),
                fontWeight: FontWeight.w300,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: tag.tag,
                    style: TextStyle(
                      fontFamily: "Milliard",
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )),
              ],
            ),
          )
        ]));
  }

  onTapTag() {}
}

class ListTodoCard extends StatefulWidget {
  final TodoItemModel todo;

  ListTodoCard(this.todo);

  @override
  _ListTodoCard createState() => _ListTodoCard();
}

class _ListTodoCard extends State<ListTodoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: Gparam.widthPadding, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(10),
        borderRadius: new BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(.2), width: 2),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: Gparam.widthPadding / 3),
          Stack(
            children: [
              Icon(
                OMIcons.checkBoxOutlineBlank,
                color: Theme.of(context).primaryColor,
              ),
              if (widget.todo.state == 1)
                Icon(
                  OMIcons.done,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
          SizedBox(width: Gparam.widthPadding / 3),
          Flexible(
            child: Container(
              width: Gparam.width,
              alignment: Alignment.center,
              height: 53,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      child: Text(
                        widget.todo.todoItem,
                        maxLines: 1,
                        style: TextStyle(
                          decoration: (widget.todo.state == 1)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontFamily: "Milliard",
                          height: 1.2,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: Gparam.textSmaller,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
