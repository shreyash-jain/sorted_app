import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:notes/bloc/todo_bloc.dart';
import 'package:notes/components/QuestionCards.dart';
import 'package:notes/data/custom_slider_thumb_circle.dart';
import 'package:notes/components/SecondPage.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/event.dart';
import 'package:notes/data/activity.dart';
import 'package:notes/data/rEvent.dart';
import 'package:notes/data/user_activity.dart';
import 'package:notes/data/activityLog.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/data/todo.dart';
import 'package:notes/data/animated-wave.dart';
import 'package:notes/data/animated-background.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/ListQuestion.dart';
import 'package:notes/screens/Survey_start.dart';
import 'package:notes/screens/addEvent.dart';
import 'package:notes/screens/EventView.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/edit.dart';
import 'package:notes/screens/richedit.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'package:notes/services/local_notications_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/cards.dart';
import '../components/FadeAnimation.dart';
import '../components/BluePainter.dart';

class MyHomePage extends StatefulWidget {
  Function(Brightness brightness) changeTheme;

  MyHomePage({Key key, this.title, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isFlagOn = false;
  bool headerShouldHide = false;

  ThemeData theme = appThemeLight;
  List<NotesModel> notesList = [];
  List<NoteBookModel> notebookList = [];
  SharedPreferences prefs;
  List<IconData> iconsList = [
    Icons.add,
    Icons.archive,
    Icons.done,
    Icons.rate_review,
    Icons.description
  ];
  List<String> below_texs = ["one", "two", "three", "four", "five"];
  List<EventModel> eventsList = [];
  List<EventModel> eventsListtoday = [];
  List<EventModel> eventsListtom = [];
  TodoBloc todoBloc;

  HashMap hashMap_today = new HashMap<int, List<Todo>>();
  HashMap hashMap_tom = new HashMap<int, List<Todo>>();
  TextEditingController searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  int _selectedCategoryIndex2 = 0;
  TabController _tabController;
  bool isSearchEmpty = true;
  final DateFormat _dateFormatter = DateFormat('dd MMM');
  final DateFormat _timeFormatter = DateFormat('h:mm');
  var formatter = new DateFormat('dd MMMM');
  var formatter_date = new DateFormat('dd-MM-yyyy');
  List<Todo> TodaytodoList = [];
  List<Todo> TomtodoList = [];
  String noteid;
  String name="Shreyash";
  String user_image='assets/images/male1.png';
  int date_selector = 0;
  var fetchedNote;
  NotesModel noteData;
  final notifications = FlutterLocalNotificationsPlugin();
   Shader linearGradient;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  bool isShowingMainData;
  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    initiatePref();
    setNotesFromDB();
    setEventsFromDB();
    get_today_todo();
    get_tom_todo();
    isShowingMainData=true;
    final settingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);




    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    if (eventsList != null)
      _selectedCategoryIndex = eventsList.length + 1;
    else
      _selectedCategoryIndex = 1;
    if (notesList != null)
      _selectedCategoryIndex2 = notesList.length + 1;
    else
      _selectedCategoryIndex2 = 1;
    _tabController.addListener(_handleTabSelection);
  }

  Future onSelectNotification(String payload) async =>
      {

        if (payload.startsWith("note")){

          fetchedNote = await NotesDatabaseService.db.getNoteByIDFromDB(
              int.parse(payload.substring(4, payload.length))),
          noteData = fetchedNote,
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ViewNotePage(
                    triggerRefetch: refetchNotesFromDB, currentNote: noteData)),

          )
        },
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              DisplayQuestions(changeTheme: setTheme, payload: payload,)),

        )
      };
  getStarted() async {


    bool firstTime = prefs.getBool('first_home');

    if (!(firstTime != null && !firstTime) ){ // Not first time

      }
    else {
      prefs.setBool('first_home', false);
      showOngoingNotification(notifications,
          title: 'How was your Day buddy ?', body: 'Lets fill a small survey');
    }
    }
  get_today_todo() async {

    DateTime today=DateTime.now();
    String formatted_date = formatter_date.format(today);
    print("formatted date: " + formatted_date);

    int weekday=today.weekday;
    weekday=weekday+1;
    if (weekday>7)
      weekday=weekday%7;
    print(weekday);
    DateModel this_date;
    List<ReventModel> days_Revents;
    var days_Revents_var = await NotesDatabaseService.db.getReventsWithFilterDayFromDB(weekday);
    var fetchedDate = await NotesDatabaseService.db.getDateByDateFromDB(
        formatted_date);
    setState(() {
      this_date = fetchedDate;
      days_Revents = days_Revents_var;
    });
    if (this_date != null) {
      var fetchedEvents = await NotesDatabaseService.db.getEventsOfDateFromDB(
          this_date.id);

      setState(() {
        eventsListtoday = fetchedEvents;

      });
      print(days_Revents.length.toString() +" jain");

    }

    for (var i=0;i<days_Revents.length;i++){
      int diffDaysStart = today.difference(days_Revents[i].start_date).inDays;
      int diffDaysEnd = today.difference(days_Revents[i].end_date).inDays;
      if ((diffDaysStart == 0 && today.day == days_Revents[i].start_date.day) ||(diffDaysEnd == 0 && today.day == days_Revents[i].end_date.day) || (today.isAfter(days_Revents[i].start_date) && today.isBefore(days_Revents[i].end_date) )){
        var fetchedEventFromR= await NotesDatabaseService.db.getEventOfReventFromDB(days_Revents[i].event_id);
        eventsListtoday.add(fetchedEventFromR);
      }
    }
    for (var i = 0; i < eventsListtoday.length; i++) {
      if (eventsListtoday[i].todo_id != 0) {
        var fetchedtodo = await NotesDatabaseService.db.getTodos(
            eventsListtoday[i].todo_id);
        setState(() {
          TodaytodoList = fetchedtodo;
        });
        hashMap_today.putIfAbsent(eventsListtoday[i].id, () => TodaytodoList);
      }
    }
  }

  get_tom_todo() async {
    String formatted_date = formatter_date.format(
        DateTime.now().add(new Duration(days: 1)));
    print("formatted date: " + formatted_date);
    DateModel this_date;
    DateTime tomorrow= DateTime.now().add(new Duration(days: 1));
    int weekday=tomorrow.weekday;
    weekday=weekday+1;
    if (weekday>7)
      weekday=weekday%7;
    print(weekday);
    var days_Revents_var = await NotesDatabaseService.db.getReventsWithFilterDayFromDB(weekday);
    var fetchedDate = await NotesDatabaseService.db.getDateByDateFromDB(
        formatted_date);
    List<ReventModel> days_Revents=[];
    setState(() {
      this_date = fetchedDate;
      days_Revents=days_Revents_var;
    });
    if (this_date != null) {
      var fetchedEvents = await NotesDatabaseService.db.getEventsOfDateFromDB(
          this_date.id);


      setState(() {

        eventsListtom = fetchedEvents;
      });
      print(days_Revents.length);

    }

    for (var i=0;i<days_Revents.length;i++){
      print("here");
      int diffDaysStart = tomorrow.difference(days_Revents[i].start_date).inDays;
      print(days_Revents[i].start_date);
      int diffDaysEnd = tomorrow.difference(days_Revents[i].end_date).inDays;
      print(days_Revents[i].end_date);
      if ((diffDaysStart == 0 && tomorrow.day == days_Revents[i].start_date.day) ||(diffDaysEnd == 0 && tomorrow.day == days_Revents[i].end_date.day) || (tomorrow.isAfter(days_Revents[i].start_date) && tomorrow.isBefore(days_Revents[i].end_date) )){
        var fetchedEventFromR= await NotesDatabaseService.db.getEventOfReventFromDB(days_Revents[i].event_id);
        eventsListtom.add(fetchedEventFromR);
      }
    }
    for (var i = 0; i < eventsListtom.length; i++) {
      if (eventsListtom[i].todo_id != 0) {
        var fetchedtodo = await NotesDatabaseService.db.getTodos(
            eventsListtom[i].todo_id);
        setState(() {
          TomtodoList = fetchedtodo;
        });
        hashMap_tom.putIfAbsent(eventsListtom[i].id, () => TomtodoList);
      }
    }
  }

  void _handleTabSelection() {
    setState(() {
      date_selector =
          _tabController.index;
    });
  }


  setNotesFromDB() async {
    print("Entered setNotes");
    var fetchedNotes = await NotesDatabaseService.db.getAllNotesFromDB();
    setState(() {
      notesList = fetchedNotes;
    });

    for (int i = 0; i < notesList.length; i++) {
      print(notesList[i].title);
      var fetchedNotebook = await NotesDatabaseService.db.getNotebookByIDFromDB(
          notesList[i].book_id);
      notebookList.add(fetchedNotebook);
    }
  }

  setEventsFromDB() async {
    print("Entered setEvents");
    var fetchedEvents = await NotesDatabaseService.db.getEventsFromDB();
    setState(() {
      eventsList = fetchedEvents;
    });

    DateTime now = DateTime.now();
    for (int i = 0; i < eventsList.length; i++) {
      print(  "printer "+eventsList[i].title.toString());
      DateTime event_date = new DateTime(
          eventsList[i].date.year, eventsList[i].date.month,
          eventsList[i].date.day, eventsList[i].time.hour,
          eventsList[i].time.minute, eventsList[i].time.second);
      if (event_date.isBefore(now)) eventsList.removeAt(i);
    }
    eventsList.sort((a, b) {
      if (a.isImportant && !b.isImportant) return 0;
      if (a.isImportant && b.isImportant) return 1;
      if (a.date.day == b.date.day && a.date.month == b.date.month &&
          a.date.year == b.date.year) {
        return a.time.compareTo(b.time);
      }
      return a.date.compareTo(b.date);
    });

  }


  @override
  Widget build(BuildContext context) {


    linearGradient=LinearGradient(
        colors: [
          const Color(0xFF00c6ff),
          Theme
              .of(context)
              .primaryColor,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 1.00),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Scaffold(

      backgroundColor: Theme
          .of(context)
          .primaryColor,
        key: _scaffoldKey,
        floatingActionButtonLocation:

        FloatingActionButtonLocation.centerDocked,
        drawer: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          color: Theme
              .of(context)
              .canvasColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(


                decoration:
          new BoxDecoration(
              borderRadius: new BorderRadius.all(
              Radius.circular((20)),
    ),
    gradient: new LinearGradient(
    colors: [
    const Color(0xFF00c6ff),
      Theme
          .of(context)
          .primaryColor,
    ],
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 1.00),
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp),
    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[



                  Padding(
                    padding :EdgeInsets.only(right:20),
                    child:FadeAnimation(1.6, Container(

                      child:Image(
                        image: AssetImage(
                         user_image,
                        ),
                        height: 75,
                        width: 75,
                      ),),),),
                  Text(name, style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
                ],)


              ),
              ListTile(
                contentPadding: EdgeInsets.only(
                    bottom: 8, left: 16, right: 16, top: 8),
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Icon(Icons.book, color: Theme
                      .of(context)
                      .backgroundColor),
                ),
                title: Text("All Notebooks", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              MyDashPage(
                                  title: "home", changeTheme: setTheme)));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Icon(Icons.recent_actors, color: Theme
                      .of(context)
                      .backgroundColor),
                ),
                title: Text("My Timetable", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),),
                onTap: () {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: EventView(
                              title: 'Home',
                              changeTheme: setTheme,)));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Icon(Icons.question_answer, color: Theme
                      .of(context)
                      .backgroundColor),
                ),
                title: Text("Your Questions", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),),
                onTap: () {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: ListQuestion(
                              title: 'Home', changeTheme: setTheme)));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Icon(Icons.rate_review, color: Theme
                      .of(context)
                      .backgroundColor),
                ),
                title: Text("Daily Survey", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),),
                onTap: () {
                  Navigator.push(context,
                      FadeRoute(page: SurveyHomePage()));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                trailing: Icon(Icons.keyboard_arrow_right),

                leading: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Icon(Icons.show_chart, color: Theme
                      .of(context)
                      .backgroundColor),
                ),
                title: Text("Habit Analysis", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
                onTap: () async {
                  //Navigator.of(context).pop();
                  await NotesDatabaseService.db.getAllAnswersFromDB();
                },
              )
            ],
          ),
        ),
        floatingActionButton:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
          Material(
          shape: StadiumBorder(),
          elevation: 3.0,
          child: Ink(
            decoration:
            new BoxDecoration(
              borderRadius: new BorderRadius.all(
                Radius.circular((20)),
              ),
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFF00c6ff),
                    Theme
                        .of(context)
                        .primaryColor,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.00),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child:
              FloatingActionButton.extended(
                elevation: 0,


                heroTag: "btn1",

                backgroundColor: Colors.transparent,
                onPressed: () async {
                  gotoEditNote();
                  var time = Time(21, 00, 00);
                  var androidPlatformChannelSpecifics =
                  AndroidNotificationDetails('repeatDailyAtTime channel id',
                      'repeatDailyAtTime channel name',
                      'repeatDailyAtTime description');
                  var iOSPlatformChannelSpecifics =
                  IOSNotificationDetails();
                  var platformChannelSpecifics = NotificationDetails(
                      androidPlatformChannelSpecifics,
                      iOSPlatformChannelSpecifics);
                  await flutterLocalNotificationsPlugin.showDailyAtTime(
                      1,
                      'How was your Day ?',
                      'Time to fill a small daily survey buddy',
                      time,
                      platformChannelSpecifics);
                },
                label:

                Text('Quick Note'.toUpperCase(),
                  style: TextStyle(color: Colors.white),),
                icon: Icon(Icons.add),
              ),)),
      Material(
        shape: StadiumBorder(),
        elevation: 3.0,
        child: Ink(
          decoration:
          new BoxDecoration(
            borderRadius: new BorderRadius.all(
              Radius.circular((20)),
            ),
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFF00c6ff),
                  Theme
                      .of(context)
                      .primaryColor,
                ],
                begin: const FractionalOffset(1.0, 1.0),
                end: const FractionalOffset(0.0, 0.00),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child:
              FloatingActionButton.extended(
                elevation: 0,
                heroTag: "btn2",
                backgroundColor: Colors.transparent,
                onPressed: () async {
                  gotoEditEvent();
                },
                label: Text('Event'.toUpperCase(),
                    style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.add),
              ),)),
            ],
          ),
        ),
        body:

    CustomPaint(

        child:NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [

           SliverSafeArea(
          top: false,
          sliver: SliverAppBar(
            backgroundColor:    Color(0xFFAFB4C6).withOpacity(.9),
            actions: <Widget>[
              IconButton(
                icon: const Icon(OMIcons.settings),
                tooltip: 'Settings',
                onPressed: () { Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            SettingsPage(
                                changeTheme: widget.changeTheme)));},
              ),
            ],
            leading: IconButton(
              icon: const Icon(OMIcons.dashboard),
              tooltip: 'Add new entry',
              onPressed: () {  _scaffoldKey.currentState.openDrawer();},
            ),
            expandedHeight: 250,
            pinned: true,
              primary:true,
              shape: RoundedRectangleBorder(
              borderRadius:  BorderRadius.only(bottomRight: Radius.circular(45.0)),

            ),
            flexibleSpace: FlexibleSpaceBar(
                title: Text('Dashboard',textAlign:TextAlign.justify,style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,


                ),),


                background: Container(
                  padding: EdgeInsets.only(top:120,left:73),
                  child:FadeAnimation(1.6, Container(

                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[



                        Padding(
                          padding :EdgeInsets.only(right:20),
                          child:Image(
                              image: AssetImage(
                                user_image,
                              ),
                              height: 75,
                              width: 75,
                            ),),
                        Text(greeting() +'\n'+name,style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 24.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black26
                        ),
                          textAlign: TextAlign.left,),
                      ],)
                  )),
                  decoration: new BoxDecoration(

                    gradient: new LinearGradient(
                        colors: [
                          const Color(0xFF00c6ff),
                          Theme
                              .of(context)
                              .primaryColor,
                        ],
                        stops: [0.0, 1.0],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        tileMode: TileMode.clamp),
                  ),
                )
            ),

          ),

        ),

        ],
    body: Container(
      height: MediaQuery.of(context).size.height ,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
      ),

      child:FadeAnimation(1.6, Container(

      child:ListView(

          children: <Widget>[



            Container(
                margin: EdgeInsets.only(left:34),
                padding: EdgeInsets.all(8),
                decoration:
                new BoxDecoration(
                  borderRadius: new BorderRadius.only(topLeft:  Radius.circular(75.0),bottomLeft:   Radius.circular((20))),
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF00c6ff),
                        Theme
                            .of(context)
                            .primaryColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.00),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),

                child:Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(

                'Your Life Progress',
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),),),
            SizedBox(height: 20.0),
            Padding(
                padding: EdgeInsets.only(left:8,right:8),
                child:AspectRatio(
                  aspectRatio: 1.00,child:Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.00),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),

                  child: Stack(
                    children: <Widget>[


                      Column(

                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[




                          Padding(
                            padding:EdgeInsets.all(16),
                            child:Text(
                              'This Week',
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()..shader = linearGradient
                              ),
                              textAlign: TextAlign.center,

                            ),),



                          IconButton(
                            icon: Icon(
                              Icons.fast_forward,
                              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                isShowingMainData = !isShowingMainData;
                              });
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                              child: LineChart(

                                isShowingMainData ? sampleData1() : sampleData2(),
                                swapAnimationDuration: Duration(milliseconds: 250),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),


                    ],
                  ),
                ),)),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.only(left: 34),
                padding: EdgeInsets.all(8),
                decoration:
                new BoxDecoration(
                  borderRadius: new BorderRadius.only(topLeft:  Radius.circular(20.0),bottomLeft:   Radius.circular((20)),),
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF00c6ff),
                        Theme
                            .of(context)
                            .primaryColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.00),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),

                child:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(

                'Upcoming Events',
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),),),
            Container(
              height: 220.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: eventsList.length + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return SizedBox(width: 20.0);
                  }
                  if (index == eventsList.length + 1) {
                    return GestureDetector(


                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });

                        gotoEditEvent();
                      },


                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 10.0),
                        height: 200.0,
                        width: 135.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(
                            Radius.circular((20)),
                          ),
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

                        child: Padding(
                          padding: EdgeInsets.all(16),

                          child: Text(


                            'Add an Event ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:  Colors.white ,


                              fontFamily: 'ZillaSlab',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,

                            ),
                          ),)
                        ,),);
                  }
                  return _buildCategoryCard(
                    index - 1,
                    eventsList[index - 1],
                  );
                },
              ),
            ),
            Container(
                margin: EdgeInsets.only(left:34),
                padding: EdgeInsets.all(8),
                decoration:
                new BoxDecoration(
                  borderRadius: new BorderRadius.only(topLeft:  Radius.circular(20.0),bottomLeft:   Radius.circular((20))),
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF00c6ff),
                        Theme
                            .of(context)
                            .primaryColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.00),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),

                child:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(

                'Recent Notes',
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),),),
            Container(
              height: 180.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: notesList.length + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return SizedBox(width: 20.0);
                  }
                  if (index == notesList.length + 1) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex2 = index;
                        });
                        gotoEditNote();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 10.0),
                        height: 180.0,
                        width: 125.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(
                            Radius.circular((20)),
                          ),
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

                        child: Padding(

                          padding: EdgeInsets.all(16),
                          child: Text(

                            'Add a Note ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color:  Colors.white ,

                            ),
                          ),)
                        ,),);
                  }
                  return _buildCategoryCard2(
                      index - 1,
                      notesList[index - 1].title,
                      "In " + notebookList[index - 1].title,
                      formatter.format(notesList[index - 1].date),

                      notesList[index - 1]);
                },
              ),
            ),
            Container(
                margin: EdgeInsets.only(right:36),
                padding: EdgeInsets.all(8),
                decoration:
                new BoxDecoration(
                  borderRadius: new BorderRadius.only(topRight:  Radius.circular(20.0),bottomRight:   Radius.circular((20))),
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF00c6ff),
                        Theme
                            .of(context)
                            .primaryColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.00),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),

                child:

            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.grey,




                indicatorColor:Colors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 4.0,
                isScrollable: true,
                tabs: <Widget>[
                  Tab(

                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                         color: Colors.white
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Tomorrow',
                      style: TextStyle(

                        fontFamily: 'ZillaSlab',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),

                ],
              ),
            ),),
            SizedBox(height: 20.0),
            ...buildNoteComponentsList(),
            GestureDetector(
              onTap:(){gotoEditEvent();} ,
              child:Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 10),
                padding: EdgeInsets.all(12),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(
                    Radius.circular((20)),
                  ),
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF00c6ff),
                        Theme
                            .of(context)
                            .primaryColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.00),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Text(
                          "Add an Event",
                          style: TextStyle(
                            fontFamily: 'ZillaSlab',

                            fontSize: 26.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          " +",
                          style: TextStyle(
                            fontFamily: 'ZillaSlab',

                            fontSize: 26.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),),






            SizedBox(height: 80.0),
          ]

      ),))),
    )

    )

    );
  }

  /*Widget buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isFlagOn = !isFlagOn;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 160),
              height: 50,
              width: 50,
              curve: Curves.slowMiddle,
              child: Icon(
                isFlagOn ? Icons.flag : OMIcons.flag,
                color: isFlagOn ? Colors.white : Colors.grey.shade300,
              ),
              decoration: BoxDecoration(
                  color: isFlagOn ? Colors.blue : Colors.transparent,
                  border: Border.all(
                    width: isFlagOn ? 2 : 1,
                    color:
                        isFlagOn ? Colors.blue.shade700 : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.only(left: 16),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      maxLines: 1,
                      onChanged: (value) {
                        handleSearch(value);
                      },
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isSearchEmpty ? Icons.search : Icons.cancel,
                        color: Colors.grey.shade300),
                    onPressed: cancelSearch,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }*/

  setTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
    } else {
      setState(() {
        theme = appThemeLight;
      });
    }
  }

  List<Widget> buildNoteComponentsList() {
    HashMap hashMap_asked;
    List<EventModel> asked = [];
    if (date_selector == 1) {
      setState(() {
        asked = eventsListtom;
        hashMap_asked = hashMap_tom;
      });
    }
    else {
      setState(() {
        asked = eventsListtoday;
        hashMap_asked = hashMap_today;
      });
    }

    List<Widget> noteComponentsList = [];

    asked.sort((a, b) {
      if (a.date.day == b.date.day && a.date.month == b.date.month &&
          a.date.year == b.date.year) {
        return a.time.compareTo(b.time);
      }
      return a.date.compareTo(b.date);
    });


    int position = 1;
    asked.forEach((event) {
      if (event.duration == 0) {
        List<Todo> TodoList = [];
        if (event.todo_id != 0) {
          TodoList = hashMap_asked[event.id];
        }

        noteComponentsList.add(NoteCardComponent(
          eventData: event,
          onTapAction: setIsdone,
          openEvent: openEventToEdit,
          todoList: (TodoList != null) ? TodoList : null,
          position: position,
        ));
      }
    });
    asked.forEach((event) {
      if (event.duration != 0) {
        List<Todo> TodoList = [];
        if (event.todo_id != 0) {
          TodoList = hashMap_asked[event.id];
        }

        noteComponentsList.add(NoteCardComponent(
          eventData: event,
          onTapAction: setIsdone,
          openEvent: openEventToEdit,
          todoList: (TodoList != null) ? TodoList : null,
          position: position,
        ));
        position = position + 1;
      }
    });

    return noteComponentsList;
  }

  Widget _buildCategoryCard(int index, EventModel this_event) {
    final date2 = DateTime.now();
    final difference = this_event.date
        .difference(date2)
        .inDays;
    //formatter.format(this_event.date)
    String bottom_text = "at ${_timeFormatter.format(this_event.time)}";
    String count=this_event.duration.toString().substring(0,this_event.duration.toString().length-2) + " mins";
    if (this_event.duration==0) count ="All day";
    if (difference > 1) {
      bottom_text = "In\n${difference} days";
    }

      else if (difference==0 && date2.isAfter(this_event.date)){
        if(this_event.duration==0 )
        bottom_text="today";
        else {

            bottom_text="today $bottom_text";
        }
      }
      else if(difference==1){
      if(this_event.duration==0)
        bottom_text="tomorrow";
      else {

        bottom_text="tomorrow at $bottom_text";
      }

      }


    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      onLongPress: () {
        openEventToEdit(this_event);
      },
      child:

      Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        height: 270.0,
        width: 220.0,

        decoration: BoxDecoration(
            gradient:_selectedCategoryIndex == index ?
            new LinearGradient(
                colors: [
                  const Color(0xFF00c6ff),
                  Theme.of(context).primaryColor,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.00),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp):
            LinearGradient(
            colors: [
             Theme
                .of(context)
                .cardColor,
              Theme
                  .of(context)
                  .cardColor,
          ],
          begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 1.00),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 8),
                  color: Colors.black.withAlpha(20),
                  blurRadius: 16)
            ],

        ),
        child: Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, bottom: 0, top: 20, right: 8),
              child: Text(
                this_event.title,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',

                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      : Color(0xFFAFB4C6),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, bottom: 20, top: 8, right: 8),
              child: Text(
                bottom_text,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',

                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      : Theme
                      .of(context)
                      .textSelectionColor,
                  fontSize: 21.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 12, right: 12,bottom: 16),

                  decoration: BoxDecoration(

                      color: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8.0, left: 8, bottom: 8, right: 8),
                    child: Text(
                      '${count
                          .trim()
                          .length <= 60 ? count.trim() : count.trim().substring(
                          0, 60) + '...'}',
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',

                        color
                            : Theme
                            .of(context)
                            .textSelectionColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ),
                if (this_event.isImportant)Container(
                  margin: EdgeInsets.only(left: 2, right: 12,bottom: 16),

                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8.0, left: 8, bottom: 8, right: 8),
                    child:Icon(Icons.alarm_on,color: Theme
                        .of(context)
                        .textSelectionColor,)
                  ),

                ),
                if (this_event.todo_id!=0)Container(
                  margin: EdgeInsets.only(left: 2, right: 12,bottom: 16),

                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                      ]
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: 8.0, left: 8, bottom: 8, right: 8),
                      child:Icon(Icons.toc,color: Theme
                          .of(context)
                          .textSelectionColor,)
                  ),

                ),
              ],
            )



          ],
        ),
      )
    );
  }


  Widget _buildCategoryCard2(int index, String title, String count, String date,
      NotesModel this_note) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex2 = index;
          openNoteToRead(this_note);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        height: 160.0,
        width: 205.0,
        decoration: BoxDecoration(
            gradient: _selectedCategoryIndex2 == index
            ?new LinearGradient(
            colors: [
            const Color(0xFF00c6ff),
          Theme.of(context).primaryColor,
          ],
          begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 1.00),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp):
    LinearGradient(
    colors: [
    Theme
        .of(context)
        .cardColor,
    Theme
        .of(context)
        .cardColor,
    ],
    begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 1.00),
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp),

            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 8),
                  color: Colors.black.withAlpha(20),
                  blurRadius: 16)
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12.0, left: 12),
              child: Text(
                '${title
                    .trim()
                    .length <= 16 ? title.trim() : title.trim().substring(
                    0, 16) + '...'}',
                style: TextStyle(
                  fontFamily: 'ZillaSlab',

                  color: _selectedCategoryIndex2 == index
                      ? Colors.white
                      : Color(0xFFAFB4C6),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12, right: 12, top: 8),

              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                  ]
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 8.0, left: 8, bottom: 8, right: 8),
                child: Text(
                  '${count
                      .trim()
                      .length <= 60 ? count.trim() : count.trim().substring(
                      0, 60) + '...'}',
                  style: TextStyle(
                    fontFamily: 'ZillaSlab',

                    color
                        : Theme
                        .of(context)
                        .textSelectionColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            ),

            Padding(
              padding: EdgeInsets.only(
                  top: 4.0, left: 12, bottom: 12, right: 4),
              child: Text(
                date,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',

                  color: _selectedCategoryIndex2 == index
                      ? Colors.white
                      : Theme
                      .of(context)
                      .textSelectionColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /*List<Widget> buildNoteComponentsList() {
    List<Widget> noteComponentsList = [];
    notesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    if (searchController.text.isNotEmpty) {
      notesList.forEach((note) {
        if (note.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
          noteComponentsList.add(NoteCardComponent(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
      return noteComponentsList;
    }
    if (isFlagOn) {
      notesList.forEach((note) {
        if (note.isImportant)
          noteComponentsList.add(NoteCardComponent(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
    } else {
      notesList.forEach((note) {
        noteComponentsList.add(NoteCardComponent(
          noteData: note,
          onTapAction: openNoteToRead,
        ));
      });
    }
    return noteComponentsList;
  }
*/


  void gotoEditNote() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                EditorPage(
                    triggerRefetch: refetchNotesFromDB, book_id: 1)));
  }

  Future<void> gotoEditEvent() async {
    Navigator.push(
        context,
        CupertinoPageRoute(

            builder: (context) =>

                AddEventPage(triggerRefetch: refetchEventsFromDB)));
  }

  void refetchNotesFromDB() async {
    await setNotesFromDB();
    print("Refetched notes");
  }

  void refetchEventsFromDB() async {
    await setEventsFromDB();
    await get_today_todo();
    await get_tom_todo();
    print("Refetched Events");
  }

  openNoteToRead(NotesModel noteData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewNotePage(
                triggerRefetch: refetchNotesFromDB, currentNote: noteData)));
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }

  openEventToEdit(EventModel eventData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: AddEventPage(
              triggerRefetch: refetchEventsFromDB, existingEvent: eventData,)));
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
  setIsdone(Todo todoData) async {
    setState(() {
      todoData.isDone = !todoData.isDone;
    });
    print(todoData.isDone);
    await setEventsFromDB();
    await get_today_todo();
    await  get_tom_todo();

  }

  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );

 initiatePref() async {
   prefs = await SharedPreferences.getInstance();
   if (prefs.getString('user_name')!=null) name=prefs.getString('user_name');
   if (prefs.getString('user_image')!=null) user_image=prefs.getString('user_image');
   getStarted();
 }
}
LineChartData sampleData1() {
  return LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
      touchCallback: (LineTouchResponse touchResponse) {
        print(touchResponse);
      },
      handleBuiltInTouches: true,
    ),
    gridData: const FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        textStyle: TextStyle(
          color: const Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        margin: 10,
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'SEPT';
            case 7:
              return 'OCT';
            case 12:
              return 'DEC';
          }
          return '';
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        textStyle: TextStyle(
          color: const Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '1m';
            case 2:
              return '2m';
            case 3:
              return '3m';
            case 4:
              return '5m';
          }
          return '';
        },
        margin: 8,
        reservedSize: 30,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: const Color(0xff4e4965),
          width: 4,
        ),
        left: BorderSide(
          color: Colors.transparent,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    minX: 0,
    maxX: 14,
    maxY: 4,
    minY: 0,
    lineBarsData: linesBarData1(),
  );
}

List<LineChartBarData> linesBarData1() {
  LineChartBarData lineChartBarData1 = const LineChartBarData(
    spots: [
      FlSpot(1, 1),
      FlSpot(3, 1.5),
      FlSpot(5, 1.4),
      FlSpot(7, 3.4),
      FlSpot(10, 2),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ],
    isCurved: true,
    colors: [
      Color(0xff4af699),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData lineChartBarData2 = LineChartBarData(
    spots: [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
    isCurved: true,
    colors: [
      Color(0xffaa4cfc),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(show: false, colors: [
      Color(0x00aa4cfc),
    ]),
  );
  LineChartBarData lineChartBarData3 = LineChartBarData(
    spots: const [
      FlSpot(1, 2.8),
      FlSpot(3, 1.9),
      FlSpot(6, 3),
      FlSpot(10, 1.3),
      FlSpot(13, 2.5),
    ],
    isCurved: true,
    colors: const [
      Colors.redAccent,
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(
      show: false,
    ),
    belowBarData: const BarAreaData(
      show: false,
    ),
  );
  return [
    lineChartBarData1,
    lineChartBarData2,
    lineChartBarData3,
  ];
}

LineChartData sampleData2() {
  return LineChartData(
    lineTouchData: const LineTouchData(
      enabled: false,
    ),
    gridData: const FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        textStyle: TextStyle(
          color: const Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        margin: 10,
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'JAN';
            case 7:
              return 'FEB';
            case 12:
              return 'MAR';
          }
          return '';
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        textStyle: TextStyle(
          color: const Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '1m';
            case 2:
              return '2m';
            case 3:
              return '3m';
            case 4:
              return '5m';
          }
          return '';
        },
        margin: 8,
        reservedSize: 30,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: const Color(0xff4e4965),
          width: 4,
        ),
        left: BorderSide(
          color: Colors.transparent,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    minX: 0,
    maxX: 14,
    maxY: 4,
    minY: 0,
    lineBarsData: linesBarData2(),
  );
}

List<LineChartBarData> linesBarData2() {
  return [
    const LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 4),
        FlSpot(5, 1.8),
        FlSpot(7, 5),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
      isCurved: true,

      colors: [
        Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    ),
    const LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        Color(0xff27b6fc),
      ]),
    ),
    const LineChartBarData(
      spots: [
        FlSpot(1, 3.8),
        FlSpot(3, 1.9),
        FlSpot(6, 5),
        FlSpot(10, 3.3),
        FlSpot(13, 4.5),
      ],
      isCurved: true,

      colors: [
        Color(0xff27b6fc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    ),
  ];
}