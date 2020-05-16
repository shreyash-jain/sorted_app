import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/data/rEvent.dart';
import 'package:notes/data/timeline.dart';
import 'package:notes/data/user_activity.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/BluePainter.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/event.dart';
import 'package:notes/data/models.dart';
import 'package:notes/services/database.dart';
import 'package:notes/bloc/todo_bloc.dart';
import 'package:notes/data/todo.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class AddEventPage extends StatefulWidget {
  Function() triggerRefetch;
  EventModel existingEvent;
  DateTime event_date;
  TimelineModel event_tl;

  AddEventPage(
      {Key key,
      Function() triggerRefetch,
      EventModel existingEvent,
      DateTime event_date,
      TimelineModel event_tl})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingEvent = existingEvent;
    this.event_date = event_date;
    this.event_tl = event_tl;
  }

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage>
    with TickerProviderStateMixin {
  bool isDirty = false;
  bool validator = false;
  bool isNoteNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode TimelineNameFocus = FocusNode();
  FocusNode TimelineContentFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  String timeline_name = "";
  String _date = "Select Date";
  bool open_timeline = false;
  double timeline_card_h = 50;
  int card_open = 0;
  String _time = "Select Start Time";
  final globalKey = GlobalKey<ScaffoldState>();
  double _currentDoubleValue = 0.0;
  DateTime time_selected;
  EventModel currentEvent;
  List<UserAModel> ActivityList = [];
  ReventModel currentRevent = null;
  List<int> repeatDays = [];
  DateModel this_date;
  bool timeline = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController TimelineName = TextEditingController();
  TextEditingController TimelineContent = TextEditingController();
  DateTime event_date;
  Duration _duration = Duration(hours: 0, minutes: 0);
  TodoBloc todoBloc;
  int activity_position = -1;
  final String title = "";
  ScrollController _scrollController = new ScrollController();
  List<int> Todos = List<int>();
  bool isPlaying = false;
  int _currentPage = 0;
  List<TimelineModel> all_timelines = [];

  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;
  String hr = "";
  String min = "";
  AnimationController icon_controller;
  bool isSwitched = false;
  double dyn_height = 400;

  var allday = true;
  final PageController _pageController = PageController(initialPage: 0);
  bool repeat = false;
  TimelineModel this_timeline;
  double align_value = 600;

  Timer _timer;

  @override
  void initState() {
    super.initState();

    if (widget.existingEvent == null) {
      currentEvent = EventModel(
          content: '',
          title: '',
          date: DateTime.now(),
          time: DateTime.now(),
          isImportant: false,
          todo_id: 0,
          date_id: 0,
          timeline_id: 0,
          duration: 0,
          a_id: 0,
          r_id: 0);
      isNoteNew = true;

      if (widget.event_tl != null && widget.event_tl.id != 0) {
        timeline = true;
        currentEvent.timeline_id = widget.event_tl.id;
        print(currentEvent.timeline_id);
        timeline_name = widget.event_tl.title;
      }

      if (widget.event_date != null) {
        setDate();
      }
    } else {
      validator = true;
      currentEvent = widget.existingEvent;
      print(currentEvent.timeline_id);
      if (currentEvent.timeline_id != null && currentEvent.timeline_id != 0) {
        timeline = true;
        print(currentEvent.timeline_id);
        get_Timeline(currentEvent.timeline_id);
      }
      activity_position = currentEvent.a_id - 1;
      if (currentEvent.duration == 0) allday = false;
      time_selected = currentEvent.time;
      get_dateModel(currentEvent.date_id);
      todoBloc = TodoBloc(currentEvent.todo_id);
      isNoteNew = false;
      get_ReventModel(currentEvent.r_id);
      var formatter = new DateFormat('dd-MM-yyyy');
      String formatted_date = formatter.format(currentEvent.date);
      var formatter_time = new DateFormat('H : m');
      String formatted_time = formatter_time.format(currentEvent.time);
      _date = formatted_date;
      _time = formatted_time;
      min = currentEvent.duration.round().toString();
      if (currentEvent.todo_id != 0) isSwitched = true;
    }

    icon_controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    get_ActivityModel();
    titleController.text = currentEvent.title;
    contentController.text = currentEvent.content;
  }

  setDate() async {
    DateTime date = widget.event_date;
    currentEvent.date = date;
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted_date = formatter.format(date);
    print("formatted date: " + formatted_date);
    var fetchedDate =
        await NotesDatabaseService.db.getDateByDateFromDB(formatted_date);
    setState(() {
      this_date = fetchedDate;
    });

    if (this_date == null) {
      DateModel newDate = DateModel(
          date: date,
          time_start: DateTime.now(),
          time_end: DateTime.now(),
          survey: 0);
      var added_date = await NotesDatabaseService.db.addDateInDB(newDate);
      setState(() {
        this_date = added_date;
        currentEvent.date_id = this_date.id;
      });
      print("here 2  ");
    } else {
      currentEvent.date_id = this_date.id;
    }

    setState(() {
      _date = formatted_date;
    });
  }

  get_dateModel(int id) async {
    var fetchedDate = await NotesDatabaseService.db.getDateByIdFromDB(id);
    setState(() {
      this_date = fetchedDate;
    });
  }

  get_Timeline(int id) async {
    print("pk " + id.toString());
    var fetchedTimeline =
        await NotesDatabaseService.db.getTimelineFromIdFromDB(id);
    setState(() {
      this_timeline = fetchedTimeline;
      timeline_name = this_timeline.title;
    });
  }

  get_ActivityModel() async {
    var fetchedDate = await NotesDatabaseService.db.getUserActiviyFromDB();
    setState(() {
      ActivityList = fetchedDate;
    });
    get_TimelinesModel();
  }

  get_TimelinesModel() async {
    var fetchedTimelines = await NotesDatabaseService.db.getTimelinesFromDB();
    setState(() {
      all_timelines = fetchedTimelines;
    });
    print("Timelines : " + all_timelines.length.toString());
  }

  @override
  void dispose() {
    icon_controller.dispose();
    _timer.cancel();
    _pageController.dispose();

    super.dispose();
  }

  get_ReventModel(int id) async {
    if (id != 0) {
      repeat = true;
      var fetchedRevent = await NotesDatabaseService.db.getReventByIdFromDB(id);
      setState(() {
        currentRevent = fetchedRevent;
      });
      if (currentRevent.sun == 1) {
        repeatDays.add(1);
      }
      if (currentRevent.mon == 1) {
        repeatDays.add(2);
      }
      if (currentRevent.tue == 1) {
        repeatDays.add(3);
      }
      if (currentRevent.wed == 1) {
        repeatDays.add(4);
      }
      if (currentRevent.thu == 1) {
        repeatDays.add(5);
      }
      if (currentRevent.fri == 1) {
        repeatDays.add(6);
      }
      if (currentRevent.sat == 1) {
        repeatDays.add(7);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        floatingActionButton: _getFAB(),
        body: CustomPaint(
            painter: BluePainter(Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).primaryColor),
            child: Stack(
              children: <Widget>[
                IgnorePointer(
                    ignoring: open_timeline,
                    child: AnimatedOpacity(
                        opacity: open_timeline ? 0 : 1,
                        duration: Duration(milliseconds: 700),
                        child: (!open_timeline)
                            ? ListView(
                                controller: _scrollController,
                                shrinkWrap: true,
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextField(
                                      focusNode: titleFocus,
                                      controller: titleController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      maxLength: 16,
                                      onSubmitted: (text) {
                                        titleFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(contentFocus);
                                      },
                                      onChanged: (value) {
                                        markTitleAsDirty(value);
                                      },
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontFamily: 'ZillaSlab',
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700),
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Enter a title',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 32,
                                            fontFamily: 'ZillaSlab',
                                            fontWeight: FontWeight.w700),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16,
                                        top: 2,
                                        bottom: 2),
                                    child: TextField(
                                      focusNode: contentFocus,
                                      controller: contentController,
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (value) {
                                        markContentAsDirty(value);
                                      },
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Write a discription ...',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 16, bottom: 12),
                                    child: Container(
                                      height: 70,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: ActivityList.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buildCategoryCard2(
                                                index, ActivityList[index]);
                                          }),
                                    ),
                                  ),
                                  Container(
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(.5),
                                    child: Column(children: <Widget>[
                                      RaisedButton(
                                        color: Colors.transparent,
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 4,
                                            bottom: 4),
                                        elevation: 0,
                                        onPressed: () async {
                                          titleFocus.unfocus();
                                          contentFocus.unfocus();
                                          final DateTime ndate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now()
                                                      .subtract(new Duration(
                                                          days: 1)),
                                                  lastDate: DateTime(2101));
                                          if (ndate != null) {
                                            check_validate();
                                            DateTime date = DateTime(ndate.year,
                                                ndate.month, ndate.day, 0, 1);

                                            currentEvent.date = date;
                                            var formatter =
                                                new DateFormat('dd-MM-yyyy');
                                            String formatted_date =
                                                formatter.format(date);
                                            print("formatted date: " +
                                                formatted_date);
                                            var fetchedDate =
                                                await NotesDatabaseService.db
                                                    .getDateByDateFromDB(
                                                        formatted_date);
                                            setState(() {
                                              this_date = fetchedDate;
                                            });

                                            if (this_date == null) {
                                              DateModel newDate = DateModel(
                                                  date: date,
                                                  time_start: DateTime.now(),
                                                  time_end: DateTime.now(),
                                                  survey: 0);
                                              var added_date =
                                                  await NotesDatabaseService.db
                                                      .addDateInDB(newDate);
                                              setState(() {
                                                this_date = added_date;
                                                currentEvent.date_id =
                                                    this_date.id;
                                              });
                                              print("here 2  ");
                                            } else {
                                              currentEvent.date_id =
                                                  this_date.id;
                                            }
                                            var formatter2 =
                                                new DateFormat('dd MMMM');
                                            _date = formatter2.format(date);

                                            setState(() {
                                              isDirty = true;
                                            });
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 45.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.date_range,
                                                          size: 18.0,
                                                        ),
                                                        Container(
                                                          width: 16,
                                                        ),
                                                        Text(
                                                          " $_date",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'ZillaSlab',
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "  Change",
                                                style: TextStyle(
                                                    fontFamily: 'ZillaSlab',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                          OutlineButton(
                                              child: new Text("Today ?"),
                                              onPressed: () async {
                                                check_validate();
                                                titleFocus.unfocus();
                                                contentFocus.unfocus();
                                                DateTime date = DateTime.now();
                                                currentEvent.date = date;
                                                var formatter = new DateFormat(
                                                    'dd-MM-yyyy');
                                                String formatted_date =
                                                    formatter.format(date);
                                                print("formatted date: " +
                                                    formatted_date);
                                                var fetchedDate =
                                                    await NotesDatabaseService
                                                        .db
                                                        .getDateByDateFromDB(
                                                            formatted_date);
                                                setState(() {
                                                  this_date = fetchedDate;
                                                });

                                                if (this_date == null) {
                                                  DateModel newDate = DateModel(
                                                      date: date,
                                                      time_start:
                                                          DateTime.now(),
                                                      time_end: DateTime.now(),
                                                      survey: 0);
                                                  var added_date =
                                                      await NotesDatabaseService
                                                          .db
                                                          .addDateInDB(newDate);
                                                  setState(() {
                                                    this_date = added_date;
                                                    currentEvent.date_id =
                                                        this_date.id;
                                                  });
                                                  print("here 2  ");
                                                } else {
                                                  currentEvent.date_id =
                                                      this_date.id;
                                                }
                                                var formatter2 =
                                                    new DateFormat('dd MMMM');

                                                setState(() {
                                                  _date =
                                                      formatter2.format(date);
                                                  isDirty = true;
                                                });
                                              },
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0))),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          OutlineButton(
                                              child: new Text("Tomorrow ?"),
                                              onPressed: () async {
                                                check_validate();
                                                titleFocus.unfocus();
                                                contentFocus.unfocus();
                                                DateTime date = DateTime.now()
                                                    .add(new Duration(days: 1));
                                                currentEvent.date = date;
                                                var formatter = new DateFormat(
                                                    'dd-MM-yyyy');
                                                String formatted_date =
                                                    formatter.format(date);
                                                print("formatted date: " +
                                                    formatted_date);
                                                var fetchedDate =
                                                    await NotesDatabaseService
                                                        .db
                                                        .getDateByDateFromDB(
                                                            formatted_date);
                                                setState(() {
                                                  this_date = fetchedDate;
                                                });

                                                if (this_date == null) {
                                                  DateModel newDate = DateModel(
                                                      date: date,
                                                      time_start:
                                                          DateTime.now(),
                                                      time_end: DateTime.now(),
                                                      survey: 0);
                                                  var added_date =
                                                      await NotesDatabaseService
                                                          .db
                                                          .addDateInDB(newDate);
                                                  setState(() {
                                                    this_date = added_date;
                                                    currentEvent.date_id =
                                                        this_date.id;
                                                  });
                                                  print("here 2  ");
                                                } else {
                                                  currentEvent.date_id =
                                                      this_date.id;
                                                }
                                                var formatter2 =
                                                    new DateFormat('dd MMMM');

                                                setState(() {
                                                  check_validate();
                                                  _date =
                                                      formatter2.format(date);
                                                  isDirty = true;
                                                });
                                              },
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                    ]),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 0, bottom: 0),
                                    height: 60.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.timer,
                                                    size: 18.0,
                                                  ),
                                                  Container(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    "Set Time",
                                                    style: TextStyle(
                                                        fontFamily: 'ZillaSlab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Switch(
                                          value: allday,
                                          onChanged: (value) {
                                            setState(() {
                                              allday = value;
                                              check_validate();
                                              titleFocus.unfocus();
                                              contentFocus.unfocus();
                                              if (!allday) {
                                                currentEvent.duration = 0;

                                                _time = "Select Start Time";
                                                min = '0';
                                              } else {
                                                repeatDays.clear();
                                              }
                                            });
                                          },
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IgnorePointer(
                                      ignoring: !allday,
                                      child: AnimatedOpacity(
                                          opacity: allday ? 1 : 0,
                                          duration: Duration(milliseconds: 700),
                                          child: (allday)
                                              ? RaisedButton(
                                                  color: Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(.5),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 4,
                                                          bottom: 4),
                                                  elevation: 0,
                                                  onPressed: () async {
                                                    titleFocus.unfocus();
                                                    contentFocus.unfocus();
                                                    repeatDays.clear();
                                                    if (!allday) return null;
                                                    if (_date ==
                                                        "Select Date") {
                                                      final snackBar = SnackBar(
                                                          content: Text(
                                                              'First Select a Date'));
                                                      globalKey.currentState
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else {
                                                      final TimeOfDay response =
                                                          await showTimePicker(
                                                        context: context,
                                                        initialTime: TimeOfDay(
                                                            hour: currentEvent
                                                                .time.hour,
                                                            minute: currentEvent
                                                                .time.minute),
                                                      );
                                                      if (response != null) {
                                                        DateTime time =
                                                            DateTime(
                                                                2000,
                                                                1,
                                                                1,
                                                                response.hour,
                                                                response
                                                                    .minute);
                                                        List<EventModel>
                                                            eventsList = [];
                                                        var fetchedEvents =
                                                            await NotesDatabaseService
                                                                .db
                                                                .getEventsOfDateFromDB(
                                                                    this_date
                                                                        .id);
                                                        setState(() {
                                                          eventsList =
                                                              fetchedEvents;
                                                          print(eventsList);
                                                        });
                                                        int conflict = 0;
                                                        for (var i = 0;
                                                            i <
                                                                eventsList
                                                                    .length;
                                                            i++) {
                                                          DateTime event_start =
                                                              eventsList[i]
                                                                  .time;
                                                          DateTime event_end = event_start
                                                              .add(new Duration(
                                                                  minutes: eventsList[
                                                                          i]
                                                                      .duration
                                                                      .floor()));
                                                          if (time.isAfter(
                                                                  event_start) &&
                                                              time.isBefore(
                                                                  event_end)) {
                                                            // do something;

                                                            final snackBar = SnackBar(
                                                                content: Text(
                                                                    'Selected time is conflicting with Previous Events'));
                                                            globalKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    snackBar);

                                                            conflict = 1;
                                                            break;
                                                          }
                                                        }
                                                        print('confirm $time');
                                                        if (conflict == 0) {
                                                          setState(() {
                                                            isDirty = true;
                                                          });
                                                          time_selected = time;

                                                          _time =
                                                              DateFormat.jm()
                                                                  .format(time);

                                                          currentEvent.time =
                                                              time;

                                                          setState(() {
                                                            check_validate();
                                                          });
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 50.0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    size: 18.0,
                                                                  ),
                                                                  Container(
                                                                    width: 16,
                                                                  ),
                                                                  Text(
                                                                    " $_time",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'ZillaSlab',
                                                                        fontSize:
                                                                            18.0),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          "  Change",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'ZillaSlab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 18.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                ))),
                                  IgnorePointer(
                                      ignoring: !allday,
                                      child: AnimatedOpacity(
                                          opacity: allday ? 1 : 0,
                                          duration: Duration(milliseconds: 700),
                                          child: (allday)
                                              ? RaisedButton(
                                                  color: Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(.5),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 4,
                                                          bottom: 4),
                                                  elevation: 0,
                                                  onPressed: () async {
                                                    if (!allday) return null;
                                                    titleFocus.unfocus();
                                                    repeatDays.clear();
                                                    // Use it as a dialog, passing in an optional initial time
                                                    // and returning a promise that resolves to the duration
                                                    // chosen when the dialog is accepted. Null when cancelled.
                                                    if (_time ==
                                                        "Select Start Time") {
                                                      final snackBar = SnackBar(
                                                          content: Text(
                                                              'First Select start time'));
                                                      globalKey.currentState
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else {
                                                      Duration
                                                          resultingDuration =
                                                          await showDurationPicker(
                                                        context: context,
                                                        initialTime: new Duration(
                                                            minutes:
                                                                currentEvent
                                                                    .duration
                                                                    .round()),
                                                        snapToMins: 5.0,
                                                      );

                                                      _duration =
                                                          resultingDuration;

                                                      List<EventModel>
                                                          eventsList = [];
                                                      var fetchedEvents =
                                                          await NotesDatabaseService
                                                              .db
                                                              .getEventsOfDateFromDB(
                                                                  this_date.id);
                                                      setState(() {
                                                        eventsList =
                                                            fetchedEvents;
                                                      });
                                                      int conflict = 0;
                                                      for (var i = 0;
                                                          i < eventsList.length;
                                                          i++) {
                                                        DateTime event_start =
                                                            eventsList[i].time;

                                                        DateTime this_end =
                                                            time_selected
                                                                .add(_duration);
                                                        if (event_start.isAfter(
                                                                time_selected) &&
                                                            event_start
                                                                .isBefore(
                                                                    this_end)) {
                                                          final difference =
                                                              event_start
                                                                  .difference(
                                                                      time_selected)
                                                                  .inMinutes;
                                                          // do something;

                                                          final snackBar = SnackBar(
                                                              content: Text(
                                                                  'Duration can be max $difference mins as ${eventsList[i].title} event will conflict'));
                                                          globalKey.currentState
                                                              .showSnackBar(
                                                                  snackBar);
                                                          conflict = 1;
                                                          break;
                                                        }
                                                      }
                                                      if (conflict == 0) {
                                                        setState(() {
                                                          isDirty = true;
                                                          hr = _duration.inHours
                                                              .toString();
                                                          min = _duration
                                                              .inMinutes
                                                              .toString();
                                                          currentEvent
                                                                  .duration =
                                                              _duration
                                                                  .inMinutes
                                                                  .toDouble();
                                                          check_validate();
                                                          print("duration " +
                                                              currentEvent
                                                                  .duration
                                                                  .toString());
                                                        });
                                                        print(
                                                            "this is printed : " +
                                                                hr);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 50.0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .timelapse,
                                                                    size: 18.0,
                                                                  ),
                                                                  Container(
                                                                    width: 16,
                                                                  ),
                                                                  Text(
                                                                    "Duration : $min mins",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            'ZillaSlab',
                                                                        fontSize:
                                                                            18.0),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          "  Change",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'ZillaSlab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 18.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                ))),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 0, bottom: 0),
                                    height: 60.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.refresh,
                                                    size: 18.0,
                                                  ),
                                                  Container(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    "Repeat",
                                                    style: TextStyle(
                                                        fontFamily: 'ZillaSlab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Switch(
                                          value: repeat,
                                          onChanged: (value) {
                                            setState(() {
                                              repeat = value;
                                              check_validate();
                                              titleFocus.unfocus();
                                              contentFocus.unfocus();
                                              if (!repeat) {
                                                repeatDays.clear();
                                              } else {
                                                if (timeline == true) {
                                                  repeat = false;
                                                  repeatDays.clear();
                                                }
                                              }
                                            });
                                          },
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IgnorePointer(
                                      ignoring: !repeat,
                                      child: AnimatedOpacity(
                                          opacity: repeat ? 1 : 0,
                                          duration: Duration(milliseconds: 700),
                                          child: (repeat)
                                              ? Container(
                                                  padding: EdgeInsets.only(
                                                      top: 12, bottom: 12),
                                                  height: 60,
                                                  color: Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(.5),
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 16.0,
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: (repeatDays
                                                                    .contains(
                                                                        2))
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            boxShadow: []),
                                                        child: OutlineButton(
                                                            child:
                                                                new Text("MON"),
                                                            onPressed:
                                                                () async {
                                                              check_validate();
                                                              titleFocus
                                                                  .unfocus();
                                                              contentFocus
                                                                  .unfocus();
                                                              print("hello");

                                                              if (repeatDays
                                                                  .contains(2))
                                                                repeatDays
                                                                    .remove(2);
                                                              else {
                                                                if (!allday)
                                                                  repeatDays
                                                                      .add(2);
                                                                else {
                                                                  if (_time ==
                                                                          "Select Start Time" ||
                                                                      currentEvent
                                                                              .duration ==
                                                                          0) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                            content:
                                                                                Text('First select Time and Duration'));
                                                                    globalKey
                                                                        .currentState
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  } else {
                                                                    var fetchedRevents =
                                                                        await NotesDatabaseService
                                                                            .db
                                                                            .getReventsWithFilterDayFromDB(2);

                                                                    int conflict =
                                                                        0;
                                                                    List<ReventModel>
                                                                        day_list =
                                                                        [];
                                                                    day_list =
                                                                        fetchedRevents;
                                                                    for (int i =
                                                                            0;
                                                                        i < day_list.length;
                                                                        i++) {
                                                                      if (currentEvent.date.add(Duration(days: 1)).isAfter(day_list[i]
                                                                              .start_date) &&
                                                                          currentEvent
                                                                              .date
                                                                              .add(Duration(days: 1))
                                                                              .isBefore(day_list[i].end_date)) {
                                                                        var fetchedevent = await NotesDatabaseService
                                                                            .db
                                                                            .getEventOfReventFromDB(day_list[i].id);
                                                                        EventModel
                                                                            eventOfr =
                                                                            fetchedevent;
                                                                        DateTime
                                                                            event_start =
                                                                            eventOfr.time;
                                                                        DateTime
                                                                            event_end =
                                                                            event_start.add(new Duration(minutes: eventOfr.duration.floor()));
                                                                        if (currentEvent.time.isAfter(event_start) &&
                                                                            currentEvent.time.isBefore(event_end)) {
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Selected time is conflicting with ${eventOfr.title}'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);

                                                                          conflict =
                                                                              1;

                                                                          break;
                                                                        }
                                                                        DateTime
                                                                            event_start2 =
                                                                            eventOfr.time;

                                                                        DateTime
                                                                            this_end =
                                                                            time_selected.add(Duration(minutes: currentEvent.duration.floor()));
                                                                        if (event_start2.isAfter(time_selected) &&
                                                                            event_start2.isBefore(this_end)) {
                                                                          final difference = event_start2
                                                                              .difference(time_selected)
                                                                              .inMinutes;
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Duration can be max $difference mins as ${eventOfr.title} event will conflict'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);
                                                                          conflict =
                                                                              1;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    if (conflict ==
                                                                        0)
                                                                      repeatDays
                                                                          .add(
                                                                              2);
                                                                  }
                                                                }
                                                              }

                                                              print(repeatDays);
                                                              setState(() {
                                                                isDirty = true;
                                                              });
                                                            },
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        5.0))),
                                                      ),
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: (repeatDays
                                                                    .contains(
                                                                        3))
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            boxShadow: []),
                                                        child: OutlineButton(
                                                            child:
                                                                new Text("TUE"),
                                                            onPressed:
                                                                () async {
                                                              check_validate();
                                                              titleFocus
                                                                  .unfocus();
                                                              contentFocus
                                                                  .unfocus();
                                                              print("hello");
                                                              if (repeatDays
                                                                  .contains(3))
                                                                repeatDays
                                                                    .remove(3);
                                                              else {
                                                                if (!allday)
                                                                  repeatDays
                                                                      .add(3);
                                                                else {
                                                                  if (_time ==
                                                                          "Select Start Time" ||
                                                                      currentEvent
                                                                              .duration ==
                                                                          0) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                            content:
                                                                                Text('First select Time and Duration'));
                                                                    globalKey
                                                                        .currentState
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  } else {
                                                                    var fetchedRevents =
                                                                        await NotesDatabaseService
                                                                            .db
                                                                            .getReventsWithFilterDayFromDB(3);

                                                                    int conflict =
                                                                        0;
                                                                    List<ReventModel>
                                                                        day_list =
                                                                        [];
                                                                    day_list =
                                                                        fetchedRevents;
                                                                    for (int i =
                                                                            0;
                                                                        i < day_list.length;
                                                                        i++) {
                                                                      if (currentEvent.date.add(Duration(days: 1)).isAfter(day_list[i]
                                                                              .start_date) &&
                                                                          currentEvent
                                                                              .date
                                                                              .add(Duration(days: 1))
                                                                              .isBefore(day_list[i].end_date)) {
                                                                        var fetchedevent = await NotesDatabaseService
                                                                            .db
                                                                            .getEventOfReventFromDB(day_list[i].id);
                                                                        EventModel
                                                                            eventOfr =
                                                                            fetchedevent;
                                                                        DateTime
                                                                            event_start =
                                                                            eventOfr.time;
                                                                        DateTime
                                                                            event_end =
                                                                            event_start.add(new Duration(minutes: eventOfr.duration.floor()));
                                                                        if (currentEvent.time.isAfter(event_start) &&
                                                                            currentEvent.time.isBefore(event_end)) {
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Selected time is conflicting with ${eventOfr.title}'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);

                                                                          conflict =
                                                                              1;

                                                                          break;
                                                                        }
                                                                        DateTime
                                                                            event_start2 =
                                                                            eventOfr.time;

                                                                        DateTime
                                                                            this_end =
                                                                            time_selected.add(Duration(minutes: currentEvent.duration.floor()));
                                                                        if (event_start2.isAfter(time_selected) &&
                                                                            event_start2.isBefore(this_end)) {
                                                                          final difference = event_start2
                                                                              .difference(time_selected)
                                                                              .inMinutes;
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Duration can be max $difference mins as ${eventOfr.title} event will conflict'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);
                                                                          conflict =
                                                                              1;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    if (conflict ==
                                                                        0)
                                                                      repeatDays
                                                                          .add(
                                                                              3);
                                                                  }
                                                                }
                                                              }

                                                              print(repeatDays);
                                                              setState(() {
                                                                isDirty = true;
                                                              });
                                                            },
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        5.0))),
                                                      ),
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: (repeatDays
                                                                    .contains(
                                                                        4))
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            boxShadow: []),
                                                        child: OutlineButton(
                                                            child:
                                                                new Text("WED"),
                                                            onPressed:
                                                                () async {
                                                              check_validate();
                                                              titleFocus
                                                                  .unfocus();
                                                              contentFocus
                                                                  .unfocus();
                                                              print("hello");
                                                              if (repeatDays
                                                                  .contains(4))
                                                                repeatDays
                                                                    .remove(4);
                                                              else {
                                                                if (!allday)
                                                                  repeatDays
                                                                      .add(4);
                                                                else {
                                                                  if (_time ==
                                                                          "Select Start Time" ||
                                                                      currentEvent
                                                                              .duration ==
                                                                          0) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                            content:
                                                                                Text('First select Time and Duration'));
                                                                    globalKey
                                                                        .currentState
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  } else {
                                                                    var fetchedRevents =
                                                                        await NotesDatabaseService
                                                                            .db
                                                                            .getReventsWithFilterDayFromDB(4);

                                                                    int conflict =
                                                                        0;
                                                                    List<ReventModel>
                                                                        day_list =
                                                                        [];
                                                                    day_list =
                                                                        fetchedRevents;
                                                                    for (int i =
                                                                            0;
                                                                        i < day_list.length;
                                                                        i++) {
                                                                      if (currentEvent.date.add(Duration(days: 1)).isAfter(day_list[i]
                                                                              .start_date) &&
                                                                          currentEvent
                                                                              .date
                                                                              .add(Duration(days: 1))
                                                                              .isBefore(day_list[i].end_date)) {
                                                                        var fetchedevent = await NotesDatabaseService
                                                                            .db
                                                                            .getEventOfReventFromDB(day_list[i].id);
                                                                        EventModel
                                                                            eventOfr =
                                                                            fetchedevent;
                                                                        DateTime
                                                                            event_start =
                                                                            eventOfr.time;
                                                                        DateTime
                                                                            event_end =
                                                                            event_start.add(new Duration(minutes: eventOfr.duration.floor()));
                                                                        if (currentEvent.time.isAfter(event_start) &&
                                                                            currentEvent.time.isBefore(event_end)) {
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Selected time is conflicting with ${eventOfr.title}'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);

                                                                          conflict =
                                                                              1;

                                                                          break;
                                                                        }
                                                                        DateTime
                                                                            event_start2 =
                                                                            eventOfr.time;

                                                                        DateTime
                                                                            this_end =
                                                                            time_selected.add(Duration(minutes: currentEvent.duration.floor()));
                                                                        if (event_start2.isAfter(time_selected) &&
                                                                            event_start2.isBefore(this_end)) {
                                                                          final difference = event_start2
                                                                              .difference(time_selected)
                                                                              .inMinutes;
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Duration can be max $difference mins as ${eventOfr.title} event will conflict'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);
                                                                          conflict =
                                                                              1;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    if (conflict ==
                                                                        0)
                                                                      repeatDays
                                                                          .add(
                                                                              4);
                                                                  }
                                                                }
                                                              }

                                                              print(repeatDays);
                                                              setState(() {
                                                                isDirty = true;
                                                              });
                                                            },
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        5.0))),
                                                      ),
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: (repeatDays
                                                                    .contains(
                                                                        5))
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            boxShadow: []),
                                                        child: OutlineButton(
                                                            child:
                                                                new Text("THU"),
                                                            onPressed:
                                                                () async {
                                                              check_validate();
                                                              titleFocus
                                                                  .unfocus();
                                                              contentFocus
                                                                  .unfocus();
                                                              print("hello");
                                                              if (repeatDays
                                                                  .contains(5))
                                                                repeatDays
                                                                    .remove(5);
                                                              else {
                                                                if (!allday)
                                                                  repeatDays
                                                                      .add(5);
                                                                else {
                                                                  if (_time ==
                                                                          "Select Start Time" ||
                                                                      currentEvent
                                                                              .duration ==
                                                                          0) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                            content:
                                                                                Text('First select Time and Duration'));
                                                                    globalKey
                                                                        .currentState
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  } else {
                                                                    var fetchedRevents =
                                                                        await NotesDatabaseService
                                                                            .db
                                                                            .getReventsWithFilterDayFromDB(5);

                                                                    int conflict =
                                                                        0;
                                                                    List<ReventModel>
                                                                        day_list =
                                                                        [];
                                                                    day_list =
                                                                        fetchedRevents;
                                                                    for (int i =
                                                                            0;
                                                                        i < day_list.length;
                                                                        i++) {
                                                                      if (currentEvent.date.add(Duration(days: 1)).isAfter(day_list[i]
                                                                              .start_date) &&
                                                                          currentEvent
                                                                              .date
                                                                              .add(Duration(days: 1))
                                                                              .isBefore(day_list[i].end_date)) {
                                                                        var fetchedevent = await NotesDatabaseService
                                                                            .db
                                                                            .getEventOfReventFromDB(day_list[i].id);
                                                                        EventModel
                                                                            eventOfr =
                                                                            fetchedevent;
                                                                        DateTime
                                                                            event_start =
                                                                            eventOfr.time;
                                                                        DateTime
                                                                            event_end =
                                                                            event_start.add(new Duration(minutes: eventOfr.duration.floor()));
                                                                        if (currentEvent.time.isAfter(event_start) &&
                                                                            currentEvent.time.isBefore(event_end)) {
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Selected time is conflicting with ${eventOfr.title}'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);

                                                                          conflict =
                                                                              1;

                                                                          break;
                                                                        }
                                                                        DateTime
                                                                            event_start2 =
                                                                            eventOfr.time;

                                                                        DateTime
                                                                            this_end =
                                                                            time_selected.add(Duration(minutes: currentEvent.duration.floor()));
                                                                        if (event_start2.isAfter(time_selected) &&
                                                                            event_start2.isBefore(this_end)) {
                                                                          final difference = event_start2
                                                                              .difference(time_selected)
                                                                              .inMinutes;
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Duration can be max $difference mins as ${eventOfr.title} event will conflict'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);
                                                                          conflict =
                                                                              1;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    if (conflict ==
                                                                        0)
                                                                      repeatDays
                                                                          .add(
                                                                              5);
                                                                  }
                                                                }
                                                              }

                                                              print(repeatDays);
                                                              setState(() {
                                                                isDirty = true;
                                                              });
                                                            },
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        5.0))),
                                                      ),
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: (repeatDays
                                                                    .contains(
                                                                        6))
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            boxShadow: []),
                                                        child: OutlineButton(
                                                            child:
                                                                new Text("FRI"),
                                                            onPressed:
                                                                () async {
                                                              check_validate();
                                                              titleFocus
                                                                  .unfocus();
                                                              contentFocus
                                                                  .unfocus();
                                                              print("hello");
                                                              if (repeatDays
                                                                  .contains(6))
                                                                repeatDays
                                                                    .remove(6);
                                                              else {
                                                                if (!allday)
                                                                  repeatDays
                                                                      .add(6);
                                                                else {
                                                                  if (_time ==
                                                                          "Select Start Time" ||
                                                                      currentEvent
                                                                              .duration ==
                                                                          0) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                            content:
                                                                                Text('First select Time and Duration'));
                                                                    globalKey
                                                                        .currentState
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  } else {
                                                                    var fetchedRevents =
                                                                        await NotesDatabaseService
                                                                            .db
                                                                            .getReventsWithFilterDayFromDB(6);

                                                                    int conflict =
                                                                        0;
                                                                    List<ReventModel>
                                                                        day_list =
                                                                        [];
                                                                    day_list =
                                                                        fetchedRevents;
                                                                    for (int i =
                                                                            0;
                                                                        i < day_list.length;
                                                                        i++) {
                                                                      if (currentEvent.date.add(Duration(days: 1)).isAfter(day_list[i]
                                                                              .start_date) &&
                                                                          currentEvent
                                                                              .date
                                                                              .add(Duration(days: 1))
                                                                              .isBefore(day_list[i].end_date)) {
                                                                        var fetchedevent = await NotesDatabaseService
                                                                            .db
                                                                            .getEventOfReventFromDB(day_list[i].id);
                                                                        EventModel
                                                                            eventOfr =
                                                                            fetchedevent;
                                                                        DateTime
                                                                            event_start =
                                                                            eventOfr.time;
                                                                        DateTime
                                                                            event_end =
                                                                            event_start.add(new Duration(minutes: eventOfr.duration.floor()));
                                                                        if (currentEvent.time.isAfter(event_start) &&
                                                                            currentEvent.time.isBefore(event_end)) {
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Selected time is conflicting with ${eventOfr.title}'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);

                                                                          conflict =
                                                                              1;

                                                                          break;
                                                                        }
                                                                        DateTime
                                                                            event_start2 =
                                                                            eventOfr.time;

                                                                        DateTime
                                                                            this_end =
                                                                            time_selected.add(Duration(minutes: currentEvent.duration.floor()));
                                                                        if (event_start2.isAfter(time_selected) &&
                                                                            event_start2.isBefore(this_end)) {
                                                                          final difference = event_start2
                                                                              .difference(time_selected)
                                                                              .inMinutes;
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Duration can be max $difference mins as ${eventOfr.title} event will conflict'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);
                                                                          conflict =
                                                                              1;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    if (conflict ==
                                                                        0)
                                                                      repeatDays
                                                                          .add(
                                                                              6);
                                                                  }
                                                                }
                                                              }

                                                              print(repeatDays);
                                                              setState(() {
                                                                isDirty = true;
                                                              });
                                                            },
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        5.0))),
                                                      ),
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: (repeatDays
                                                                    .contains(
                                                                        7))
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            boxShadow: []),
                                                        child: OutlineButton(
                                                            child:
                                                                new Text("SAT"),
                                                            onPressed:
                                                                () async {
                                                              check_validate();
                                                              titleFocus
                                                                  .unfocus();
                                                              contentFocus
                                                                  .unfocus();
                                                              print("hello");
                                                              if (repeatDays
                                                                  .contains(7))
                                                                repeatDays
                                                                    .remove(7);
                                                              else {
                                                                if (!allday)
                                                                  repeatDays
                                                                      .add(7);
                                                                else {
                                                                  if (_time ==
                                                                          "Select Start Time" ||
                                                                      currentEvent
                                                                              .duration ==
                                                                          0) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                            content:
                                                                                Text('First select Time and Duration'));
                                                                    globalKey
                                                                        .currentState
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  } else {
                                                                    var fetchedRevents =
                                                                        await NotesDatabaseService
                                                                            .db
                                                                            .getReventsWithFilterDayFromDB(7);

                                                                    int conflict =
                                                                        0;
                                                                    List<ReventModel>
                                                                        day_list =
                                                                        [];
                                                                    day_list =
                                                                        fetchedRevents;
                                                                    for (int i =
                                                                            0;
                                                                        i < day_list.length;
                                                                        i++) {
                                                                      if (currentEvent.date.add(Duration(days: 1)).isAfter(day_list[i]
                                                                              .start_date) &&
                                                                          currentEvent
                                                                              .date
                                                                              .add(Duration(days: 1))
                                                                              .isBefore(day_list[i].end_date)) {
                                                                        var fetchedevent = await NotesDatabaseService
                                                                            .db
                                                                            .getEventOfReventFromDB(day_list[i].id);
                                                                        EventModel
                                                                            eventOfr =
                                                                            fetchedevent;
                                                                        DateTime
                                                                            event_start =
                                                                            eventOfr.time;
                                                                        DateTime
                                                                            event_end =
                                                                            event_start.add(new Duration(minutes: eventOfr.duration.floor()));
                                                                        if (currentEvent.time.isAfter(event_start) &&
                                                                            currentEvent.time.isBefore(event_end)) {
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Selected time is conflicting with ${eventOfr.title}'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);

                                                                          conflict =
                                                                              1;

                                                                          break;
                                                                        }
                                                                        DateTime
                                                                            event_start2 =
                                                                            eventOfr.time;

                                                                        DateTime
                                                                            this_end =
                                                                            time_selected.add(Duration(minutes: currentEvent.duration.floor()));
                                                                        if (event_start2.isAfter(time_selected) &&
                                                                            event_start2.isBefore(this_end)) {
                                                                          final difference = event_start2
                                                                              .difference(time_selected)
                                                                              .inMinutes;
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Duration can be max $difference mins as ${eventOfr.title} event will conflict'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);
                                                                          conflict =
                                                                              1;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    if (conflict ==
                                                                        0)
                                                                      repeatDays
                                                                          .add(
                                                                              7);
                                                                  }
                                                                }
                                                              }

                                                              print(repeatDays);
                                                              setState(() {
                                                                isDirty = true;
                                                              });
                                                            },
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        5.0))),
                                                      ),
                                                      SizedBox(
                                                        width: 8.0,
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: (repeatDays
                                                                    .contains(
                                                                        1))
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            boxShadow: []),
                                                        child: OutlineButton(
                                                            child:
                                                                new Text("SUN"),
                                                            onPressed:
                                                                () async {
                                                              check_validate();
                                                              titleFocus
                                                                  .unfocus();
                                                              contentFocus
                                                                  .unfocus();
                                                              print("hello");
                                                              if (repeatDays
                                                                  .contains(1))
                                                                repeatDays
                                                                    .remove(1);
                                                              else {
                                                                if (!allday)
                                                                  repeatDays
                                                                      .add(1);
                                                                else {
                                                                  if (_time ==
                                                                          "Select Start Time" ||
                                                                      currentEvent
                                                                              .duration ==
                                                                          0) {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                            content:
                                                                                Text('First select Time and Duration'));
                                                                    globalKey
                                                                        .currentState
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  } else {
                                                                    var fetchedRevents =
                                                                        await NotesDatabaseService
                                                                            .db
                                                                            .getReventsWithFilterDayFromDB(1);

                                                                    int conflict =
                                                                        0;
                                                                    List<ReventModel>
                                                                        day_list =
                                                                        [];
                                                                    day_list =
                                                                        fetchedRevents;
                                                                    for (int i =
                                                                            0;
                                                                        i < day_list.length;
                                                                        i++) {
                                                                      if (currentEvent.date.add(Duration(days: 1)).isAfter(day_list[i]
                                                                              .start_date) &&
                                                                          currentEvent
                                                                              .date
                                                                              .add(Duration(days: 1))
                                                                              .isBefore(day_list[i].end_date)) {
                                                                        var fetchedevent = await NotesDatabaseService
                                                                            .db
                                                                            .getEventOfReventFromDB(day_list[i].id);
                                                                        EventModel
                                                                            eventOfr =
                                                                            fetchedevent;
                                                                        DateTime
                                                                            event_start =
                                                                            eventOfr.time;
                                                                        DateTime
                                                                            event_end =
                                                                            event_start.add(new Duration(minutes: eventOfr.duration.floor()));
                                                                        if (currentEvent.time.isAfter(event_start) &&
                                                                            currentEvent.time.isBefore(event_end)) {
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Selected time is conflicting with ${eventOfr.title}'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);

                                                                          conflict =
                                                                              1;

                                                                          break;
                                                                        }
                                                                        DateTime
                                                                            event_start2 =
                                                                            eventOfr.time;

                                                                        DateTime
                                                                            this_end =
                                                                            time_selected.add(Duration(minutes: currentEvent.duration.floor()));
                                                                        if (event_start2.isAfter(time_selected) &&
                                                                            event_start2.isBefore(this_end)) {
                                                                          final difference = event_start2
                                                                              .difference(time_selected)
                                                                              .inMinutes;
                                                                          // do something;

                                                                          final snackBar =
                                                                              SnackBar(content: Text('Duration can be max $difference mins as ${eventOfr.title} event will conflict'));
                                                                          globalKey
                                                                              .currentState
                                                                              .showSnackBar(snackBar);
                                                                          conflict =
                                                                              1;
                                                                          break;
                                                                        }
                                                                      }
                                                                    }

                                                                    if (conflict ==
                                                                        0)
                                                                      repeatDays
                                                                          .add(
                                                                              1);
                                                                  }
                                                                }
                                                              }

                                                              print(repeatDays);
                                                              setState(() {
                                                                isDirty = true;
                                                              });
                                                            },
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        5.0))),
                                                      ),
                                                      SizedBox(
                                                        width: 16.0,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                ))),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 0, bottom: 0),
                                    height: 60.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.timeline,
                                                    size: 18.0,
                                                  ),
                                                  Container(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    "Add to Timeline",
                                                    style: TextStyle(
                                                        fontFamily: 'ZillaSlab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Switch(
                                          value: timeline,
                                          onChanged: (value) {
                                            setState(() {
                                              timeline = value;
                                              check_validate();
                                              titleFocus.unfocus();
                                              contentFocus.unfocus();

                                              if (timeline) {
                                                if (repeat) {
                                                  final snackBar = SnackBar(
                                                      content: Text(
                                                          'Cannot add to Timeline as this is a repeated event.'));
                                                  globalKey.currentState
                                                      .showSnackBar(snackBar);
                                                  setState(() {
                                                    timeline = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    open_timeline = true;
                                                  });

                                                  _timer = Timer.periodic(
                                                      Duration(seconds: 8),
                                                      (Timer timer) {
                                                    if (_currentPage < 2) {
                                                      _currentPage++;
                                                    } else {
                                                      _currentPage = 0;
                                                    }

                                                    _pageController
                                                        .animateToPage(
                                                      _currentPage,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeIn,
                                                    );
                                                  });
                                                }
                                              } else {
                                                currentEvent.timeline_id = 0;
                                              }

                                              align_value = 130;
                                            });
                                          },
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!open_timeline && timeline)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 0, left: 30, right: 30),
                                      child: FadeAnimation(
                                          0.6,
                                          Container(
                                              padding: EdgeInsets.only(
                                                  left: 12,
                                                  right: 12,
                                                  top: 4,
                                                  bottom: 4),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(16.0)),
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      const Color(0xFF00c6ff),
                                                      Theme.of(context)
                                                          .primaryColor,
                                                    ],
                                                    begin:
                                                        const FractionalOffset(
                                                            0.0, 0.0),
                                                    end: const FractionalOffset(
                                                        1.0, 1.00),
                                                    stops: [0.0, 1.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Text(
                                                timeline_name,
                                                style: TextStyle(
                                                    fontFamily: 'ZillaSlab',
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white70),
                                              ))),
                                    ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 0, bottom: 0),
                                    height: 60.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.toc,
                                                    size: 18.0,
                                                  ),
                                                  Container(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    "Todo List",
                                                    style: TextStyle(
                                                        fontFamily: 'ZillaSlab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Switch(
                                          value: isSwitched,
                                          onChanged: (value) {
                                            setState(() {
                                              isSwitched = value;
                                              titleFocus.unfocus();
                                              contentFocus.unfocus();
                                              if (isSwitched &&
                                                  currentEvent.todo_id == 0) {
                                                final _random = new Random();

                                                int next(int min, int max) =>
                                                    min +
                                                    _random.nextInt(max - min);
                                                currentEvent.todo_id =
                                                    next(1, 99999999);
                                                todoBloc = TodoBloc(
                                                    currentEvent.todo_id);
                                              }
                                            });
                                          },
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSwitched)
                                    Container(
                                        padding: EdgeInsets.only(bottom: 100),
                                        height: 400,
                                        //This is where the magic starts
                                        child: getTodosWidget())
                                ],
                              )
                            : SizedBox(
                                height: 0,
                              ))),
                AnimatedContainer(
                    height: align_value,
                    padding: (EdgeInsets.only(top: 10, left: 20)),
                    width: MediaQuery.of(context).size.width,
                    duration: Duration(milliseconds: 800),
                    curve: Curves.decelerate,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IgnorePointer(
                              ignoring: !open_timeline,
                              child: AnimatedOpacity(
                                  opacity: open_timeline ? 1 : 0,
                                  duration: Duration(milliseconds: 300),
                                  child: (open_timeline)
                                      ? Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.timeline,
                                                          size: 24.0,
                                                        ),
                                                        Container(
                                                          width: 16,
                                                        ),
                                                        Text(
                                                          "Add to Timeline",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'ZillaSlab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 26.0),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ])
                                      : SizedBox(
                                          height: 0,
                                        )))
                        ])),
                IgnorePointer(
                    ignoring: !open_timeline,
                    child: AnimatedOpacity(
                        opacity: open_timeline ? 1 : 0,
                        duration: Duration(milliseconds: 1000),
                        child: (open_timeline)
                            ? GestureDetector(
                                onTap: () {
                                  _NewTimelineBottomSheet(context);
                                },
                                child: Container(
                                  height: 60,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(20.0)),
                                    gradient: new LinearGradient(
                                        colors: [
                                          const Color(0xFF00c6ff),
                                          Theme.of(context).primaryColor,
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 1.00),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 150, left: 20, right: 20),
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.add_circle,
                                          size: 24.0,
                                        ),
                                        Container(
                                          width: 16,
                                        ),
                                        Text(
                                          "New Timeline",
                                          style: TextStyle(
                                              fontFamily: 'ZillaSlab',
                                              fontSize: 22.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            : SizedBox(
                                height: 0,
                              ))),
                IgnorePointer(
                    ignoring: !open_timeline,
                    child: AnimatedOpacity(
                        opacity: open_timeline ? 1 : 0,
                        duration: Duration(milliseconds: 1000),
                        child: Container(
                            decoration: new BoxDecoration(
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(20.0)),
                              gradient: new LinearGradient(
                                  colors: [
                                    const Color(0xFF00c6ff),
                                    Theme.of(context).primaryColor,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 1.00),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            margin: EdgeInsets.only(
                                top: 220, left: 20, right: 20, bottom: 20),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: (open_timeline)
                                ? MediaQuery.removePadding(
                                    removeTop: true,
                                    context: context,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: all_timelines.length + 2,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0)
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  top: 16,
                                                  bottom: 12),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Select from previous Timelines",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'ZillaSlab',
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            );
                                          if (index ==
                                              all_timelines.length + 1) {
                                            return AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5.0),
                                              height: 280,
                                              curve: Curves.easeInOut,
                                              decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(0, 8),
                                                        color: Colors.black
                                                            .withAlpha(20),
                                                        blurRadius: 16)
                                                  ]),
                                              child: Stack(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0, top: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Icon(
                                                        Icons.timeline,
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.15),
                                                        size: 300,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 8,
                                                        right: 10),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: PageView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          controller:
                                                              _pageController,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                0),
                                                                    child: FadeAnimation(
                                                                        0.6,
                                                                        Container(
                                                                            padding: EdgeInsets.only(left: 12, right: 12),
                                                                            decoration: new BoxDecoration(
                                                                              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
                                                                              gradient: new LinearGradient(
                                                                                  colors: [
                                                                                    const Color(0xFF00c6ff),
                                                                                    Theme.of(context).primaryColor,
                                                                                  ],
                                                                                  begin: const FractionalOffset(0.0, 0.0),
                                                                                  end: const FractionalOffset(1.0, 1.00),
                                                                                  stops: [0.0, 1.0],
                                                                                  tileMode: TileMode.clamp),
                                                                            ),
                                                                            child: Text(
                                                                              'So what is Timeline ?',
                                                                              style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white70),
                                                                            ))),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                40),
                                                                    child: FadeAnimation(
                                                                        1.2,
                                                                        Container(
                                                                            padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 12),
                                                                            decoration: new BoxDecoration(
                                                                              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
                                                                              gradient: new LinearGradient(
                                                                                  colors: [
                                                                                    const Color(0xFF00c6ff),
                                                                                    Theme.of(context).primaryColor,
                                                                                  ],
                                                                                  begin: const FractionalOffset(0.0, 0.0),
                                                                                  end: const FractionalOffset(1.0, 1.00),
                                                                                  stops: [0.0, 1.0],
                                                                                  tileMode: TileMode.clamp),
                                                                            ),
                                                                            child: RichText(
                                                                              text: TextSpan(
                                                                                text: 'Provides a visual representation of events that helps you better understand',
                                                                                style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 19, fontWeight: FontWeight.w400, color: Colors.black45),
                                                                                children: <TextSpan>[
                                                                                  TextSpan(text: ' history', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                  TextSpan(
                                                                                    text: ', a ',
                                                                                  ),
                                                                                  TextSpan(text: 'story', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                  TextSpan(
                                                                                    text: ', a ',
                                                                                  ),
                                                                                  TextSpan(text: 'process', style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                  TextSpan(text: '  or any other form of an event sequence arranged in chronological order and displayed along a line '),
                                                                                ],
                                                                              ),
                                                                            ))),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                0),
                                                                    child: FadeAnimation(
                                                                        1.2,
                                                                        Container(
                                                                            padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                                                                            decoration: new BoxDecoration(
                                                                              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
                                                                              gradient: new LinearGradient(
                                                                                  colors: [
                                                                                    const Color(0xFF00c6ff),
                                                                                    Theme.of(context).primaryColor,
                                                                                  ],
                                                                                  begin: const FractionalOffset(0.0, 0.0),
                                                                                  end: const FractionalOffset(1.0, 1.00),
                                                                                  stops: [0.0, 1.0],
                                                                                  tileMode: TileMode.clamp),
                                                                            ),
                                                                            child: RichText(
                                                                              text: TextSpan(
                                                                                text: 'Project Management',
                                                                                style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black45),
                                                                                children: <TextSpan>[
                                                                                  TextSpan(text: '\nProcess Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                  TextSpan(text: '\nCompletion Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                ],
                                                                              ),
                                                                            ))),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 80,
                                                                        left:
                                                                            00),
                                                                    child: FadeAnimation(
                                                                        1.2,
                                                                        Container(
                                                                            padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                                                                            decoration: new BoxDecoration(
                                                                              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
                                                                              gradient: new LinearGradient(
                                                                                  colors: [
                                                                                    const Color(0xFF00c6ff),
                                                                                    Theme.of(context).primaryColor,
                                                                                  ],
                                                                                  begin: const FractionalOffset(0.0, 0.0),
                                                                                  end: const FractionalOffset(1.0, 1.00),
                                                                                  stops: [0.0, 1.0],
                                                                                  tileMode: TileMode.clamp),
                                                                            ),
                                                                            child: RichText(
                                                                              text: TextSpan(
                                                                                text: 'Self-Life Tracking',
                                                                                style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black45),
                                                                                children: <TextSpan>[
                                                                                  TextSpan(text: '\nLife success Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                  TextSpan(text: '\nHealth/Fitness Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                ],
                                                                              ),
                                                                            ))),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top:
                                                                            160,
                                                                        left:
                                                                            0),
                                                                    child: FadeAnimation(
                                                                        1.2,
                                                                        Container(
                                                                            padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                                                                            decoration: new BoxDecoration(
                                                                              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
                                                                              gradient: new LinearGradient(
                                                                                  colors: [
                                                                                    const Color(0xFF00c6ff),
                                                                                    Theme.of(context).primaryColor,
                                                                                  ],
                                                                                  begin: const FractionalOffset(0.0, 0.0),
                                                                                  end: const FractionalOffset(1.0, 1.00),
                                                                                  stops: [0.0, 1.0],
                                                                                  tileMode: TileMode.clamp),
                                                                            ),
                                                                            child: RichText(
                                                                              text: TextSpan(
                                                                                text: 'Studies Track',
                                                                                style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black45),
                                                                                children: <TextSpan>[
                                                                                  TextSpan(text: '\nProgress Report Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                  TextSpan(text: '\nSyllabus Completion Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                                                ],
                                                                              ),
                                                                            ))),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0.0),
                                                              child: Stack(
                                                                children: <
                                                                    Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                50),
                                                                    child:
                                                                        FadeAnimation(
                                                                      1.6,
                                                                      Container(
                                                                        child:
                                                                            Image(
                                                                          image:
                                                                              AssetImage(
                                                                            'assets/images/timeline.png',
                                                                          ),
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: 5,
                                                                        left:
                                                                            10),
                                                                    child: FadeAnimation(
                                                                        0.6,
                                                                        Container(
                                                                            padding: EdgeInsets.only(left: 12, right: 12),
                                                                            decoration: new BoxDecoration(
                                                                              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
                                                                              gradient: new LinearGradient(
                                                                                  colors: [
                                                                                    const Color(0xFF00c6ff),
                                                                                    Theme.of(context).primaryColor,
                                                                                  ],
                                                                                  begin: const FractionalOffset(0.0, 0.0),
                                                                                  end: const FractionalOffset(1.0, 1.00),
                                                                                  stops: [0.0, 1.0],
                                                                                  tileMode: TileMode.clamp),
                                                                            ),
                                                                            child: Text(
                                                                              'Representation',
                                                                              style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white70),
                                                                            ))),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return _buildTimelineCard(index - 1,
                                              all_timelines[index - 1]);
                                        }))
                                : SizedBox(
                                    height: 0,
                                  )))),
                ClipRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: 80,
                        color: Theme.of(context).canvasColor.withOpacity(0.1),
                        child: SafeArea(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: handleBack,
                              ),
                              Spacer(),
                              IconButton(
                                tooltip: 'Mark note as important',
                                icon: Icon(currentEvent.isImportant
                                    ? Icons.alarm_on
                                    : Icons.alarm_add),
                                onPressed: titleController.text
                                            .trim()
                                            .isNotEmpty &&
                                        contentController.text.trim().isNotEmpty
                                    ? markImportantAsDirty
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: () {
                                  handleDelete();
                                },
                              ),
                              AnimatedContainer(
                                margin: EdgeInsets.only(left: 10),
                                duration: Duration(milliseconds: 50),
                                width: isDirty && validator ? 160 : 0,
                                height: 42,
                                curve: Curves.decelerate,
                                child: RaisedButton.icon(
                                  color: Theme.of(context).accentColor,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(100),
                                          bottomLeft: Radius.circular(100))),
                                  icon: Icon(Icons.done),
                                  label: Text(
                                    'SAVE',
                                    style: TextStyle(letterSpacing: 1),
                                  ),
                                  onPressed: handleSave,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                )
              ],
            )));
  }

  void handleSave() async {
    bool initial = (currentEvent.r_id == 0);
    ReventModel newRevent;
    currentEvent.date_id = this_date.id;
    if (!isSwitched) {
      for (var i = 0; i < Todos.length; i++) {
        todoBloc.deleteTodoById(Todos[i], currentEvent.todo_id);
      }
    }
    if (currentEvent.r_id != 0) {
      if (repeatDays.length == 0) {
        await NotesDatabaseService.db.deleteReventInDB(currentRevent);
        currentEvent.r_id = 0;
      } else {
        currentRevent.sun = 0;
        currentRevent.mon = 0;
        currentRevent.tue = 0;
        currentRevent.wed = 0;
        currentRevent.thu = 0;
        currentRevent.fri = 0;
        currentRevent.sat = 0;

        if (repeatDays.contains(1)) currentRevent.sun = 1;
        if (repeatDays.contains(2)) currentRevent.mon = 1;
        if (repeatDays.contains(3)) currentRevent.tue = 1;
        if (repeatDays.contains(4)) currentRevent.wed = 1;
        if (repeatDays.contains(5)) currentRevent.thu = 1;
        if (repeatDays.contains(6)) currentRevent.fri = 1;
        if (repeatDays.contains(7)) currentRevent.sat = 1;
        await NotesDatabaseService.db.updateReventInDB(currentRevent);
      }
    } else {
      if (repeatDays.length > 0) {
        newRevent = new ReventModel(
            start_date: DateTime.now().add(Duration(days: 1)),
            event_id: 0,
            end_date: DateTime.now().add(Duration(days: 365)));
        if (repeatDays.contains(1))
          newRevent.sun = 1;
        else
          newRevent.sun = 0;
        if (repeatDays.contains(2))
          newRevent.mon = 1;
        else
          newRevent.mon = 0;
        if (repeatDays.contains(3))
          newRevent.tue = 1;
        else
          newRevent.tue = 0;
        if (repeatDays.contains(4))
          newRevent.wed = 1;
        else
          newRevent.wed = 0;
        if (repeatDays.contains(5))
          newRevent.thu = 1;
        else
          newRevent.thu = 0;
        if (repeatDays.contains(6))
          newRevent.fri = 1;
        else
          newRevent.fri = 0;

        if (repeatDays.contains(7))
          newRevent.sat = 1;
        else
          newRevent.sat = 0;

        newRevent = await NotesDatabaseService.db.addReventInDB(newRevent);
        print("Revent Id :" + newRevent.id.toString());
        currentEvent.r_id = newRevent.id;
      }
    }
    setState(() {
      currentEvent.title = titleController.text;
      currentEvent.content = contentController.text;
      print('Hey there ${currentEvent.content}');
    });
    if (isNoteNew) {
      var latestNote = await NotesDatabaseService.db.addEventInDB(currentEvent);
      setState(() {
        currentEvent = latestNote;
      });
      if (currentEvent.r_id != 0) {
        newRevent.event_id = currentEvent.id;
        await NotesDatabaseService.db.updateReventInDB(newRevent);
      }
    } else {
      if (initial && currentEvent.r_id != 0) {
        newRevent.event_id = currentEvent.id;
        await NotesDatabaseService.db.updateReventInDB(newRevent);
      }
      await NotesDatabaseService.db.updateEventInDB(currentEvent);
    }
    setState(() {
      isNoteNew = false;
      isDirty = false;
    });

    widget.triggerRefetch();
    titleFocus.unfocus();
    contentFocus.unfocus();
    Navigator.pop(context);
  }

  void markTitleAsDirty(String title) {
    setState(() {
      isDirty = true;
    });
  }

  void markContentAsDirty(String content) {
    setState(() {
      isDirty = true;
    });
  }

  void markImportantAsDirty() {
    setState(() {
      currentEvent.isImportant = !currentEvent.isImportant;
      isDirty = true;
    });
  }

  void handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
      for (var i = 0; i < Todos.length; i++) {
        todoBloc.deleteTodoById(Todos[i], currentEvent.todo_id);
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Delete Note'),
              content: Text('This note will be deleted permanently'),
              actions: <Widget>[
                FlatButton(
                  child: Text('DELETE',
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                    for (var i = 0; i < Todos.length; i++) {
                      todoBloc.deleteTodoById(Todos[i], currentEvent.todo_id);
                    }

                    if (currentEvent.r_id != 0) {
                      await NotesDatabaseService.db
                          .deleteReventInDB(currentRevent);
                      currentEvent.r_id = 0;
                    }

                    await NotesDatabaseService.db.deleteEventInDB(currentEvent);
                    widget.triggerRefetch();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('CANCEL',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  void handleBack() {
    if (open_timeline == true && timeline) {
      setState(() {
        open_timeline = false;

        _timer.cancel();
        timeline = false;
        currentEvent.timeline_id = 0;
      });
      return;
    }
    if (isNoteNew)
      for (var i = 0; i < Todos.length; i++) {
        todoBloc.deleteTodoById(Todos[i], currentEvent.todo_id);
      }

    widget.triggerRefetch();

    Navigator.pop(context);
  }

  Widget _getFAB() {
    if (!isSwitched) {
      return Container();
    } else {
      return FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5.0,
        onPressed: () {
          _showAddTodoSheet(context);
        },
        label: Text(
          'Add Todo'.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.add),
      );
    }
  }

  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, top: 100),
            child: new Container(
              child: new Container(
                decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.8),
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: _todoDescriptionFormController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (text) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                              final newTodo = Todo(
                                  description: _todoDescriptionFormController
                                      .value.text);
                              if (newTodo.description.isNotEmpty) {
                                /*Create new Todo object and make sure
                                    the Todo description is not empty,
                                    because what's the point of saving empty
                                    Todo
                                    */
                                newTodo.event_id = currentEvent.todo_id;
                                todoBloc.addTodo(newTodo, currentEvent.todo_id);

                                //dismisses the bottomsheet
                                Navigator.pop(context);
                              }
                            },
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'ZillaSlab',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 24),
                            decoration: const InputDecoration(
                                hintText: 'I have to...',
                                labelText: 'New Todo',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 24)),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Empty description!';
                              }
                              return value.contains('')
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newTodo = Todo(
                                      description:
                                          _todoDescriptionFormController
                                              .value.text);
                                  if (newTodo.description.isNotEmpty) {
                                    /*Create new Todo object and make sure
                                    the Todo description is not empty,
                                    because what's the point of saving empty
                                    Todo
                                    */
                                    newTodo.event_id = currentEvent.todo_id;
                                    todoBloc.addTodo(
                                        newTodo, currentEvent.todo_id);
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 300),
                                    );
                                    //dismisses the bottomsheet
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getTodosWidget() {
    /*The StreamBuilder widget,
    basically this widget will take stream of data (todos)
    and construct the UI (with state) based on the stream
    */

    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    /*Since most of our operations are asynchronous
    at initial state of the operation there will be no stream
    so we need to handle it if this was the case
    by showing users a processing/loading indicator*/
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Todo from DB.
      If that the case show user that you have empty Todos
      */

      return snapshot.data.length != 0
          ? ListView.builder(
              padding: EdgeInsets.only(left: 16, right: 16),
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Todo todo = snapshot.data[itemPosition];
                Todos.add(todo.id);
                final Widget dismissibleCard = new Dismissible(
                  background: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red[500],
                        ),
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Deleting",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                    todoBloc.deleteTodoById(todo.id, currentEvent.todo_id);
                    Todos.remove(todo.id);
                  },
                  direction: _dismissDirection,
                  key: new ObjectKey(todo),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListTile(
                        onLongPress: () {
                          setState(() {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Swipe to delete"),
                            ));
                          });
                        },
                        onTap: () {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Swipe to delete"),
                          ));
                        },
                        leading: InkWell(
                          onTap: () {
                            //Reverse the value
                            todo.isDone = !todo.isDone;
                            /*
                            Another magic.
                            This will update Todo isDone with either
                            completed or not
                          */
                            todoBloc.updateTodo(todo, currentEvent.todo_id);
                          },
                          child: Container(
                            //decoration: BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: todo.isDone
                                  ? Icon(
                                      Icons.done,
                                      size: 26.0,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 26.0,
                                    ),
                            ),
                          ),
                        ),
                        title: Text(
                          todo.description,
                          style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      )),
                );
                return dismissibleCard;
              },
            )
          : Container(
              padding: EdgeInsets.only(top: 24, left: 16, right: 16),
              alignment: Alignment.topCenter,

              //this is used whenever there 0 Todo
              //in the data base
              child: noTodoMessageWidget(),
            );
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  check_validate() {
    if (titleController.text != "" &&
        activity_position != -1 &&
        currentEvent.date_id != 0 &&
        currentEvent.date != null) {
      print("heee" + currentEvent.date_id.toString());
      print(currentEvent.date);
      validator = true;
      if (allday && currentEvent.duration == 0) validator = false;
    }
  }

  Widget loadingData() {
    //pull todos again
    todoBloc.getTodos(currentEvent.todo_id);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700))
          ],
        ),
      ),
    );
  }

  Widget noTodoMessageWidget() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
    return Container(
      child: Text(
        "Start adding Todo...",
        style: TextStyle(
            fontSize: 19, fontFamily: 'ZillaSlab', fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildCategoryCard2(int index, UserAModel this_note) {
    String count = "";
    String image = 'assets/images/' + this_note.image + '.jpg';

    return GestureDetector(
      onTap: () {
        setState(() {
          titleFocus.unfocus();
          contentFocus.unfocus();
          activity_position = index;
          currentEvent.a_id = activity_position + 1;
          check_validate();
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5.0),
        height: 60,
        width: 80,
        decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFF00c6ff),
                  Theme.of(context).primaryColor,
                ],
                begin: const FractionalOffset(1.0, 1.0),
                end: const FractionalOffset(0.0, 0.00),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 8),
                  color: Colors.black.withAlpha(20),
                  blurRadius: 16)
            ]),
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover))),
            if (activity_position != index)
              Padding(
                padding: EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    this_note.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ZillaSlab',
                        fontSize: 14,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 4.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 2),
                          ),
                        ],
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            if (activity_position == index)
              Padding(
                padding: EdgeInsets.only(),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_circle,
                    size: 50,
                    color: Theme.of(context).primaryColor.withOpacity(.8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(int index, TimelineModel this_note) {
    String count = "";
    String status = "Ongoing";
    if (this_note.status == 1) {
      status = "Ongoing";
    } else if (this_note.status == 2) {
      status = "Paused";
    } else if (this_note.status == 3) {
      status = "Completed";
    }

    var formatter = new DateFormat('d MMM yyyy');
    String formatted = formatter.format(this_note.date);
    return GestureDetector(
      onTap: () {
        setState(() {
          titleFocus.unfocus();
          contentFocus.unfocus();
          currentEvent.timeline_id = this_note.id;
          timeline_name = this_note.title;
          _timer.cancel();
          open_timeline = false;

          print("tapped");
          check_validate();
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5.0),
        height: timeline_card_h,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 8),
                  color: Colors.black.withAlpha(20),
                  blurRadius: 16)
            ]),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0, top: 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.timeline,
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  size: 200,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  this_note.title,
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  iconSize: 25,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: icon_controller,
                  ),
                  onPressed: () => _onpressed(),
                ),
              ),
            ),
            if (isPlaying)
              Padding(
                padding: EdgeInsets.only(left: 20, top: 45),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Status: " + status,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            if (isPlaying)
              Padding(
                padding: EdgeInsets.only(left: 50, top: 45),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.repeat,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            if (isPlaying)
              Padding(
                padding: EdgeInsets.only(left: 20, top: 75),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Start date: " + formatted,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _onpressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? icon_controller.forward() : icon_controller.reverse();

      if (isPlaying) {
        setState(() {
          timeline_card_h = 110;
        });
      } else {
        setState(() {
          timeline_card_h = 50;
        });
      }
    });
  }

  Future myLoadAsset(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (_) {
      return null;
    }
  }

  void _NewTimelineBottomSheet(context) {
    TimelineModel new_timeline =
        new TimelineModel(title: "", date: DateTime.now(), status: 1);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  height: 230,
                  margin:
                      EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 50),
                  alignment: Alignment.topCenter,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(20.0)),
                    gradient: new LinearGradient(
                        colors: [
                          const Color(0xFF00c6ff),
                          Theme.of(context).primaryColor,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.00),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Column(
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 0, left: 20, right: 20, top: 10),
                            child: TextField(
                              focusNode: TimelineNameFocus,
                              controller: TimelineName,
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              maxLength: 20,
                              onSubmitted: (text) async {
                                TimelineNameFocus.unfocus();
                                new_timeline.title = TimelineName.text;
                              },
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 24,
                                color: Colors.white60,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type timeline name',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'ZillaSlab',
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: 0, left: 30, top: 10),
                            child: TextField(
                              focusNode: TimelineContentFocus,
                              controller: TimelineContent,
                              keyboardType: TextInputType.multiline,
                              maxLines: 2,
                              onSubmitted: (text) async {
                                new_timeline.content = TimelineContent.text;
                                new_timeline.title = TimelineName.text;

                                new_timeline = await NotesDatabaseService.db
                                    .addTimelineInDB(new_timeline);

                                currentEvent.timeline_id = new_timeline.id;
                                timeline_name = new_timeline.title;
                                TimelineNameFocus.unfocus();
                                TimelineContent.clear();
                                TimelineName.clear();
                                setState(() {
                                  _timer.cancel();
                                  open_timeline = false;
                                });
                                Navigator.pop(context);
                              },
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 20,
                                color: Colors.black45,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: 'add a discription if needed',
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 20,
                                  fontFamily: 'ZillaSlab',
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ButtonBar(
                                // this will take space as minimum as posible(to center)
                                children: <Widget>[
                                  new RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0)),
                                    child: new Text(
                                      'Add',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'ZillaSlab',
                                      ),
                                    ),
                                    onPressed: () async {
                                      new_timeline.content =
                                          TimelineContent.text;
                                      new_timeline.title = TimelineName.text;
                                      new_timeline = await NotesDatabaseService
                                          .db
                                          .addTimelineInDB(new_timeline);
                                      print(
                                          "mian " + new_timeline.id.toString());

                                      currentEvent.timeline_id =
                                          new_timeline.id;
                                      timeline_name = new_timeline.title;

                                      TimelineNameFocus.unfocus();
                                      TimelineContent.clear();
                                      TimelineName.clear();

                                      setState(() {
                                        get_TimelinesModel();
                                        _timer.cancel();
                                        open_timeline = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  new RaisedButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0)),
                                      child: new Text('Cancel',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'ZillaSlab',
                                          )),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )));
        });
  }
}
