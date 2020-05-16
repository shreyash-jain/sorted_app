import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/data/event.dart';
import 'package:notes/data/todo.dart';
import 'package:notes/services/database.dart';
import '../data/models.dart';

class TimelineCardComponent extends StatelessWidget {
  const TimelineCardComponent({
    this.eventData,
    this.todoList,
    this.onTapAction,
    this.position,
    this.openEvent,
    Key key,
  }) : super(key: key);
  final int position;
  final EventModel eventData;
  final List<Todo> todoList;


  final Function(Todo todoData) onTapAction;
  final Function(EventModel eventData) openEvent;

  @override
  Widget build(BuildContext context) {
   var formatter_date = new DateFormat('d MMM');
    var formatter = new DateFormat('Hm');
    double height = 200;
    if (eventData.content.length > 0) {
      height += (20 * (eventData.content.length / 30));
    }
    if (todoList.length > 0) {
      height += (36 * todoList.length);
    }
    String neatDate = formatter.format(eventData.time);
    if (eventData.duration == 0) neatDate = "All Day  < ";
    else {
      neatDate =  eventData.duration.floor().toString()+" mins";
    }

    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        color: Colors.transparent,
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 4, right: 4),
            child: Stack(children: <Widget>[

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: height,

                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(

                            margin: EdgeInsets.only(bottom: 5),
                            width: 5,
                            height: height / 2-35,
                            decoration: new BoxDecoration(
                              borderRadius:
                              BorderRadius.only(bottomRight:Radius.circular(75.0),bottomLeft:Radius.circular(75.0) ),
                              gradient: new LinearGradient(
                                  colors: [
                                    const Color(0xFF00c6ff),
                                    const Color(0xFF00c6ff),
                                  ],
                                  begin: const FractionalOffset(.2, .2),
                                  end: const FractionalOffset(1.0, 1.00),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 8),
                                      child: Text(
                                        position.toString(),
                                        style: TextStyle(
                                            fontFamily: 'ZillaSlab',
                                            fontSize: 16,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ])),
                        Stack(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              decoration: new BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                                gradient: new LinearGradient(
                                    colors: [
                                      Colors.black45,
                                      Colors.black45,
                                    ],
                                    begin: const FractionalOffset(.2, .2),
                                    end: const FractionalOffset(1.0, 1.00),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                            )
                          ],
                        ),

                        Padding(
                            padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                            child: Text(
                              formatter_date.format(eventData.date),
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 16,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(

                            margin: EdgeInsets.only(top: 5),
                            width: 5,
                            height: height / 2-35,
                            decoration: new BoxDecoration(
                              borderRadius:
                              BorderRadius.only(topRight:Radius.circular(75.0),topLeft:Radius.circular(75.0) ),
                              gradient: new LinearGradient(
                                  colors: [
                                    const Color(0xFF00c6ff),
                                    const Color(0xFF00c6ff),
                                  ],
                                  begin: const FractionalOffset(.2, .2),
                                  end: const FractionalOffset(1.0, 1.00),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                           ),

                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              openEvent(eventData);
                            },
                            child: Container(
                              padding:
                              EdgeInsets.only(left: 2, top: 4, bottom: 4),
                              decoration: (eventData.duration == 0)
                                  ? BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [
                                      const Color(0xFF00c6ff),
                                      Theme.of(context).primaryColor,
                                    ],
                                    begin: const FractionalOffset(.2, .2),
                                    end: const FractionalOffset(1.0, 1.00),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                borderRadius: BorderRadius.circular(20.0),
                              )
                                  : BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: (eventData.duration == 0)
                                        ? EdgeInsets.only(left: 12)
                                        : EdgeInsets.only(left: 0),
                                    child: Text(
                                      '${eventData.title.trim().length <= 18 ? eventData.title.trim() : eventData.title.trim().substring(0, 18) + '...'}',
                                      style: TextStyle(
                                          color: (eventData.duration == 0)
                                              ? Colors.white
                                              : null,
                                          fontFamily: 'ZillaSlab',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    '$neatDate',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'ZillaSlab',
                                        color: (eventData.duration == 0)
                                            ? Colors.black26
                                            : Colors.grey.shade400,
                                        fontWeight: (eventData.duration == 0)
                                            ? FontWeight.w600
                                            : FontWeight.w500),
                                  ),
                                ],
                              ),
                            )),
                        if (eventData.content != "")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin:
                                EdgeInsets.only(top: 12, left: 8, bottom: 12),
                                child: Text(
                                  '${eventData.content}',
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: 18,
                                      color: Colors.grey.shade400),
                                ),
                              ),
                            ],
                          ),
                        if (eventData.content == "")
                          SizedBox(
                            height: 16,
                          ),
                        if (todoList != null && todoList.length != 0)
                          Container(
                              padding: EdgeInsets.only(top: 4, bottom: 16),
                              decoration: BoxDecoration(
                                color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                    ? Theme.of(context).cardColor
                                    : Color(0xFFF5F7FB),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: todoList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return _buildCategoryCard(
                                      context,
                                      index,
                                      todoList[index],
                                    );
                                  })),
                        if (todoList != null && todoList.length != 0)
                          SizedBox(
                            height: 16,
                          )
                      ],
                    ),
                  ),
                ],
              ),

              Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RotatedBox(

                        quarterTurns: -1,
                        child:Padding(
                            padding: EdgeInsets.only(
                            ),
                            child: Text(
                              "3 days Later",
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 14,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ])
            ],)
          ),
        ));
  }

  Widget _buildCategoryCard(BuildContext context, int index, Todo this_todo) {
    return GestureDetector(
      onTap: () {
        onTapAction(this_todo);
        print("touched " + this_todo.description);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 0, top: 4, right: 8),
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    color: Color(0xFFAFB4C6),
                    fontSize: 16.0,
                    decoration: this_todo.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
            Flexible(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20.0, bottom: 0, top: 4, right: 8),
                child: Text(
                  this_todo.description,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      color: Color(0xFFAFB4C6),
                      fontSize: 18.0,
                      decoration: this_todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
/* BoxShadow buildBoxShadow(Color color, BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
          color: noteData.isImportant == true
              ? Colors.black.withAlpha(100)
              : Colors.black.withAlpha(10),
          blurRadius: 8,
          offset: Offset(0, 8));
    }
    return BoxShadow(
        color: noteData.isImportant == true
            ? color.withAlpha(60)
            : color.withAlpha(25),
        blurRadius: 8,
        offset: Offset(0, 8));
  }*/
}
