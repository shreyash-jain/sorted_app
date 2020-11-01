import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class LongPlanner extends StatefulWidget {
  final double tileHeight = 70;
  final double headerHeight = 50;
  final double tileWidth = 200;

  @override
  _LongPlannerState createState() => _LongPlannerState();
}

class _LongPlannerState extends State<LongPlanner> {
  LinkedHashMap<String, List<Item>> board;
  bool inAir = false;
  bool isScrollUpdating = false;
  String itemIdInAir = "";
  final DateFormat formatter = DateFormat('dd');
  final DateFormat formatterMonth = DateFormat('MMMM');
  ScrollController _scrollController;
  ScrollController _listScrollController;

  isLastDay(DateTime date) {
// Find the last day of the month.
    var lastDayDateTime = (date.month < 12)
        ? new DateTime(date.year, date.month + 1, 0)
        : new DateTime(date.year + 1, 1, 0);

    return (date.day == lastDayDateTime.day); // 28 for February
  }

  bool isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    board = LinkedHashMap();
    DateTime date = DateTime.now();
    DateTime thisYear = new DateTime(date.year, date.month, 1);
    for (int i = 0; i < 20; i++) {
      print(thisYear);
      board.addAll({
        thisYear.toIso8601String(): [
          Item(
              id: i.toString(),
              listId: thisYear.toIso8601String(),
              title: "🧺 Pear",
              task: TaskModel.getRandom(1)),
        ],
      });

      if (isLeapYear(thisYear.year))
        thisYear = thisYear.add(Duration(days: 366));
      else {
        thisYear = thisYear.add(Duration(days: 365));
      }
    }
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
        //print((object as Item).listId + "  onleave");
      },
      // Moves the card into the position
      onAccept: (Item data) {
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
                  child: Container(
                    height: height,
                  ),
                );
              }).toList()
            ],
          );
        }
      },
    );
  }

  buildHeader(String listId, bool isLastDayBool) {
    var header = Container(
      height: widget.headerHeight,
      child: HeaderWidget(
        title: listId,
        isLastDayBool: isLastDayBool,
        inAir: inAir,
        context: context,
        date: DateTime.parse(listId),
      ),
    );

    return Stack(
      // The header
      children: [
        header,
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

  @override
  Widget build(BuildContext context) {
    buildKanbanList(String listId, List<Item> items, bool isLastDayBool) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            buildHeader(listId, isLastDayBool),
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
                                  onDragStarted: () {
                                    setState(() {
                                      inAir = true;
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
                                    width: isLastDayBool
                                        ? 200
                                        : board[listId].isEmpty
                                            ? 36
                                            : widget.tileWidth,
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
                            text: 'Long-term',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: Gparam.textMedium,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Planner',
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
                            bool isLastDayBool = isLastDay(DateTime.parse(key));
                            return Stack(
                              children: [
                                if (isLastDayBool)
                                  Container(
                                    height: Gparam.height - 50,
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      child: RotatedBox(
                                          quarterTurns: -1,
                                          child: Text(
                                              formatterMonth.format(
                                                      DateTime.parse(key)) +
                                                  " ends",
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w800,
                                              ))),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(30),
                                    ),
                                  ),
                                if (!board[key].isEmpty)
                                  Container(
                                    width: isLastDayBool
                                        ? 200
                                        : board[key].isEmpty
                                            ? 36
                                            : widget.tileWidth,
                                    height: Gparam.height - 50,
                                    alignment: Alignment.bottomLeft,
                                    padding: EdgeInsets.only(left: 21),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: 2,
                                          height: Gparam.height / 10,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(40),
                                        ),
                                        Container(
                                          width: 2,
                                          height: Gparam.height / 10,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(30),
                                        ),
                                        Container(
                                          width: 2,
                                          height: Gparam.height / 10,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(20),
                                        ),
                                        Container(
                                          width: 2,
                                          height: Gparam.height / 10,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(10),
                                        ),
                                        Container(
                                          width: 2,
                                          height: Gparam.height / 10,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(10),
                                        ),
                                        Container(
                                          width: 2,
                                          height: Gparam.height / 10,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(10),
                                        ),
                                        Container(
                                          child: Text(
                                              (board[key].length == 1)
                                                  ? "${board[key].length.toString()} task"
                                                  : "${board[key].length.toString()} tasks",
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w300,
                                              )),
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(5),
                                        ),
                                      ],
                                    ),
                                  ),
                                Container(
                                  width: isLastDayBool
                                      ? 200
                                      : board[key].isEmpty
                                          ? 36
                                          : widget.tileWidth,
                                  height: Gparam.height - 50,
                                  child: buildKanbanList(
                                      key, board[key], isLastDayBool),
                                ),
                              ],
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

  bool isLastsDay(DateTime date) {
    var lastDayDateTime = (date.month < 12)
        ? new DateTime(date.year, date.month + 1, 0)
        : new DateTime(date.year + 1, 1, 0);

    return (date.day == lastDayDateTime.day); // 28 for
  }
}

// The list header (static)
class HeaderWidget extends StatelessWidget {
  final String title;
  final DateTime date;
  final BuildContext context;
  final bool isLastDayBool;

  final bool inAir;
  final DateFormat formatter = DateFormat('dd');
  final DateFormat formatterYear = DateFormat('y');

  HeaderWidget(
      {Key key,
      this.title,
      this.context,
      this.inAir,
      this.date,
      this.isLastDayBool})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 0.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  formatterYear.format(date),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Gparam.textSmall,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Icon(
                  Icons.add,
                  size: Gparam.textSmall,
                  color: Theme.of(context).primaryColor,
                ),
                if (isLastDayBool) SizedBox(width: 8),
              ],
            ),
            Container(
              height: 2,
              color: Theme.of(context).primaryColor.withAlpha(100),
              margin: EdgeInsets.symmetric(horizontal: 3),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Container(
                      child: Text("Deadline",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                  Icon(
                    (item.task.priority > .6)
                        ? Icons.trending_up
                        : (item.task.priority > .3)
                            ? Icons.trending_flat
                            : Icons.trending_down,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 8),
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          )),
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
        //print(event.position.dx);
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
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(2),
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
