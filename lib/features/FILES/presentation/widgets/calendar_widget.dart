import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_calendar_event.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/calendar_bloc/calendar_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/todolist_bloc/todolist_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/calendar_element.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class CalendarWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(int decoration) updateDecoration;

  const CalendarWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  double height = 10;
  final DateFormat mainFormatter = DateFormat('dd MMM, EEEE');

  NotusDocument document;

  var _focusNode = FocusNode();
  CalendarBloc bloc;
  TextEditingController newTodoItemController = TextEditingController();

  FocusNode newTodoFocus = FocusNode();

  ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("Load todolist " + widget.blockInfo.toString());
    bloc = BlocProvider.of<CalendarBloc>(context);
    BlocProvider.of<CalendarBloc>(context)..add(GetCalendar(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(child:
        BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      if (state is CalendarError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is CalendarInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is CalendarLoaded) {
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
                  Container(
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
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
                                  OMIcons.calendarToday,
                                  color: Theme.of(context).highlightColor,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                  child: Text(
                                    state.calendarBlock.title,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        color: Theme.of(context).highlightColor,
                                        fontSize: Gparam.textSmall,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: Gparam.widthPadding / 2),
                          child: Icon(
                            OMIcons.moreVert,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CalendarElement(
                      context: context,
                      selectedMonthEvents: state.thisMonthEvents,
                      selectedDay: state.selectedDate,
                      moveToMonth: moveToMonth,
                      onTapDay: onTapDay),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                    child: Text(
                      mainFormatter.format(state.selectedDate),
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: "Milliard",
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        fontSize: Gparam.textSmall,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 68,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        eventButton(0, "Event", Icons.event, Colors.greenAccent,
                            onTapEventButton),
                        eventButton(1, "Task", Icons.check_circle_outline,
                            Colors.blueAccent, onTapEventButton),
                        eventButton(2, "Milestone", Icons.star,
                            Colors.pinkAccent, onTapEventButton),
                        eventButton(3, "Birthday", Icons.cake,
                            Colors.yellowAccent, onTapEventButton),
                      ],
                    ),
                  ),
                  if (state.selectedDayEvents != null &&
                      state.selectedDayEvents.length > 0)
                    SizedBox(
                      height: 8,
                    ),
                  if (state.selectedDayEvents != null &&
                      state.selectedDayEvents.length == 0)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                      child: Text(
                        "No events ",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Milliard",
                          height: 1.2,
                          fontWeight: FontWeight.w400,
                          fontSize: Gparam.textSmaller,
                        ),
                      ),
                    ),
                  if (state.selectedDayEvents != null &&
                      state.selectedDayEvents.length > 0)
                    Container(
                        width: Gparam.width,
                        child: buildDayEventsList(state.selectedDayEvents)),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ));
      }
    }));
  }

  buildDayEventsList(List<CalendarEventBlock> items) {
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
                                  onTap: () {},
                                  child: DayEventCard(items[index], index)),
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

  moveToMonth(DateTime date) {
    bloc.add(ChangeMonth(date));
  }

  onTapDay(DateTime date) {
    bloc.add(SelectDate(date));
  }

  Widget eventButton(int type, String itemName, IconData icon, Color color,
      Function(int type) onTapButton) {
    return GestureDetector(
      onTap: () {
        onTapButton(type);
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 120,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).textSelectionHandleColor,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                    width: 1, color: Theme.of(context).bottomAppBarColor)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(icon),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Milliard",
                          height: 1.2,
                          fontWeight: FontWeight.w200,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        itemName,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Milliard",
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            height: 2,
            width: 114,
          )
        ],
      ),
    );
  }

  onTapEventButton(int type) {
    _AddEventBottomSheet(
        context, (bloc.state as CalendarLoaded).selectedDate, type);
  }

  void _AddEventBottomSheet(context, DateTime date, int type) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          String eventString;
          if (type == 0)
            eventString = "Event";
          else if (type == 1)
            eventString = "Task";
          else if (type == 2)
            eventString = "Milestone";
          else if (type == 3) eventString = "Birthday";
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      maxLines: 3,
                      initialValue: "",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: "Milliard",
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        fontSize: Gparam.textSmall,
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (newValue) {
                        //widget.onHeadingChanged(newValue);
                        Navigator.pop(context);
                        bloc.add(AddCalendarEvent(CalendarEventBlock(
                            date: date, type: type, title: newValue)));
                      },
                      decoration: InputDecoration(
                        hintText: 'Add $eventString',
                        hintStyle: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Milliard",
                          height: 1.2,
                          fontWeight: FontWeight.w300,
                          fontSize: Gparam.textSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}

class DayEventCard extends StatefulWidget {
  final CalendarEventBlock event;
  final int position;

  DayEventCard(this.event, this.position);

  @override
  _ListTodoCard createState() => _ListTodoCard();
}

class _ListTodoCard extends State<DayEventCard> {
  @override
  Widget build(BuildContext context) {
    print("building " + widget.event.state.toString());
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: Gparam.width * 3 / 4,
              margin: EdgeInsets.symmetric(
                  horizontal: Gparam.widthPadding, vertical: 3),
              child: Row(
                children: <Widget>[
                  SizedBox(width: Gparam.widthPadding / 3),
                  if (widget.event.type == 0)
                    Icon(
                      OMIcons.pinDrop,
                      color: Theme.of(context).highlightColor,
                    ),
                  if (widget.event.type == 2)
                    Icon(
                      OMIcons.starBorder,
                      color: Theme.of(context).highlightColor,
                    ),
                  if (widget.event.type == 3)
                    Icon(
                      OMIcons.cake,
                      color: Theme.of(context).highlightColor,
                    ),
                  if (widget.event.type == 1)
                    Stack(
                      children: [
                        Container(
                            width: 20.0,
                            height: 25.0,
                            decoration: new BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).highlightColor,
                                  width: 2),
                              shape: BoxShape.circle,
                            )),
                        if (widget.event.state == 1)
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
                                      widget.event.title,
                                      maxLines: 2,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: "Milliard",
                                        height: 1,
                                        color: Theme.of(context).highlightColor,
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
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor
                                            .withAlpha(160),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    height: 4,
                                    width: (widget.event.state == 1)
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
              onTap: () {},
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
