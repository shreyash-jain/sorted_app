import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';

class Item {
  final String id;
  String listId;
  final TaskModel task;
  final String title;

  Item({this.id, this.listId, this.title, this.task});
}

class Kanban extends StatefulWidget {
  final double tileHeight = 70;
  final double headerHeight = 50;
  final double tileWidth = 250;

  @override
  _KanbanState createState() => _KanbanState();
}

class _KanbanState extends State<Kanban> {
  LinkedHashMap<String, List<Item>> board;
  bool inAir = false;
  bool isScrollUpdating = false;
  String itemIdInAir = "";

  ScrollController _scrollController;
  ScrollController _listScrollController;

  @override
  void initState() {
    board = LinkedHashMap();
    board.addAll({
      "1": [
        Item(
            id: "1",
            listId: "1",
            title: "🧺 Pear",
            task: TaskModel.getRandom(1)),
        Item(
            id: "2",
            listId: "1",
            title: "Potato",
            task: TaskModel.getRandom(2)),
      ],
      "2": [
        Item(
            id: "3",
            listId: "2",
            title: "💳 Car",
            task: TaskModel.getRandom(3)),
        Item(
            id: "4",
            listId: "2",
            title: "Bycicle of the hill",
            task: TaskModel.getRandom(4)),
        Item(
            id: "5",
            listId: "2",
            title:
                "📰 On foot with a crazy man On foot with a crazy man On foot with a crazy man",
            task: TaskModel.getRandom(5)),
      ],
      "3": [
        Item(
            id: "6", listId: "3", title: "Chile", task: TaskModel.getRandom(6)),
        Item(
            id: "7",
            listId: "3",
            title: "Madagascar valley's tree fruits",
            task: TaskModel.getRandom(7)),
        Item(
            id: "8",
            listId: "3",
            title: "💰 Japan nuclear plant",
            task: TaskModel.getRandom(8)),
      ],
      "4": [
        Item(
            id: "9",
            listId: "4",
            title: "📕 Chile",
            task: TaskModel.getRandom(9)),
        Item(
            id: "10",
            listId: "4",
            title: "Madagascar valley's tree fruits",
            task: TaskModel.getRandom(10)),
        Item(
            id: "11",
            listId: "4",
            title: "Japan nuclear plant",
            task: TaskModel.getRandom(11)),
      ],
      "5": [
        Item(
            id: "12",
            listId: "5",
            title: "Chile",
            task: TaskModel.getRandom(12)),
        Item(
            id: "13",
            listId: "5",
            title: "Madagascar valley's tree fruits",
            task: TaskModel.getRandom(13)),
        Item(
            id: "14",
            listId: "5",
            title: "Japan nuclear plant",
            task: TaskModel.getRandom(14)),
      ]
    });
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );
    _listScrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );

    super.initState();
  }

  buildItemDragTarget(listId, targetPosition, double height) {
    return DragTarget<Item>(
      // Will accept others, but not himself
      onWillAccept: (Item data) {
        print("inair " + inAir.toString());

        return board[listId].isEmpty ||
            data.id != board[listId][targetPosition].id;
      },
      onLeave: (object) {
        setState(() {
          inAir = true;
          itemIdInAir = (object as Item).id;
        });

        //print((object as Item).listId + "  onleave");
      },
      // Moves the card into the position
      onAccept: (Item data) {
        setState(() {
          itemIdInAir = "";
          inAir = false;
        });
        print("inair " + inAir.toString());

        setState(() {
          if (board[data.listId] != null) {
            board[data.listId].remove(data);
            data.listId = listId;
            if (board[listId].length > targetPosition) {
              board[listId].insert(targetPosition + 1, data);
            } else {
              board[listId].add(data);
            }
          }
        });
      },
      builder:
          (BuildContext context, List<Item> data, List<dynamic> rejectedData) {
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
              ...data.map((Item item) {
                //print("list id" + item.listId.toString());
                return Opacity(
                  opacity: 0.5,
                  child: ItemWidget(
                      inAirItemId: itemIdInAir,
                      item: item,
                      inAir: inAir,
                      context: context),
                );
              }).toList()
            ],
          );
        }
      },
    );
  }

  buildHeader(String listId) {
    Widget header = Container(
      height: widget.headerHeight,
      child: HeaderWidget(title: listId, inAir: inAir, context: context),
    );

    return Stack(
      // The header
      children: [
        LongPressDraggable<String>(
          axis: Axis.horizontal,
          data: listId,
          child: header, // A header waiting to be dragged
          childWhenDragging: Opacity(
            // The header that's left behind
            opacity: 0.5,
            child: header,
          ),
          feedback: FloatingWidget(
            child: Container(
              // A header floating around
              width: widget.tileWidth,
              child: header,
            ),
          ),
        ),
        buildItemDragTarget(listId, 0, widget.headerHeight),
        DragTarget<String>(
          // Will accept others, but not himself
          onWillAccept: (String incomingListId) {
            //print("hello" + incomingListId.toString());
            //print(listId);
            return listId != incomingListId;
          },
          // Moves the card into the position
          onAccept: (String incomingListId) {
            setState(
              () {
                LinkedHashMap<String, List<Item>> reorderedBoard =
                    LinkedHashMap();
                for (String key in board.keys) {
                  if (key == incomingListId) {
                    reorderedBoard[listId] = board[listId];
                  } else if (key == listId) {
                    reorderedBoard[incomingListId] = board[incomingListId];
                  } else {
                    reorderedBoard[key] = board[key];
                  }
                }
                board = reorderedBoard;
              },
            );
          },

          builder: (BuildContext context, List<String> data,
              List<dynamic> rejectedData) {
            if (data.isEmpty) {
              // The area that accepts the draggable
              return Container(
                height: widget.headerHeight,
                width: widget.tileWidth,
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.blueAccent,
                  ),
                ),
                height: widget.headerHeight,
                width: widget.tileWidth,
              );
            }
          },
        )
      ],
    );
  }

  buildNewTaskHeader(String listId) {
    return Container(
      height: widget.headerHeight,
      child: AddTaskWidget(title: listId, inAir: inAir, context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    buildKanbanList(String listId, List<Item> items) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            buildHeader(listId),
            Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
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
                                LongPressDraggable<Item>(
                                  data: items[index],
                                  feedbackOffset: Offset.fromDirection(500),
                                  onDragCompleted: () {
                                    setState(() {
                                      inAir = false;
                                      itemIdInAir = "";
                                    });
                                  },
                                  onDragEnd: (value) {
                                    setState(() {
                                      inAir = false;
                                      itemIdInAir = "";
                                    });
                                  },
                                  child: ItemWidget(
                                    item: items[index],
                                    inAir: inAir,
                                    inAirItemId: itemIdInAir,
                                    context: context,
                                    moveTo: (value) {
                                      moveScreen(value);
                                    },
                                  ),
                                  childWhenDragging: Opacity(
                                    // The card that's left behind
                                    opacity: 0.2,
                                    child: ItemWidget(
                                        item: items[index],
                                        inAir: inAir,
                                        inAirItemId: itemIdInAir,
                                        context: context),
                                  ),
                                  feedback: Container(
                                    // A card floating around
                                    height: widget.tileHeight,
                                    width: widget.tileWidth,
                                    child: FloatingWidget(
                                        child: ItemWidget(
                                      item: items[index],
                                      inAir: inAir,
                                      inAirItemId: itemIdInAir,
                                      context: context,
                                      moveTo: (value) {
                                        moveScreen(value);
                                      },
                                    )),
                                  ),
                                ),
                                buildItemDragTarget(
                                    listId, index, widget.tileHeight),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            buildNewTaskHeader(listId),
            SizedBox(height: 10),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(OMIcons.arrowBackIos,
                            color: Theme.of(context).primaryColor),
                        tooltip: 'back',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Board',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: Gparam.textMedium,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' View',
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Gparam.textSmall,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(OMIcons.menu,
                            color: Theme.of(context).primaryColor),
                        tooltip: 'reminders',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollStartNotification) {
                        isScrollUpdating = true;
                        print("isScrollUpdating = true;");
                      } else if (scrollNotification is ScrollEndNotification) {
                        isScrollUpdating = false;
                        print("isScrollUpdating = false;");
                      }
                    },
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: false,
                      controller: _scrollController,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: board.keys.map((String key) {
                            return Container(
                              width: widget.tileWidth,
                              height: Gparam.height - 50,
                              child: buildKanbanList(key, board[key]),
                            );
                          }).toList()),
                    )),
                    
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  height: (inAir) ? 50 : 0,
                  color: Colors.lightBlue,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInQuint,
                ))
          ],
        );
      })),
    );
  }

  void moveScreen(bool value) {
    if (inAir) {
      if (!value) {
        print("this");
        if (!isScrollUpdating &&
            _scrollController.position.pixels > Gparam.width / 12)
          _scrollController.animateTo(
              _scrollController.position.pixels - Gparam.width / 5,
              duration: Duration(milliseconds: 100),
              curve: Curves.decelerate);
      } else {
        print("that");
        if (!isScrollUpdating)
          _scrollController.animateTo(
              _scrollController.position.pixels + Gparam.width / 5,
              duration: Duration(milliseconds: 100),
              curve: Curves.decelerate);
      }
    }
  }
}

// The list header (static)
class HeaderWidget extends StatelessWidget {
  final String title;
  final BuildContext context;

  final bool inAir;

  const HeaderWidget({Key key, this.title, this.context, this.inAir})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (!inAir)
          ? Theme.of(context).scaffoldBackgroundColor
          : Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 0.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.work,
                  color: Theme.of(context).primaryColor,
                  size: Gparam.textSmaller,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Gparam.textSmaller,
                    color: (inAir)
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).primaryColor,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.open_with,
                  color: Theme.of(context).primaryColor,
                  size: Gparam.textSmaller,
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddTaskWidget extends StatelessWidget {
  final String title;
  final BuildContext context;

  final bool inAir;

  const AddTaskWidget({Key key, this.title, this.context, this.inAir})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withAlpha(20),
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 0.0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 0.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Icon(
                  OMIcons.addCircle,
                  color: Theme.of(context).primaryColor,
                  size: Gparam.textMedium,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Container(
                    child: Text(
                      " Task",
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: Gparam.textSmaller,
                        fontWeight: FontWeight.bold,
                        color: (inAir)
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// The card (static)
class ItemWidget extends StatelessWidget {
  final Item item;
  final BuildContext context;
  final String inAirItemId;
  final bool inAir;
  final Function(bool direction) moveTo;

  const ItemWidget(
      {Key key,
      this.item,
      this.moveTo,
      this.context,
      this.inAir,
      this.inAirItemId})
      : super(key: key);
  Widget makeListTile(Item item, BuildContext context) => Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(item.task.taskImageId,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: Gparam.textSmall,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800,
                      )),
                  SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      child: Text(item.task.title,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textVerySmall,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    (item.task.priority > .6)
                        ? Icons.trending_up
                        : (item.task.priority > .3)
                            ? Icons.trending_flat
                            : Icons.trending_down,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                  Spacer(),
                  RichText(
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    text: TextSpan(
                      text: pastDeadline(item.task.deadLine) + " ",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: Gparam.textVerySmall,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).primaryColor),
                      children: <TextSpan>[
                        TextSpan(
                            text: countdownDays(item.task.deadLine),
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              fontSize: Gparam.textVerySmall,
                            )),
                        TextSpan(
                            text: countdownDaysUnit(item.task.deadLine),
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              height: 1.2,
                              fontWeight: FontWeight.w300,
                              fontSize: Gparam.textVerySmall,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  num radsToDegrees(num rad) {
    return (rad * 180.0) / pi;
  }

  String getPriorityString(double priority) {
    if (priority < .3)
      return "Low";
    else if (priority < .6)
      return "Medium";
    else
      return "High";
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

  bool isNearDeadline(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays.abs() < 2) {
      return true;
    }
    return false;
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
      return "in";
    } else if (rDays < 0) {
      return "Past";
    } else {
      if (deadLine.isAfter(DateTime.now())) {
        return "in";
      } else
        return "Past";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        print(event.position.dx);
        if (moveTo != null) if (event.position.dx > 5 * Gparam.width / 6) {
          print("here");
          moveTo(true);
          print("here");
        } else if (event.position.dx < Gparam.width / 6) {
          print("there");
          moveTo(false);
          print("there");
        }
      },
      child: // ...
          Container(
        height: 70,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(2),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).dialogBackgroundColor.withOpacity(.8),
                offset: Offset(1.0, 00),
                blurRadius: 1.0,
                spreadRadius: 2.0),
            BoxShadow(
                color: Theme.of(context).dialogBackgroundColor.withOpacity(.6),
                offset: Offset(-1.0, 0.0),
                blurRadius: 1,
                spreadRadius: 1.0),
          ],
        ),
        child: makeListTile(item, context),
      ),
    );
  }
}

class FloatingWidget extends StatelessWidget {
  final Widget child;

  const FloatingWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.3,
      child: child,
    );
  }
}
