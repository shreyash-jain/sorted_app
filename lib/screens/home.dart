import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:core';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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
import 'package:notes/screens/AnswerView.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/ListQuestion.dart';
import 'package:notes/screens/Survey_start.dart';
import 'package:notes/screens/addEvent.dart';
import 'package:notes/screens/EventView.dart';
import 'package:notes/screens/allTimelines.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/screens/financialManager.dart';
import 'package:notes/screens/profilePage.dart';
import 'package:notes/screens/richedit.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/auth.dart';
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
    with TickerProviderStateMixin , AutomaticKeepAliveClientMixin<MyHomePage> {
  bool isFlagOn = false;
  bool headerShouldHide = false;

  String google_url="";
  int my_events_drawer=0;
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
  HashMap DateTime_survey = new HashMap<String, int>();
  bool timeline=false;
  final _random = new Random();
  List<String> below_texs = ["one", "two", "three", "four", "five"];
  List<EventModel> eventsList = [];
  List<EventModel> eventsListtoday = [];
  List<EventModel> eventsListtom = [];
  TodoBloc todoBloc;
  Map<String, dynamic> _profile;

  List<String> inspirations=[];
  HashMap hashMap_today = new HashMap<int, List<Todo>>();
  HashMap hashMap_tom = new HashMap<int, List<Todo>>();
  TextEditingController searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  int _selectedCategoryIndex2 = 0;
  TabController _tabController;
  bool isSearchEmpty = true;
  List<String> ImagesUrl=["https://i.picsum.photos/id/18/200/300.jpg","https://i.picsum.photos/id/14/200/300.jpg","https://i.picsum.photos/id/14/200/300.jpg","https://i.picsum.photos/id/108/200/300.jpg","https://i.picsum.photos/id/84/200/300.jpg","https://i.picsum.photos/id/108/200/300.jpg","https://i.picsum.photos/id/104/200/300.jpg"];

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
  var formatterDate = new DateFormat('dd-MM-yyyy');
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var formatter_day = new DateFormat('d');
  var formatter_year = new DateFormat('yyyy');
  var formatter_day_name = new DateFormat('EEEE');
  var formatter_month = new DateFormat('MMMM');
  Animation<double> rippleAnimation;
  Animation<double> scaleAnimation;
  AnimationController rippleController;
  AnimationController scaleController;
  bool isShowingMainData;
  int randomNumber;
  static int current_position=6;
  final scontrollerDay =
  PageController(viewportFraction: 0.5, initialPage: current_position, keepPage: true);
  DateTime TofillDate=DateTime.now();
  double page_offset = 6;
  int show_button=0;

  DateTime today=DateTime.now();
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    initiatePref();

    setNotesFromDB();
    setEventsFromDB();
    getImages();
    get_today_todo();
    Split_text();
    get_tom_todo();
    getPastWeek();
    randomNumber = _random.nextInt(1324);
    rippleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1)
    );

    scaleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1)
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {


        Navigator.push(context,
            FadeRoute(page: DisplayQuestions(changeTheme: setTheme,setDate: TofillDate,)));
      }
    });

    rippleAnimation = Tween<double>(
        begin: 80.0,
        end: 90.0
    ).animate(rippleController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rippleController.reverse();
      } else if(status == AnimationStatus.dismissed) {
        rippleController.forward();
      }
    });

    scontrollerDay.addListener(() {
      setState(() =>
      page_offset = scontrollerDay.page); //<-- add listener and set state
    });
    scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 30.0
    ).animate(scaleController);

    rippleController.forward();
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
  void dispose() {
    rippleController.dispose();

    scaleController.dispose();
    super.dispose();
  }
  getImages() async {
    int i=0;
    int rand=next(1,100);
    var url = 'https://picsum.photos/v2/list?page='+rand.toString()+'&limit=7';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      for (i=0;i<7;i++){
        ImagesUrl[i]=jsonResponse[i]["id"];

        setState(() {

          ImagesUrl[i]="https://i.picsum.photos/id/"+ImagesUrl[i]+"/300/520.jpg";
        });
        print( ImagesUrl[i]);

      }



    } else {
      print('Request failed with status: ${response.statusCode}.');
    }


    setState(() {
      show_button=DateTime_survey[formatterDate.format(TofillDate)];
    });
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
          title: 'How was your day buddy ?', body: 'Lets fill a small survey');
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
        var fetchedEventFromR= await NotesDatabaseService.db.getEventOfReventFromDB(days_Revents[i].id);
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
        var fetchedEventFromR= await NotesDatabaseService.db.getEventOfReventFromDB(days_Revents[i].id);
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

  Future<void> getPastWeek() async {
    DateTime date=DateTime.now();
    int i=0;
    var formatter = new DateFormat('dd-MM-yyyy');
    while(i<7){
      DateModel this_date;
      int survey;
      ;
      String formatted_date = formatter.format(date);
      print("formatted date: " + formatted_date);
      var fetchedDate =
      await NotesDatabaseService.db.getDateByDateFromDB(formatted_date);
      setState(() {
        this_date = fetchedDate;
      });
      if (this_date==null) survey=0;
      else survey=this_date.survey;
      print(formatted_date+"  "+survey.toString());
      DateTime_survey.putIfAbsent(formatted_date, () => survey);
      date=date.subtract(Duration(days:1));
      i++;

    }

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
    List<EventModel> refined_events=[];
    for (int i = 0; i < eventsList.length; i++) {
      print(  "printer "+eventsList[i].title.toString());
      DateTime event_date = new DateTime(
          eventsList[i].date.year, eventsList[i].date.month,
          eventsList[i].date.day,now.hour,
          now.minute, now.second+1);
      if (!event_date.isBefore(now)) refined_events.add(eventsList[i]);
    }
    eventsList=[];
    eventsList=refined_events;
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
    super.build(context);
    Random random = new Random();




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
              borderRadius: new BorderRadius.only(
             bottomLeft: Radius.circular(20),bottomRight:Radius.circular((20)),
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
                child: Stack(children: <Widget>[



                  Padding(padding:EdgeInsets.only(top:6,left: 40),child:Text("S     RTED",style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize:60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white12
                  ))),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      FadeAnimation(.6, Container(child:

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[



                          Padding(
                              padding :EdgeInsets.only(left:77,right: 12),


                              child:Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.all(Radius.circular(50))),

                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[

                                    Stack(children: <Widget>[

                                      Image(
                                        image: AssetImage(
                                          user_image,
                                        ),
                                        height: 60,
                                        width:60,
                                      ),
                                      Padding(
                                          padding :EdgeInsets.only(right:0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              google_url,
                                            ),
                                            radius: 30,
                                            backgroundColor: Colors.transparent,
                                          )),




                                    ],)


                                  ],),)),
                          Text(name, style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize:20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                        ],))),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            IconButton(
                              icon: const Icon(OMIcons.settings,color: Colors.white54,),
                              tooltip: 'Settings',
                              onPressed: () { Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          SettingsPage(
                                              changeTheme: widget.changeTheme)));},
                            ),

                            GestureDetector(

                              onTap:(){
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            ProfilePage(
                                            )));


                              } ,
                              child:Container(
                                alignment: Alignment.center,


                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[

                                    Container(

                                      padding: EdgeInsets.all(12),
                                      decoration:
                                      new BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                            Radius.circular((20)),

                                          ),
                                          color: Colors.white12
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.edit,
                                            size: 16.0,
                                            color: Colors.white60,
                                          ),
                                          Container(
                                            width: 16,
                                          ),
                                          Text(
                                            "profile",
                                            style: TextStyle(
                                                fontFamily: 'ZillaSlab',

                                                color: Colors.white60,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    )


                                  ],
                                ),
                              ),)]),

                    ],)
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
                subtitle: Text("The one where your organized notes are kept", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:16.0,
                  fontWeight: FontWeight.bold,
                ),),
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
                subtitle: Text("The one where planning starts and your ToDos", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:16.0,
                  fontWeight: FontWeight.bold,
                ),),
                title: Text("My Events", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),),
                onTap: () {

                  setState(() {
                    my_events_drawer=1-my_events_drawer;
                  });
                 /* Navigator.push(
                      context,
                      FadeRoute(
                          page: EventView(
                              title: 'Home',
                              changeTheme: setTheme,)));*/
                },
              ),
              if (my_events_drawer==1)ListTile(
                contentPadding: EdgeInsets.only(bottom: 0, left: 73, right: 16),
                trailing: Icon(Icons.keyboard_arrow_right),

                subtitle: Text("All events in a day", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:16.0,
                  fontWeight: FontWeight.bold,
                ),),


                title: Text("My Timetable", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),),
                onTap: () {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: EventView(
                            title: 'Home',
                            changeTheme: setTheme,)));

                  my_events_drawer=0;
                },
              ),
              if (my_events_drawer==1)ListTile(
                contentPadding: EdgeInsets.only(bottom: 0, left: 73, right: 16),
                trailing: Icon(Icons.keyboard_arrow_right),

                subtitle: Text("All events in my Timelines", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:16.0,
                  fontWeight: FontWeight.bold,
                ),),


                title: Text("My Timelines", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),),
                onTap: () {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: AllTimelines(
                            title: 'Home',
                            changeTheme: setTheme,)));

                  my_events_drawer=0;
                },
              ),
              if (my_events_drawer==1)ListTile(
                contentPadding: EdgeInsets.only(bottom: 8, left: 73, right: 16),
                trailing: Icon(Icons.keyboard_arrow_right),



                title: Text("All Events", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 18.0,
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
                subtitle: Text("The one where you choose what you want to keep track of", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:16.0,
                  fontWeight: FontWeight.bold,
                ),),
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
                subtitle: Text("The one where you introspect, write and give data", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:16.0,
                  fontWeight: FontWeight.bold,
                ),),
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
                subtitle: Text("The one where data is analysed and shown in best form", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:16.0,
                  fontWeight: FontWeight.bold,
                ),),
                title: Text("Habit Analysis", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
                onTap: () async {
                  //Navigator.of(context).pop();
                  await NotesDatabaseService.db.getAllAnswersFromDB();
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: AnswerView(
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
                  child: Icon(Icons.attach_money, color: Theme
                      .of(context)
                      .backgroundColor),
                ),
                subtitle: Text("The one where you manage your expenses", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:16.0,
                  fontWeight: FontWeight.bold,
                ),),
                title: Text("Financial Manager", style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
                onTap: () async {
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: FinanceView(
                            title: 'Home',
                            changeTheme: setTheme,)));

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

                Text('Note'.toUpperCase(),
                  style: TextStyle(color: Colors.white,fontSize: 12),),
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
                          style: TextStyle(color: Colors.white,fontSize: 12)),
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
                  padding: EdgeInsets.only(top:45,left:73),
                  child:FadeAnimation(1.6, Container(

                    child:Stack(children: <Widget>[

                      Padding(
                        padding: EdgeInsets.only(left:0,top:0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child:Icon(
                            OMIcons.dashboard,color: Theme.of(context).cardColor.withOpacity(.08),size: 300,
                          ),
                        ),
                      ),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget>[


                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[


                               GestureDetector(
                                 onTap: (){

                                   Navigator.push(
                                       context,
                                       CupertinoPageRoute(
                                           builder: (context) =>
                                               ProfilePage(
                                               )));
                                 },
                                 child:Container(
                                   margin :EdgeInsets.only(right:15),
                                   height:65,
                                   width: 65,
                                   decoration: BoxDecoration(
                                       color: Colors.transparent,
                                       border: Border.all(color: Theme.of(context).primaryColor),
                                       borderRadius: BorderRadius.all(Radius.circular(50))),

                                   child:Column(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: <Widget>[
                                   Hero(
                                   tag: "DemoTag",
                                       transitionOnUserGestures: true,
                                       child:Stack(children: <Widget>[

                                           Image(
                                             image: AssetImage(
                                               user_image,
                                             ),
                                             height: 55,
                                             width:55,
                                           ),
                                           Padding(
                                             padding :EdgeInsets.only(right:0),
                                             child: CircleAvatar(
                                               backgroundImage: NetworkImage(
                                                 google_url,
                                               ),
                                               radius: 28,
                                               backgroundColor: Colors.transparent,
                                             )),




                                         ],))

                                         ,])),),
                                Text(greeting() +'\n'+name,style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45
                                ),
                                  textAlign: TextAlign.left,),
                              ],),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[



                                Expanded(child:Padding(
                                  padding :EdgeInsets.only(right:20,top:(inspirations[randomNumber].length>30)?20:40),
                                  child:Text(inspirations[randomNumber],style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: (inspirations[randomNumber].length>70)?17:20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white60
                                  ),
                                    textAlign: TextAlign.left,),)),

                              ],),



                          ]),
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

                'Quick Actions',
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),),),
            SizedBox(height: 10.0),
            AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.decelerate,
                height: 360,
                margin: EdgeInsets.only(top:0, bottom: 0, left: 0,right:0),

                child: Container(
                  height: 350,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(top:8,bottom: 8),
                  decoration:
                  new BoxDecoration(
                    borderRadius: new BorderRadius.only(topLeft:  Radius.circular(0.0),topRight:   Radius.circular((0)),bottomLeft:   Radius.circular((0)),bottomRight:   Radius.circular((0)),),

                  ),
                  child:Padding(
                    padding: EdgeInsets.only(left: 0),
                    child:PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7 ,
                        controller: scontrollerDay,



                        onPageChanged: (int page){
                          setState(() {


                            current_position=page;


                          });


                          setState(() {
                            DateTime this_date=today.subtract((Duration(days: 6-page)));
                            TofillDate = this_date;


                            show_button=DateTime_survey[formatterDate.format(TofillDate)];

                          });

                        },
                        itemBuilder: (BuildContext context, int index) {


                          return _buildBigActivityCard(
                              index,
                              today.subtract(Duration(days: 6-index)),
                              page_offset-index
                          );

                        }
                    ),),)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[

              Container(
                margin: EdgeInsets.only(left:34,top:20),
                padding: EdgeInsets.only(top:8),
                height: 258,
                width: MediaQuery.of(context).size.width/2-30,
                decoration:
                new BoxDecoration(
                  borderRadius: new BorderRadius.all(  Radius.circular(20.0)),
                  gradient: new LinearGradient(
                      colors: [

                       Colors.grey.withOpacity(.2),
                        Colors.grey.withOpacity(.2),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.00),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),

                child:Padding(
                  padding: EdgeInsets.symmetric(horizontal:0,vertical: 0),
                  child: Column(children: <Widget>[

                    Row(children: <Widget>[

                      Container(
                        margin: EdgeInsets.only(left:20,top: 16),
                        width: 60,
                        height: 60,
                        decoration:
                        new BoxDecoration(
                          borderRadius: new BorderRadius.all(  Radius.circular(60.0)),
                          border: Border.all(color: Colors.grey.shade400, width: 2),

                        ),


                        child: Icon(OMIcons.event,color: Colors.grey.withOpacity(.4),size: 40,),


                      )

                    ],),
                    SizedBox(height: 10,),
                    Row(children: <Widget>[

                      Container(
                          margin: EdgeInsets.only(top:15,left: 20),

                        decoration:
                        new BoxDecoration(
                          borderRadius: new BorderRadius.all(  Radius.circular(60.0)),


                        ),


                        child:Text("Add an event", style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize:18.0,

                          color: Colors.grey,
                        ),)


                      )

                    ],),
                    Row(children: <Widget>[

                      Container(
                          margin: EdgeInsets.only(top:2,left: 20),

                          decoration:
                          new BoxDecoration(
                            borderRadius: new BorderRadius.all(  Radius.circular(60.0)),


                          ),


                          child:Text("10 EVENTS TODAY", style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize:12.0,

                            color: Colors.grey.withOpacity(.7),
                          ),)


                      )

                    ],),
                    SizedBox(height: 10,),
                    Row(children: <Widget>[

                      Container(
                          margin: EdgeInsets.only(top:10),
                          padding: EdgeInsets.only(left:20,top:10),

                          height: 47,
                          width:MediaQuery.of(context).size.width/2-30,
                          decoration:
                          new BoxDecoration(

                            gradient: new LinearGradient(
                                colors: [

                                  Colors.grey.withOpacity(.1),
                                  Colors.grey.withOpacity(.3),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 1.00),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),

                          ),


                          child:Text("Now", style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize:16.0,


                            color: Colors.grey.withOpacity(.9),
                          ),)


                      )

                    ],),
                    Row(children: <Widget>[

                      Container(
                          margin: EdgeInsets.only(top:0),
                          padding: EdgeInsets.only(left:20,top:0),

                          height: 37,
                          width:MediaQuery.of(context).size.width/2-30,
                          decoration:
                          new BoxDecoration(
                            borderRadius: new BorderRadius.only(  bottomLeft:Radius.circular(20.0),bottomRight:Radius.circular(20.0)),

                            gradient: new LinearGradient(
                                colors: [

                                  Colors.grey.withOpacity(.1),
                                  Colors.grey.withOpacity(.3),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 1.00),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),

                          ),


                          child:Text("My app", style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize:16.0,
                            fontWeight: FontWeight.bold,

                            color: Colors.grey.withOpacity(.7),
                          ),)


                      )

                    ],)

                  ],),),),

              Column(children: <Widget>[

                Container(
                  margin: EdgeInsets.only(left:20,top:20),
                  padding: EdgeInsets.only(top:8),
                  height:90,
                  width: MediaQuery.of(context).size.width/2-40,
                  decoration:
                  new BoxDecoration(
                    borderRadius: new BorderRadius.all(  Radius.circular(20.0)),
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

                  child:Padding(
                    padding: EdgeInsets.symmetric(horizontal:0,vertical: 0),
                    child: Stack(children: <Widget>[

                      Icon(OMIcons.add,color: Colors.white.withOpacity(.2),size:25,),



                      Column(children: <Widget>[



                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Container(
                                margin: EdgeInsets.only(top:5,left: 0),

                                decoration:
                                new BoxDecoration(
                                  borderRadius: new BorderRadius.all(  Radius.circular(60.0)),


                                ),


                                child:Text("QUICK NOTE", style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize:16.0,
                                  fontWeight: FontWeight.bold,

                                  color: Colors.white70,
                                ),)


                            )

                          ],),

                        Row(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: <Widget>[

                            Container(
                              margin: EdgeInsets.only(left:10,top: 5,right:6),
                              width:40,
                              height: 40,
                              decoration:
                              new BoxDecoration(
                                borderRadius: new BorderRadius.all(  Radius.circular(60.0)),
                                border: Border.all(color:   const Color(0xFF00c6ff), width: 2),

                              ),


                              child: Icon(OMIcons.notes,color: Colors.white.withOpacity(.6),size: 25,),


                            ),
                            Container(
                                margin: EdgeInsets.only(top:5,left:0),
                                padding: EdgeInsets.only(left:0,top:0),

                                height: 50,
                                width:MediaQuery.of(context).size.width/4,
                                decoration:
                                new BoxDecoration(
                                  borderRadius: new BorderRadius.only( topRight:Radius.circular(0.0),topLeft: Radius.circular(20.0), bottomLeft:Radius.circular(0.0),bottomRight:Radius.circular(20.0)),

                                  gradient: new LinearGradient(
                                      colors: [

                                        Colors.indigo.withOpacity(.1),
                                        Colors.indigoAccent.withOpacity(.1),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 1.00),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),

                                ),


                                child:Icon(Icons.arrow_forward,size: 40,color: Colors.white54,)


                            )


                          ],),





                      ],)


                    ],),),),
                Container(
                  margin: EdgeInsets.only(left:20,top:20),
                  padding: EdgeInsets.only(top:8),
                  height:145,
                  width: MediaQuery.of(context).size.width/2-40,
                  decoration:
                  new BoxDecoration(
                    borderRadius: new BorderRadius.all(  Radius.circular(20.0)),
                    gradient: new LinearGradient(
                        colors: [

                          Colors.grey.withOpacity(.2),
                          Colors.grey.withOpacity(.2),

                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.00),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),

                  child:Padding(
                    padding: EdgeInsets.symmetric(horizontal:0,vertical: 0),
                    child: Stack(children: <Widget>[





                      Column(children: <Widget>[



                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Container(
                                margin: EdgeInsets.only(top:5,left: 0),

                                decoration:
                                new BoxDecoration(
                                  borderRadius: new BorderRadius.all(  Radius.circular(60.0)),


                                ),


                                child:Text("MY EXPENSES", style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize:16.0,
                                  fontWeight: FontWeight.bold,

                                  color: Colors.grey,
                                ),)


                            )

                          ],),

                        Row(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: <Widget>[


                            Container(
                                margin: EdgeInsets.only(top:5,left:0),
                                padding: EdgeInsets.only(left:16,top:0),

                                height:65,
                                width:MediaQuery.of(context).size.width/2-40,
                                decoration:
                                new BoxDecoration(

                                  gradient: new LinearGradient(
                                      colors: [

                                        Colors.grey.withOpacity(.3),
                                        Colors.grey.withOpacity(.05),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 1.00),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),

                                ),


                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 5,),

                                  Text("Today", style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize:18.0,


                                    color: Colors.grey,
                                  ),),
                                    SizedBox(height: 4,),
                                  Text("1500 Rs", style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize:20.0,
                                    fontWeight: FontWeight.bold,

                                    color: Colors.grey,
                                  ),)


                                ],)


                            )


                          ],),
                        Row(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: <Widget>[


                            Container(
                                margin: EdgeInsets.only(top:8,right:10),
                                padding: EdgeInsets.only(left:0,top:0),



                                decoration:
                                new BoxDecoration(
                                  borderRadius: new BorderRadius.only( topRight:Radius.circular(0.0),topLeft: Radius.circular(20.0), bottomLeft:Radius.circular(0.0),bottomRight:Radius.circular(20.0)),



                                ),


                                child:Text("ADD ", textAlign:TextAlign.center,style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize:18.0,


                                  color: Colors.grey.withOpacity(.5),
                                ),)


                            ),
                            Container(
                                margin: EdgeInsets.only(top:8,left:0,right:10),
                                padding: EdgeInsets.only(left:0,top:0),



                                decoration:
                                new BoxDecoration(
                                  borderRadius: new BorderRadius.only( topRight:Radius.circular(0.0),topLeft: Radius.circular(20.0), bottomLeft:Radius.circular(0.0),bottomRight:Radius.circular(20.0)),



                                ),


                                child:Icon(Icons.arrow_forward,size: 25,color: Colors.white54,)


                            )


                          ],),





                      ],)


                    ],),),),



              ],)

              /*Container(
                margin: EdgeInsets.only(left:8),
                padding: EdgeInsets.only(bottom:8,top:8),
                decoration:
                new BoxDecoration(
                  borderRadius: new BorderRadius.all(  Radius.circular(20.0)),
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
                  padding: EdgeInsets.symmetric(horizontal:16),
                  child: Text(

                    'Add\nNote',
                    style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 22.0,

                      color: Colors.white,
                    ),
                  ),),),
              Container(
                margin: EdgeInsets.only(left:8),
                padding: EdgeInsets.only(bottom:8,top:8),
                decoration:
                new BoxDecoration(
                  borderRadius: new BorderRadius.all(  Radius.circular(20.0)),
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
                  padding: EdgeInsets.symmetric(horizontal:16),
                  child: Text(

                    'Add\nExpense',
                    style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 22.0,

                      color: Colors.white,
                    ),
                  ),),),*/


            ],),
            SizedBox(height: 30.0),
            Container(
              margin: EdgeInsets.only(right:34),
              padding: EdgeInsets.all(8),
              decoration:
              new BoxDecoration(
                borderRadius: new BorderRadius.only(topRight:  Radius.circular(20.0),bottomRight:   Radius.circular((75))),
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

                  'Life Progress',
                  style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),),),
            Padding(
                padding: EdgeInsets.only(left:8),
                child:AspectRatio(
                  aspectRatio: .90,child:Container(
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
                            padding:EdgeInsets.only(top:16,bottom: 8),
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




                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, left: 6.0),
                              child: LineChart(

                                isShowingMainData ? mainData() : mainData2(),
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
              height: 230.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: eventsList.length + 2,
                shrinkWrap: true,
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

    print(this_event.date);
    print(date2);
    String bottom_text = "at ${_timeFormatter.format(this_event.time)}";
    String count=this_event.duration.toString().substring(0,this_event.duration.toString().length-2) + " mins";
    if (this_event.duration==0) count ="All day";
    if (difference > 0) {
      bottom_text = "In\n${difference} days";
    }

      if (difference>=0 && difference<2 && date2.day==this_event.date.day && date2.isAfter(this_event.date)){
        if(this_event.duration==0 )
        bottom_text="today";
        else {

            bottom_text="today $bottom_text";
        }
      }
      else if(difference>=0 && difference<2 && date2.day+1==this_event.date.day){
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
                  left: 20.0, bottom: 0, top: 20, right: 20),
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
                  left: 20.0, bottom: 20, top: 8, right: 20),
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
  int next(int min, int max) => min + _random.nextInt(max - min);
  Widget _buildBigActivityCard(int index,
      DateTime this_date,double offset) {



    double gauss = exp(-(pow((offset.abs() - 0.5), 2) /
        0.08));

    int id=next(1,1084);




    String date_day=formatter_day.format(this_date);
    String date_month=formatter_month.format(this_date);
    String date_year=formatter_year.format(this_date);
    String date_name=formatter_day_name.format(this_date);

    IconData myIcon=Icons.check_circle;
    int to_show=0;
    if (DateTime_survey[formatterDate.format(this_date)]==0)
      to_show=1;


    String count= "";

    return Transform.scale(
        scale:(index==6)?1:1 / (1 + 0.2*offset.abs()),
        child:GestureDetector(
          onTap: () {
            setState(() {


              current_position=index;

            });


            setState(() {
              TofillDate = this_date;


              show_button=DateTime_survey[formatterDate.format(TofillDate)];

            });
            setState(() {

            });
          },
          child: Padding(

            padding:EdgeInsets.only(),child:Container(
            margin: EdgeInsets.only(right: (index==5)?16:0,top:2,bottom:2),


            child: Stack(

              children: <Widget>[

                Padding(
                  padding: EdgeInsets.all(0),

                  child:Align(

                    alignment: Alignment.topCenter,
                    child: Icon(Icons.add,color:Colors.black.withOpacity(.05),size: 100,),

                  ),),


                Container(



                    decoration: BoxDecoration(
                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                      borderRadius:  BorderRadius.all( Radius.circular(20.0) ),
                      image: DecorationImage(
                          image: NetworkImage(ImagesUrl[index]),
                          fit: BoxFit.fill

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
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black.withAlpha(80),
                            blurRadius: 4)
                      ],
                    )


                ),
                if (to_show==0)Padding(
                  padding: EdgeInsets.only(bottom:30),

                  child:Align(

                    alignment: Alignment.bottomCenter,
                    child: Icon(Icons.check,color:Colors.black.withOpacity(.3),size: 150,),

                  ),),
                Align(

                    alignment: Alignment.topLeft,child:Container(
                  margin: EdgeInsets.only(top:0,left:0),
                  padding: EdgeInsets.only(left:0,top:0),


                  height: 90,
                  width:90,
                  decoration:
                  new BoxDecoration(
                    borderRadius: new BorderRadius.only( topRight:Radius.circular(0.0),topLeft: Radius.circular(20.0), bottomLeft:Radius.circular(0.0),bottomRight:Radius.circular(20.0)),

                    gradient: new LinearGradient(
                        colors: [
                          Colors.white70,
                          Colors.white38,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.00),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),

                  ),





                )),
                Padding(
                  padding: EdgeInsets.only(left: 20,top:80),

                  child:Align(

                    alignment: Alignment.topLeft,
                    child: Text(
                      date_year,
                      textAlign: TextAlign.center,
                      style: TextStyle(

                          color: Colors.black.withOpacity(.05) ,
                          fontFamily: 'ZillaSlab',
                          fontSize:50,
                          shadows: [
                            Shadow(
                              blurRadius: 60.0,
                              color: Colors.white,
                              offset: Offset(1.0,1.0),
                            ),
                          ],

                          fontWeight: FontWeight.w500),

                    ),),
                ),

                Transform.translate(
                    offset: Offset(100 * gauss * offset.sign, 0),
                    child:  Padding(
                      padding: EdgeInsets.only(left: 20,top:10),

                      child:Align(

                        alignment: Alignment.topLeft,
                        child: Text(
                          date_day,
                          textAlign: TextAlign.center,
                          style: TextStyle(

                              color: Colors.black87 ,
                              fontFamily: 'ZillaSlab',
                              fontSize: 26,
                              shadows: [
                                Shadow(
                                  blurRadius: 35.0,
                                  color: Colors.black,
                                  offset: Offset(1.0,1.0),
                                ),
                              ],

                              fontWeight: FontWeight.bold),

                        ),),
                    )),
                if (index==6)Transform.translate(
                    offset: Offset(-20 * gauss * offset.sign, 0),
                    child:  Padding(
                      padding: EdgeInsets.only(left: 20,top:100),

                      child:Align(

                        alignment: Alignment.topLeft,
                        child: Text(
                          "Today",
                          textAlign: TextAlign.center,
                          style: TextStyle(

                            color: Colors.white70 ,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.bold,
                            wordSpacing: 3,
                            fontSize:26,
                            shadows: [
                              Shadow(
                                blurRadius: 35.0,
                                color: Colors.black,
                                offset: Offset(1.0,1.0),
                              ),
                            ],

                          ),

                        ),),
                    )),
                Padding(
                  padding: EdgeInsets.only(left:20,top:45),

                  child:Align(

                    alignment: Alignment.topLeft,
                    child: Text(
                      date_month,
                      textAlign: TextAlign.center,
                      style: TextStyle(

                          color: Colors.black87 ,
                          fontFamily: 'ZillaSlab',
                          fontSize: 22,
                          shadows: [
                            Shadow(
                              blurRadius: 20.0,
                              color: Colors.white,
                              offset: Offset(1.0,1.0),
                            ),
                          ],

                          fontWeight: FontWeight.w500),

                    ),),
                ),


                /* Padding(
    padding: EdgeInsets.only(left: 20,top:125),

    child:Align(

    alignment: Alignment.topLeft,
    child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("10", style: TextStyle( fontFamily: 'ZillaSlab',color:Colors.white.withOpacity(.9),fontSize: 30, fontWeight: FontWeight.bold),),


                Text("Questions", style: TextStyle( fontFamily: 'ZillaSlab',color:Colors.black.withOpacity(.6),fontSize: 22, shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.white,
                    offset: Offset(1.0,1.0),
                  ),
                ],),),
              ],
            ),)),*/


                if (to_show==0)Align(

                    alignment: Alignment.bottomRight,child:Container(
                    margin: EdgeInsets.only(top:0,left:0),
                    padding: EdgeInsets.only(left:0,top:0),


                    height: 50,
                    width:80,
                    decoration:
                    new BoxDecoration(
                      borderRadius: new BorderRadius.only( topRight:Radius.circular(0.0),topLeft: Radius.circular(20.0), bottomLeft:Radius.circular(0.0),bottomRight:Radius.circular(20.0)),

                      gradient: new LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.black87,                      ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),

                    ),


                    child:Icon(Icons.arrow_forward,size: 40,color: Colors.white54,)


                )),
                if (to_show==1 && offset==0)Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child:Align(


                        alignment: Alignment.bottomCenter,

                        child:FadeAnimation(.8, Container(child:Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedBuilder(
                            animation: rippleAnimation,
                            builder: (context, child) => Container(
                              width: rippleAnimation.value/1.5,
                              height: rippleAnimation.value/1.5,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black54.withOpacity(.4)
                                ),
                                child: InkWell(
                                  onTap: ()  {
                                    Navigator.push(context,
                                        FadeRoute(page: DisplayQuestions(changeTheme: setTheme,setDate: TofillDate,)));
                                   // scaleController.forward();
                                  },
                                  child: AnimatedBuilder(
                                    animation: scaleAnimation,
                                    builder: (context, child) => Transform.scale(
                                      scale: scaleAnimation.value,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white70
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )))


                    )),






              ],
            ),
          ),),
        ));
  }
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
   if (prefs.getString('google_image')!=null) google_url=prefs.getString('google_image');
   getStarted();
 }


  Split_text(){
    StringBuffer sb = new StringBuffer();
    sb.write("No guts, no story. Chris Brady\nMy life is my message. Mahatma Gandhi\nScrew it, let’s do it. Richard Branson\nBoldness be my friend. William Shakespeare\nKeep going. Be all in. Bryan Hutchinson\nMy life is my argument. Albert Schweitzer\nDream big. Pray bigger.\nLeave no stone unturned. Euripides\nFight till the last gasp. William Shakespeare\nStay hungry. Stay foolish. Steve Jobs\nBroken crayons still color.\nAnd so the adventure begins.\nIf you want it, work for it.\nYou can if you think you can. George Reeves\nWhatever you are, be a good one. Abraham Lincoln\nGrow through what you go through.\nDo it with passion or not at all.\nShe believed she could, so she did.\nThe past does not equal the future. Tony Robbins\nAt the end of hardship comes happiness.\nDon’t dream your life, live your dream.\nIf it matters to you, you’ll find a way. Charlie Gilkey\nForget about style; worry about results. Bobby Orr\nWhatever you do, do with all your might. Marcus Tullius Cicero\nDream without fear. Love without limits.\nEvery noble work is at first impossible. Thomas Carlyle (See also: hard work quotes)\nIf you’re going through hell, keep going. Winston Churchill\nWe are twice armed if we fight with faith. Plato\nThe wisest mind has something yet to learn. George Santanaya\nOpen your mind. Get up off the couch. Move. Anthony Bourdain\nBe faithful to that which exists within yourself. André Gide\nPersistence guarantees that results are inevitable. Paramahansa Yogananda\nIn life you need either inspiration or desperation. Tony Robbins\nI would rather die on my feet than live on my knees. Euripides\nThe true success is the person who invented himself. Al Goldstein\nLet him that would move the world first move himself. Socrates\nGo forth on your path, as it exists only through your walking. Augustine of Hippo\nWe can do anything we want to if we stick to it long enough. Helen Keller\nIt is better to live one day as a lion, than a thousand days as a lamb. Roman proverb\nLife is fragile. We’re not guaranteed a tomorrow so give it everything you’ve got. Tim Cook\nThe two most important days in your life are the day you are born and they day you find out why. Mark Twain\nFall seven times, stand up eight. Japanese proverb\nYou are loved.\nActually, you can.\nYes! Yes! You can do it!\nFocus on the good.\nYou are doing great.\nWe rise by lifting others.\nBe happy. Be bright. Be you.\nEvery day is a second chance.\nYou are amazing. Remember that.\nDarling, you are a work of art.\nEach day provides its own gifts. Marcus Aurelius\nHappiness looks gorgeous on you.\nYou are capable of amazing things.\nYou are somebody’s reason to smile.\nNothing is worth more than this day. Johann Wolfgang von Goethe\nThink like a proton, always positive.\nYou are stronger than you think you are.\nFocus on the journey, not the destination. Greg Anderson\nBelieve you can and you’re halfway there. Theodore Roosevelt\nOnce you choose hope, anything’s possible. Christopher Reeve\nYou make mistakes. Mistakes don’t make you.\nBreathe. It’s just a bad day, not a bad life.\nStart every day off with a smile and get it over with. W. C. Fields\nIf you want to lift yourself up, lift up someone else. Booker T. Washington\nIt’s okay to not be okay as long as you are not giving up.\nIf you feel like giving up, look back at how far you’ve come.\nEvery day may not be good but there is something good in every day.\nDon’t go through life, grow through life. Eric Butterworth\nYou are amazing. As you are. Stronger than you know. More beautiful than you think. Tia Sparkles\nEverything is going to be okay in the end. If it’s not the okay, it’s not the end.\nGo!\nLove.\nBegin.\nLet go.\nBreathe.\nSlow down.\nLet it be.\nGo for it.\nI love you.\nKeep going.\nChoose joy.\nEnjoy today.\nC’est la vie.\nChoose happy.\nKeep it cool.\nTake it easy.\nBe in the now.\nLive the moment.\nChoose to shine.\nNo pain, no gain.\nDo it. With love.\nIt is what it is.\nLove conquers all.\nKeep your chin up.\nFollow your heart.\nDon’t rush things.\nYou only live once.\nNever stop dreaming.\nNow is all you have.\nKeep moving forward.\nThis too shall pass.\nEvery moment matters.\nLove more. Worry less.\nDust settles. I don’t.\nNothing lasts forever.\nWork hard. Stay humble.\nEnjoy the little things.\nThe best is yet to come.\nBetter things are coming.\nCollect moments – not things.\nFeel the fear and do it anyway.\nLife is too short to learn German. Oscar Wilde\nWhy do they put pizza in a square box?\nDo crabs think we walk sideways? Bill Murray\nDon’t be humble, you’re not that great. Indira Gandhi (See also: confidence quotes)\nI intend to live forever. So far, so good. Steven Wright\nMy life feels like a test I didn’t study for.\nWhy is there an expiration date on sour cream? George Carlin\nI drive way too fast to worry about cholesterol. Steven Wright\nA day without sunshine is like, you know, night. Steve Martin\nIn heaven, all the interesting people are missing. Friedrich Nietzsche\nThe last woman I was in was the Statue of Liberty. Woddy Allen\nWomen want love to be a novel. Men, a short story. Daphne du Maurier\nGuests, like fish, begin to smell after three days. Benjamin Franklin\nWhoever named it necking is a poor judge of anatomy. Groucho Marx\nChange is inevitable – except from a vending machine. Robert C. Gallagher\nI bet giraffes don’t even know what farts smell like. Bill Murray\nEvery novel is a mystery novel if you never finish it.\nWhy is the slowest traffic of the day called ‘rush hour’?\nIt’s easy to quit smoking. I’ve done it hundreds of times. Mark Twain\nThe risk I took was calculated, but man, I am bad at math.\nI couldn’t repair your brakes, so I made your horn louder. Steven Wright\nDo not read the next sentence. You little rebel, I like you.\nJust when I discovered the meaning of life, they changed it. George Carlin\nAlways borrow money from a pessimist. He won’t expect it back. Oscar Wilde\nIf truth is beauty, how come no one has their hair done in a library? Lily Tomlin\nI love deadlines. I love the whooshing noise they make as they go by. Douglas Adams\nI never feel more alone than when I’m trying to put sunscreen on my back. Jimmy Kimmel\nThe key to eating healthy is not eating any food that has a TV commercial. Mike Birbiglia\nI’ve got to keep breathing. It’ll be my worst business mistake if I don’t. Steve Martin\nThere are three types of people in this world: those who can count, and those who can’t.\nThe closest a person ever comes to perfection is when he fills out a job application form.\nNo rain. No flowers.\nShine like the stars.\nYou make my heart smile.\nYou will forever be my always.\nYour voice is my favorite sound.\nThrow kindness around like confetti.\nMy favorite place is inside your hug.\nI still fall in love with you every day.\nYou smile, I smile. That’s how it works.\nShe was a rainbow, but he was color blind.\nWe were born to be real, not to be perfect. Liggy Webb\nWhen I count my blessings, I count you twice.\nIf you are not too long, I will wait here for you all my life. Oscar Wilde\nWhen it rains look for rainbows. When it’s dark look for stars.\nTo the world you may be one person, but to one person you are the world. Bill Wilson\nI love you not only for what you are, but for what I am when I am with you. Ray Croft\nBe a voice. Not an echo.\nSeek the seeker. Ramana Maharshi\nEvery wall is a door. Ralph Waldo Emerson\nThe only truth is music. Jack Kerouac\nSilence is an answer too.\nIf youth knew; if age could. Sigmund Freud\nTime is the soul of this world. Pythagoras\nStars can’t shine without darkness.\nHe not busy being born is busy dying. Bob Dylan\nIt takes a long time to become young. Pablo Picasso\nBe who you needed when you were young.\nInnocence is courage and clarity both. Osho\nFind what you love and let it kill you. Charles Bukowski\nSadness flies away on the wings of time. Jean de La Fontaine\nI am not young enough to know everything. Oscar Wilde\nLife is like the ocean, it goes up and down. Vanessa Paradis\nThe eyes are useless when the mind is blind.\nIf you’re not confused, you’re not paying attention. Tom Peters\nYou’ve gotta know what death is to know life. Jack Kevorkian\nDon’t let yesterday take up too much of today. Will Rogers\nForgiveness is giving up hope for a better past.\nBe kind to unkind people, they need it the most.\nCharacter like a photograph, develops in darkness.\nLife is a question and how we live it is our answer. Gary Keller\nGod provides the wind, but man must raise the sails. Augustine of Hippo\nArt is the lie that enables us to realize the truth. Pablo Picasso\nEnlightenment is when a wave realizes it is the ocean.\nThe truth isn’t always beauty, but the hunger for it is. Nadine Gordimer\nThis is your life, and it’s ending one minute at a time.\nHearts are wild creatures, that’s why our ribs are cages.\nLife without love is like a tree without blossoms or fruit. kahlil Gibran\nYour faith can move mountains and your doubt can create them.\nThe knowledge of happiness brings the knowledge of unhappiness. Swami Vivekananda\nThere are those who give with joy, and that joy is their reward. kahlil Gibran\nLife is the car, your heart is the key and God is the chauffeur. Sri Sathya Sai Baba\nYou are not a drop in the ocean. You are the entire ocean in a drop. Rumi\nNormality is a paved road: it’s comfortable to walk, but no flowers grow on it.\nOne is never afraid of the unknown; one is afraid of the known coming to an end. Jiddu Krishnamurti\nWhen you’re happy you enjoy the music, when you’re sad you understand the lyrics.\nWhen you’ve seen beyond yourself, then you may find, peace of mind is waiting there. George Harrison\nYou have to be odd to be number one. Dr. Seuss\nPlease all, and you will please none. Aesop\nThe fool wonders, the wise man asks. Benjamin Disraeli\nA smooth sea never made a skillful sailor.\nPain is inevitable. Suffering is optional.\nA man can’t ride your back unless it’s bent. Martin Luther King Jr\nDon’t raise your voice. Improve your argument.\nChop your own wood and it will warm you twice. Henry Ford\nSome people are so poor, all they have is money. Jack Kerouac\nAll generalizations are false, including this one. Mark Twain\nIt’s not what you look at that matters, it’s what you see. Henry David Thoreau\nWe make a living by what we get, but we make a life by what we give. Winston Churchill\nIt’s so strange that autumn is so beautiful; yet everything is dying.\nIt’s no wonder that truth is stranger than fiction. Fiction has to make sense. Mark Twain\nThe man who wants to lead the orchestra must turn his back on the crowd. James Crook\nWhat counts can’t always be counted; what can be counted doesn’t always count. Albert Einstein\nAs a well-spent day brings happy sleep, so a life well spent brings happy death. Leonardo da Vinci\nLife is not about how fast you run or how high you climb, but how well you bounce. Vivian Komori\nConcentration is the ability to think about absolutely nothing when it is absolutely necessary. Ray Knight\nIt is better to remain silent and be thought a fool than to open one’s mouth and remove all doubt. Mark Twain\nSo it goes. Kurt Vonnegut\nLive the life you’ve dreamed. Henry David Thoreau\nLife is not fair; get used to it. Bill Gates\nLife is a long lesson in humility. James M. Barrie\nLife is a lively process of becoming. Douglas MacArthur\nThe unexamined life is not worth living. Socrates\nLife is largely a matter of expectation. Homer\nAnything worth doing is worth doing slowly. Mae West\nDon’t wait. Life goes faster than you think.\nBe soft. Do not let the world make you hard.\nLife is too important to be taken seriously. Oscar Wilde\nLife is either a daring adventure or nothing. Helen Keller\nThe sole meaning of life is to serve humanity. Leo Tolstoy\nLove the life you live. Lead the life you love. Bob Marley\nLife is accepting what is and working from that. Gloria Naylor\nWe are all, right now, living the life we choose. Peter McWilliams\nNot life, but good life, is to be chiefly valued. Socrates\nLive your life, do your work, then take your hat. Henry David Thoreau\nLife got to be about more than just solving problems. Elon Musk\nLife isn’t as serious as the mind makes it out to be. Eckhart Tolle\nLife is about making an impact, not making an income. Kevin Kruse\nThe quality of life is more important than life itself. Alexis Carrel\nYou have to die a few times before you can really live. Charles Bukowski\nLife shrinks or expands in proportion to one’s courage. Anaïs Nin\nLife is defined more by its risks than by its samenesses. Mary Anne Radmacher\nYou only live once, but if you do it right, once is enough. Mae West\nSometimes life has its way with you when you least expect it. Jon Hamm\nLife isn’t about getting and having, it’s about giving and being. Kevin Kruse\nLife can only be understood backwards; but it must be lived forwards. Soren Kierkegaard\nLife is amazing. Life is fucking messy. Life is what you make of it. Dwayne Johnson\nLife is not a problem to be solved, but a reality to be experienced. Soren Kierkegaard\nNowadays people know the price of everything and the value of nothing. Oscar Wilde\nOnly one life that soon is past, only what’s done with love will last.\nDon’t be afraid your life will end. Be afraid that it will never begin. Grace Hansen\nTo live is the rarest thing in the world. Most people exist, that is all. Oscar Wilde\nLife is like riding a bicycle. To keep your balance, you must keep moving. Albert Einstein\nIn three words I can sum up everything I’ve learned about life: it goes on. Robert Frost\nLife really does begin at forty. Up until then, you are just doing research. Carl Gustav Jung\nThe meaning of life is to find your gift. The purpose of life is to give it away. William Skakespeare\nLife, it seems, is nothing if not a series of initiations, transitions, and incorporations. Alan Dundes\nLife becomes harder for us when we live for others, but it also becomes richer and happier. Albert Schweitzer\nLife is not measured by the number of breaths we take, but by the moments that take our breath away. Maya Angelou\nLife is pure adventure, and the sooner we realize that, the quicker we will be able to treat life as art. Maya Angelou\nI’ve never been poor, only broke. Being poor is a frame of mind. Being broke is only a temporary situation. Mike Todd\nEnjoy the little things in life because one day you’ll look back and realize they were the big things.\nI think people spend too much time staring into screens and not enough time drinking wine, tongue kissing, and dancing under the moon. Rachel Wolchin\nTo love is to act. Victor Hugo\nAll you need is love. John Lennon\nDo all things with love. Og Mandino\nEvery lover is a soldier. Ovid\nWho, being loved, is poor? Oscar Wilde\nSpeak low, if you speak love. William Shakespeare\nLove is the absence of judgment. Dalai Lama\nIf you wished to be loved, love. Seneca\nLove the sinner and hate the sin. Augustine of Hippo\nIf a thing loves, it is infinite. William Blake\nIn true love, you attain freedom. Thich Nhat Hanh\nEconomized love is never real love. Honore De Balzac\nLove does not dominate; it cultivates. Johann Wolfgang von Goethe\nThe more you judge, the less you love. Honore de Balzac\nLovers quarrels are the renewal of love. Terence\nLife is a game and true love is a trophy. Rufus Wainwright\nTo love is to receive a glimpse of heaven. Karen Sunde\nLove is the flower you’ve got to let grow. John Lennon\nIf love appears, boundaries will disappear. Osho\nIntense love does not measure, it just gives. Mother Teresa\nThey do not love that do not show their love. William Shakespeare\nAbsence sharpens love, presence strengthens it. Benjamin Franklin\nThe more you love, the more you become lovable. Osho\nYou cannot save people, you can just love them. Anaïs Nin\nLove is a thing that is full of cares and fears. Ovid\nIt is love alone that gives worth to all things. Teresa of Avila\nLife in abundance comes only through great love. Elbert Hubbard\nLove does not claim possession, but gives freedom. Rabindranath Tagore\nIf you judge people, you have no time to love them. Mother Teresa\nNever love anyone who treats you like you’re ordinary. Oscar Wilde\nYou give me the kind of feeling people write novels about.\nFollow love and it will flee, flee love and it will follow. John Gay\nLove is like the wind, you can’t see it but you can feel it. Nicholas Sparks\nStay away from people who make you feel like you’re hard to love.\nPerhaps one did not want to be loved so much as to be understood. George Orwell\nNever let an opportunity to tell someone how much they mean to you.\nThe quickest way to get someone’s attention is to no longer want it.\nTrue love is like ghosts, which everyone talks about and few have seen. Francois de La Rochefoucauld\nSpread love everywhere you go. Let no one ever come to you without leaving happier. Mother Teresa\nDo what you love. Know your own bone; gnaw at it, bury it, unearth it, and gnaw it still. Henry David Thoreau\nLove needs great courage. It needs great courage because it needs the sacrifice of the ego. Osho\nI don’t have time to worry about who doesn’t like me. I’m too busy loving people who love me.\nDo not seek the because – in love there is no because, no reason, no explanation, no solutions. Anaïs Nin\nWhoever loves becomes humble. Those who love have, so to speak, pawned a part of their narcissism. Sigmund Freud\nYou are enough.\nNobody is perfect.\nMake yourself a priority.\nThis is who the fuck I am. Lady Gaga\nFind yourself, and be that.\nDifferent doesn’t mean wrong.\nWhere’s your will to be weird? Jim Morrison\nAbove all things, reverence yourself. Pythagoras\nSelf-respect knows no considerations. Mahatma Gandhi\nNo one is laughable who laughs at himself. Seneca\nWhy fit in when you were born to stand out? Dr. Seuss\nPersonal love is concentrated universal love. Maharishi Mahesh Yogi\nYou are not designed for everyone to like you.\nAccept who you are. Unless you’re a serial killer. Ellen DeGeneres\nWanting to be someone else is a waste of who you are. Kurt Cobain\nTo love oneself is the beginning of a lifelong romance. Oscar Wilde\nWhatever makes you weird is probably your greatest asset.\nIf you are lonely when you’re alone, you are in bad company. Jean-Paul Sartre\nThe worst loneliness is not to be comfortable with yourself. Mark Twain\nI’m currently under construction. Thank you for your patience.\nThe reward for conformity is that everyone likes you but yourself. Rita Mae Brown\nBe yourself. People don’t have to like you, and you don’t have to care.\nYour value doesn’t decrease based on someone’s inability to see your worth.\nIt is better to be hated for what you are than to be loved for what you are not. André Gide\nI found that there is only one thing that heals every problem, and that is: to know how to love yourself. Louise Hay\nSmile, it’s free therapy.\nFreedom lies in being bold. Robert Frost\nA happy wife is a happy life. Gavin Rossdale\nHappiness lies in perspective.\nBoredom: the desire for desires. Leo Tolstoy\nDo more of what makes you happy.\nHappiness depends upon ourselves. Aristotle\nThe less I needed, the better I felt. Charles Bukowski\nBe happy in the moment, that’s enough. Mother Teresa\nHappiness can exist only in acceptance. George Orwell\nMan is the artificer of his own happiness. Henry David Thoreau\nOne of the keys to happiness is a bad memory. Rita Mae Brown\nTo live happily is an inward power of the soul. Marcus Aurelius\nAnything you’re good at contributes to happiness. Bertrand Russell\nA happy soul is the best shield for a cruel world. Atticus\nThere is no way to happiness. Happiness is the way. Thich Nhat Hanh\nNever expect anything. You’ll never be disappointed.\nWork out your own salvation. Do not depend on others. Buddha\nHappiness is the absence of the pursuit of happiness.\nStay true to you and you will end up incredibly happy.\nHappiness is needing less. Unhappiness is wanting more.\nIf you carry joy in your heart, you can heal any moment. Carlos Santana\nLife’s greatest happiness is to be convinced we are loved. Victor Hugo\nBe happy with what you have. Be excited about what you want. Alan Cohen\nFind ecstasy in life; the mere sense of living is joy enough. Emily Dickinson\nTo be content means that you realize you contain what you seek. Alan Cohen\nHappy are those who dare courageously to defend what they love. Ovid\nWhatever it is, find something to be excited about for tomorrow.\nDoing what you like is freedom. Liking what you do is happiness. Frank Tyger\nThe key to happiness is doing something you like every single day. Victor Pride\nWe don’t laugh because we’re happy – we’re happy because we laugh. William James\nHappiness is not a station you arrive at, but a manner of traveling. Margaret Lee Runbeck\nTrue happiness arises, in the first place, from the enjoyment of one’s self. Joseph Addison\nBase your happiness on taking action toward those goals, not on attaining them. Laura J. Tong\nA lifetime of happiness! No man alive could bear it: it would be hell on earth. George Bernard Shaw\nMost people have never learned that one of the main aims in life is to enjoy it. Samuel Butler\nHappiness cannot be accumulated. What is accumulated is always destructed by time. Jiddu Krishnamurti\nHappiness resides not in possessions, and not in gold, happiness dwells in the soul. Democritus\nA friend is a second self. Aristotle\nChoose people who lift you up. Michelle Obama\nFind your tribe. Love them hard.\nTry to be a rainbow in someone’s cloud.\nLove is blind; friendship closes its eyes. Friedrich Nietzsche\nAny day spent with you is my favorite day.\nThe only way to have a friend is to be one. Ralph Waldo Emerson\nFriends are the siblings God never gave us. Mencius\nRare as is true love, true friendship is rarer. Jean de La Fontaine\nThe good man is the friend of all living things. Mahatma Gandhi\nOne loyal friend is worth ten thousand relatives. Euripides\nTreasure your relationships, not your possessions. Anthony J. D’Angelo\nFriendship always benefits; love sometimes injures. Seneca\nThe language of friendship is not words but meanings. Henry David Thoreau\nFriends? You don’t need more than your few close ones. Alden Tan\nWherever we are, it is our friends that make our world. Henry Drummond\nIt’s a beautiful thing to love others just as they are.\nMy best friend is the one who brings out the best in me. Henry Ford\nIf you have one true friend you have more than your share. Thomas Fuller\nThe real business of life is trying to understand each other. Gilbert Parker\nPeople are lonely because they build walls instead of bridges. Joseph F. Newton\nFriends show their love in times of trouble, not in happiness. Euripides\nA friend is someone who knows all about you and still loves you. Elbert Hubbard\nThe greatest gift of life is friendship, and I have received it. Hubert H. Humphrey\nTrue friendship comes when the silence between two people is comfortable. David Tyson\n‘Enough’ is a feast. Buddhist proverb\nCount your blessings. Og Mandino\nBe obsessively grateful.\nGratitude changes everything.\nGratitude is the sign of noble souls. Aesop\nStart each day with a grateful heart.\nJoy is the simplest form of gratitude. Karl Barth\nExpect nothing and appreciate everything.\nA grateful heart is a magnet for miracles.\nGratitude is riches. Complaint is poverty. Doris Day\nSilent gratitude isn’t very much to anyone. Gertrude Stein\nDon’t forget who was with you from the start.\nWhen one has a grateful heart, life is so beautiful. Roy T. Bennett\nDon’t cry because it’s over, smile because it happened. Ludwig Jacobowski\nGratitude is the fairest blossom which springs from the soul. Henry Ward Beecher\nThe essence of all beautiful art, all great art, is gratitude. Friedrich Nietzsche\nPull over to the side of your journey and look how far you’ve come.\nHow lucky I am to have something that makes saying goodbye so hard. Winnie the Pooh\nGratitude is not only the greatest of virtues, but the parent of all others. Marcus Tullius Cicero\nKindness is wisdom. Philip James Bailey\nKindness is contagious.\nFair and softly goes far. Miguel de Cervantes\nKindness is always beautiful.\nReal kindness seeks no return.\nBe gentle first with yourself. Lama Yeshe\nDo small things with great love. Mother Teresa\nYou will never regret being kind.\nIn the end, only kindness matters.\nFor it is in giving that we receive. Francis of Assisi\nNo one has ever become poor by giving. Anne Frank\nKind people are the best kind of people.\nKindness is not an act, it’s a lifestyle.\nThe more sympathy you give, the less you need. Malcolm S. Forbes\nIn a world where you can be anything, be kind.\nBe kind to unkind people. They need it the most.\nBe kind, for everyone you meet is fighting a hard battle Ian Maclaren\nKindness, I’ve discovered, is everything in life. Isaac Bashevis\nA warm smile is the universal language of kindness. William Arthur Ward\nBe somebody who makes everybody feel like a somebody.\nWe are all different. Don’t judge, understand instead. Roy T. Bennett\nIf you can’t feed a hundred people, then feed just one. Mother Teresa\nWhat wisdom can you find that is greater than kindness? Jean-Jacques Rousseau\nNo act of kindness, no matter how small, is ever wasted. Aesop\nYou can accomplish by kindness what you cannot by force. Publilius Syrus\nThe end result of kindness is that it draws people to you. Anita Roddick\nKindness is like snow – it beautifies everything it covers. kahlil Gibran\nWe shall never know all the good that a simple smile can do. Mother Teresa (See also: simple quotes)\nIt’s nice to be important, but it’s more important to be nice.\nBe kinder to yourself. And then let your kindness flood the world.\nHow do we change the world? One random act of kindness at the time.\nI don’t worry about people misinterpreting my kindness for weakness. Jason Bateman\nWherever there is a human being, there is an opportunity for a kindness. Seneca\nDo less. Be more. Neil Strauss\nYou are your choices. Seneca\nBe true to who you are.\nMy forte is awkwardness. Zach Galifianakis\nWe are what we believe we are. C.S. Lewis\nDo as you wish. Be as you are.\nIt’s ok to put yourself first.\nKnow who you are and know it’s enough.\nThe ultimate mystery is one’s own self. Sammy Davis Jr.\nCharacter is simply habit long continued. Plutarch\nThis above all: to thine own self be true. William Shakespeare\nAdventure is not outside man; it is within. George Eliot\nYou are who you are when nobody’s watching. Stephen Fry\nTo know oneself, one should assert oneself. Albert Camus\nThe things that we love tell us what we are. Thomas Aquinas\nWhen I am silent, I have thunder hidden inside. Rumi\nI may be no better, but at least I am different. Jean-Jacques Rousseau\nThere is no competition because nobody can be me.\nI am not the perishable body, but the eternal Self. Ramana Maharshi\nWhat I’m looking for is not out there, it is in me. Helen Keller\nBeing entirely honest with oneself is a good exercise. Sigmund Freud\nSometimes it’s only madness that makes us what we are.\nAs long as you can find yourself, you’ll never starve. Suzanne Collins\nSelf-esteem is the reputation we acquire with ourselves. Nathaniel Branden\nKnowing others is wisdom, knowing yourself is enlightenment. Lao Tzu\nThe only tyrant I accept in this world is the still voice within. Mahatma Gandhi\nGetting in touch with your true self must be your first priority. Tom Hopkins\nLife isn’t about finding yourself. Life is about creating yourself. George Bernard Shaw\nNever be an imitator, be always original. Don’t become a carbon copy. Osho\nThe best way to find yourself is to lose yourself in the service of others. Mahatma Gandhi\nWhat you get by achieving your goals is not as important as what you become by achieving your goals. Henry David Thoreau\nDreams don’t work unless you do.\nEverything you can imagine is real. Pablo Picasso\nDon’t dream your life, live your dream.\nNothing happens unless first we dream. Carl Sandburg\nThe dreamers are the saviors of the world. James Allen\nIf you give up on your dreams, what’s left? Jim Carrey\nIt may be that those who do most, dream most. Stephen Butler Leacock\nMake your dreams happen. Die with memories, not dreams.\nIf it’s still in your mind, it is worth taking the risk.\nTrust in dreams, for in them is hidden the gate to eternity. kahlil Gibran\nI dream. Sometimes I think that’s the only right thing to do. Haruki Murakami\nDreams are often most profound when they seem the most crazy. Sigmund Freud\nThe biggest adventure you can take is to live the life of your dreams. Oprah Winfrey\nThe future belongs to those who believe in the beauty of their dreams. Eleanor Roosevelt\nYou can’t put a limit on anything. The more you dream, the farther you get. Michael Phelps\nGo confidently in the direction of your dreams and live the life you have imagined. Henry David Thoreau\nYou are beautiful.\nBe beautiful your own way.\nThere is beauty in simplicity.\nTo love beauty is to see light. Victor Hugo\nBeauty awakens the soul to act. Dante Alighieri\nImperfection is beauty, madness is genius.\nBeauty is the promise of happiness. Stendhal\nA beautiful thing is never perfect. Egyptian proverb\nDo something wonderful, people may imitate it. Albert Schweitzer\nEverything has beauty, but not everyone sees it. Confucius\nBeauty always promises, but never gives anything. Simone Weil\nThe human soul needs actual beauty more than bread. D. H. Lawrence\nBeauty begins the moment you decide to be yourself. Coco Chanel\nI’ve never seen a smiling face that was not beautiful.\nIf the path be beautiful, let us not ask where it leads. Anatole France\nThink of all the beauty still left around you and be happy. Anne Frank\nSometimes you need to close your eyes to see the real beauty.\nFor me the greatest beauty always lies in the greatest clarity. Gotthold Ephraim Lessing\nThe truth is not always beautiful, nor beautiful words the truth. Lao Tzu\nI don’t think of all the misery, but of the beauty that still remains. Anne Frank\nYou are imperfect, permanently and inevitably flawed. And you are beautiful. Amy Bloom\nThe best and most beautiful things in the world cannot be seen or even touched – they must be felt with the heart. Helen Keller\nTime is money. Benjamin Franklin\nTime is all we have.\nGood things take time.\nTime eases all things. Sophocles\nLost time is never found again. Benjamin Franklin\nTime brings all things to pass. Aeschylus\nTime is the wisest counsellor of all. Pericles\nTime is but the stream I go fishing in. Henry David Thoreau\nThe trouble is, you think you have time. Jack Kornfield\nNothing is so dear and precious as time. French proverb\nTime you enjoy wasting isn’t wasted time.\nTime is a game played beautifully by children. Heraclitus\nDon’t wait. The time will never be just right. Mark Twain\nTime is what we want most, but what we use worst. William Penn\nIt’s not about having time, it’s about making time.\nThe two most powerful warriors are patience and time. Leo Tolstoy\nIn seed time learn, in harvest teach, in winter enjoy. William Blake\nTaking crazy things seriously is a serious waste of time. Haruki Murakami\nBeing rich is having money, being wealthy is having time. Stephen Swid\nBe patient and tough; one day this pain will be useful to you. Ovid\nYour time is limited, so don’t waste it living someone else’s life. Steve Jobs\nIf you love life, don’t waste time for time is what life is made up of. Bruce Lee\nOwn less. Do more.\nSimplify, simplify. Henry David Thoreau\nOrder brings peace. St-Augustine\nMore life, less rush.\nBuy less, choose well. Vivienne Westwood\nDo more of what matters. Anthony Ongaro\nFewer things. More peace.\nBrevity is the soul of wit. William Shakespeare\nStop the glorification of busy.\nSimplicity is the soul of efficiency. Austin Freeman\nOnce you need less, you will have more.\nI make myself rich by making my wants few. Henry David Thoreau\nOwning less is better than organizing more. Joshua Becker\nHe is richest who is content with the least. Socrates\nLearn to say no without explaining yourself.\nWho is rich? He that rejoices in his portion. Benjamin Franklin\nOwning less is great, wanting less is better. Joshua Becker\nSomeone else is happy with less than you have.\nYou don’t need more space. You need less stuff.\nMinimalism is not deprivation, it’s liberation.\nThe most important things in life aren’t things. Anthony J. D’Angelo\nA place for everything, everything in its place. Benjamin Franklin\nThere is more to life than increasing its speed. Mahatma Gandhi\nIt is quality rather than quantity that matters. Seneca\nThe need for less often result in a life of more. Brian Gardner\nLove people, use things. The opposite never works. The Minimalists\nThe verbal expression of simplicity is ‘no thanks’.\nRemember, you probably already have more than you need.\nOwning things has a cost, and money is the least of it. David Cain\nI was living the American dream and I realized it wasn’t my dream. Joshua Fields Millburn\nStop pressing rewind on things that should be deleted in your life.\nThe more possessions you have, the less time you have to enjoy them.\nMy goal is no longer to get more done, but rather to have less to do. Francine Jay\nBeing a minimalist means you value yourself more than material things.\nGetting all of that stuff out of your life (and your mind) is addictive. Tynan\nInstead of working so hard to make ends meet, work on having fewer ends. Courtney Carver\nIt’s not the daily increase but daily decrease. Hack away at the unessential. Bruce Lee\nMinimalism is not about having less, it’s about making room for more of what matters.\nDon’t buy shit you don’t need, with money you don’t have, to impress people you don’t like. Tyler Durden, Fight Club\nOur economy is based on spending billions to persuade people that happiness is buying things. Philip Slater\nYou don’t need to remove clutter if you don’t let it enter your home or office in the first place. Jeri Dansky\nStop trying to impress others with the things that you own. Begin inspiring them by the way you live.\nWhat is minimalism then? It’s living lightly and gracefully on the earth. It’s uncovering who you are. Francine Jay\nNo ego, no pain. Chien-ju\nWhat we think, we become. Buddha\nI don’t mind what happens. Jiddu Krishnamurti\nHe who is contented is rich. Lao Tzu\nSmile, breathe and go slowly. Thich Nhat Hanh\nEven monkeys fall from trees. Japanese proverb\nConfine yourself to the present. Marcus Aurelius\nEnough is abundance to the wise. Euripides\nInhale the future. Exhale the past.\nHe who knows he has enough is rich. Lao Tzu\nWherever you are, be totally there. Eckart Tolle\nWater which is too pure has no fish. Ts’ai Ken T’an\nThe essence of the Way is detachment. Bodhidharma\nNeither seek nor avoid, take what comes. Swami Sivananda\nIf it comes; let it. If it goes; let it.\nBe like a tree. Let the dead leaves drop. Rumi\nThe greatest achievement is selflessness.\nIf all you can do is crawl, start crawling. Rumi\nThere are no problems without consciousness. Carl Gustav Jung\nThe quieter you become, the more you can hear. Baba Ram Dass\nIf you are too busy to laugh, you are too busy.\nWhen the disciple is ready, the master appears. Osho\nEverything has beauty, but not everyone sees it. Confucius\nThe greatest effort is not concerned with results.\nGive this moment your attention – and affection. Alex Blackwell\nWho looks outside dreams, who looks inside awakens. Carl Gustav Jung\nThere is no path to happiness. Happiness is the path. Buddha\nAwareness is freedom, it brings freedom, it yields freedom. Jiddu Krishnamurti\nThe only way you can endure your pain is to let it be painful. Shunryu Suzuki\nBe not afraid of going slowly, be afraid only of standing still. Chinese proverb\nContentment comes not so much from great wealth as from few wants. Epictetus\nTension is who you think you should be, relaxation is who you are. Chinese proverb\nThe softest things in the world overcome the hardest things in the world. Lao Tzu\nDo not listen with the intent to reply. But with the intent to understand.\nA gem cannot be polished without friction, nor a man perfected without trials. Chinese proverb\nYou have succeeded in life when all you really want is only what you really need. Vernon Howard\nOpen your mouth only if what you are going to say is more beautiful than silence.\nLife is now. There was never a time when your life was not now, nor will there ever be. Eckhart Tolle\nIf you are depressed, you are living in the past. If you are anxious, you are living in the future. If you are at peace, you are living in the present. Lao Tzu\nPeace is every step. Thich Nhat Hahn\nMy aim in life is not to judge. Jeanne Moreau\nA smile is the beginning of peace. Mother Teresa\nNonviolence is a weapon of the strong. Mahatma Gandhi\nPeace is the only battle worth waging. Albert Camus\nFreedom from desire leads to inner peace. Lao Tsu\nIt is possible to choose peace over worry.\nThere is no way to peace, peace is the way. A.J. Muste\nPeace is costly but it is worth the expense. African proverb\nForgive, son; men are men; they needs must err. Euripides\nPeace comes from within. Do not seek it without. Buddha\nLet nothing and no one disturb your inner peace. Luminita Saviuc\nPeace and justice are two sides of the same coin. Dwight D. Eisenhower\nPeace of mind comes from not wanting to change others. Gerald Jampolsky\nDon’t hurry. Don’t worry. Do your best and let it rest.\nTo the mind that is still, the whole universe surrenders. Lao Tzu\nI know but one freedom and that is the freedom of the mind. Antoine de Saint-Exupery\nLet loose of what you can’t control. Serenity will be yours.\nHe is happiest, be he king or peasant, who finds peace in his home. Johann Wolfgang von Goethe\nForgiveness does not change the past, but it does enlarge the future. Paul Boese\nWe must learn to live together as brothers or perish together as fools. Martin Luther King Jr\nPeace cannot be kept by force; it can only be achieved by understanding. Albert Einstein\nWhen the power of love overcomes the love of power the world will know peace. Jimi Hendrix\nThe ability to observe without evaluating is the highest form of intelligence. J Krishnamurti\nTime discovers truth. Seneca\nTruth is a pathless land. Jiddu Krishnamurti\nSeek truth and you will find a path. Frank Slaughter\nAdversity is the first path to truth. Lord Byron\nFalsehood is easy, truth so difficult. George Eliot\nTruth is on the side of the oppressed. Malcolm X\nThe object of the superior man is truth. Confucius\nBe truthful, nature only sides with truth. Adolf Loos\nThere is no truth. There is only perception. Gustave Flaubert\nWe have art in order not to die of the truth. Friedrich Nietzsche\nMan is the only creature that refuses to be what he is. Albert Camus\nRather than love, than money, than fame, give me truth. Henry David Thoreau\nWe search something permanent, something that will last. Jiddu Krishnamurti\nSeek not greatness, but seek truth and you will find both. Horace Mann\nTo believe in something, and not to live it, is dishonest. Mahatma Gandhi\nIf you tell the truth, you don’t have to remember anything. Mark Twain\nIn a time of deceit telling the truth is a revolutionary act. George Orwell\nThe truth is not for all men, but only for those who seek it. Ayn Rand\nThe truth will set you free, but first it will make you miserable. James A. Garfield\nDo not love leisure. Waste not a minute. Be bold. Realize the Truth, here and now. Swami Sivananda\nTruth is always new. Truth is seeing a smile, a person, life, like if it was the first time. Jiddu Krishnamurti\nA man who is protecting himself constantly through knowledge is obviously not a truth-seeker. Jiddu Krishnamurti\nBe who you are and say what you feel, because those who mind don’t matter, and those who matter don’t mind. Bernard M. Baruch\nKnow thyself. Socrates\nWisdom begins in wonder. Socrates\nIf you judge, investigate. Seneca\nDoubt grows with knowledge. Johann Wolfgang von Goethe\nEverything popular is wrong. Oscar Wilde\nWhat you seek is seeking you. Rumi\nObserve all men, thyself most. Benjamin Franklin\nDoubt is the origin of wisdom. Augustine of Hippo\nNature does nothing uselessly. Aristotle\nListen to many, speak to a few. William Shakespeare\nA closed mouth catches no flies. Miguel de Cervantes\nNever confuse motion with action. Benjamin Franklin\nI’m wise because I’ve been foolish.\nDo what is right, not what is easy.\nSilence is true wisdom’s best reply. Euripides\nWisdom comes only through suffering. Aeschylus\nAn overflow of good converts to bad. William Shakespeare\nTo find yourself, think for yourself. Socrates\nMy life is perfect even when it’s not. Ellen DeGeneres\nIn teaching others we teach ourselves.\nMaturity comes with experience, not age.\nPain is inevitable. Suffering is optional. Haruki Murakami\nIt is better to travel well than to arrive. Buddha\nWhat’s meant to be will always find a way.\nLove is too young to know what conscience is. William Shakespeare\nWisely, and slow. They stumble that run fast. William Shakespeare\nWith wisdom, comes the desire for simplicity.\nWise is he who collects the wisdom of others. Juan Guerra Caceras\nNothing has more strength than dire necessity. Euripides\nHe who would travel happily must travel light. Antoine de Saint-Exupery\nWhen knowledge becomes rigid, it stops living. Anselm Kiefer\nWealth is the ability to fully experience life. Henry David Thoreau\nMemory is the old, and it is afraid of the new. Osho\nNothing external to you has any power over you. Ralph Waldo Emerson\nThe most certain sign of wisdom is cheerfulness. Michel de Montaigne\nNot being able to govern events, I govern myself. Michel de Montaigne\nThe mind is everything. What you think you become. Buddha\nHonesty is the first chapter in the book of wisdom. Thomas Jefferson\nWho looks outside, dreams; who looks inside, awakes. Carl Gustav Jung\nI don’t like that man. I must get to know him better. Abraham Lincoln\nComplete abstinence is easier than perfect moderation. Augustine of Hippo\nWhen you give yourself, you receive more than you give. Antoine de Saint-Exupery\nIf you think you know the answer, you’re far from wise. Trent Hamm\nJudge a man by his questions rather than by his answers. Voltaire\nWe all make choices, but in the end our choices make us.\nI am not what happened to me, I am what I choose to become. Carl Gustav Jung\nHe who knows that enough is enough will always have enough. Lao Tzu\nHe who knows, does not speak. He who speaks, does not know. Lao Tzu\nThe wisest man is generally he who thinks himself the least so. Nicolas Baileau\nNever let the things you want make you forget the things you have.\nNothing ever goes away until it has taught us what we need to know.\nAs far as I’m concerned, I prefer silent vice to ostentatious virtue. Albert Einstein\nTo become a spectator of one’s own life is to escape the suffering of life. Oscar Wilde\nInsanity is doing the same thing, over and over again, but expecting different results. Albert Einstein\nWhenever you find yourself on the side of the majority, it is time to pause and reflect. Mark Twain\nCourage, dear heart. C.S. Lewis\nFrom caring comes courage. Lao Tzu\nDon’t stop until you’re proud.\nCourage doesn’t always roar. Mary Anne Radmacher\nWhat keeps me going is goals. Muhammad Ali\nLife is tough but so you are.\nFortune and love favor the brave. Ovid\nI’m strong because I’ve been weak.\nThe best way out is always through. Robert Frost\nThere is no education like adversity. Benjamin Disraeli\nOne man with courage makes a majority. Andrew Jackson\nI’m fearless because I’ve been afraid.\nThe pain you feel now, will be a strength after some time.\nDiligence is the mother of good fortune. Benjamin Disraeli\nBecause of a great love, one is courageous. Lao Tzu\nTough times never last, but tough people do.\nGreat deeds are usually wrought at great risks. Herodotus\nHe that can have patience can have what he will. Benjamin Franklin\nRock bottom has built more heroes than privilege.\nI’ve never met a strong person with an easy past.\nThings that were hard to bear are sweet to remember. Seneca\nCourage is like a muscle; it is strengthened by use. Ruth Gordon\nIt doesn’t matter how slow you go as long as you don’t stop. Confucius\nRock bottom became the solid foundation on which I rebuilt my life. J. K. Rowling\nThe weak can never forgive. Forgiveness is the attribute of the strong. Mahatma Gandhi\nBe faithful in small things because it is in them that your strength lies. Mother Teresa\nThe world breaks everyone, and afterwards many are strong at the broken places. Ernest Hemingway\nPeople cry, not because they’re weak. It’s because they’ve been strong for too long. Johnny Depp\nLife is very interesting. In the end, some of your greatest pains become your greatest strengths. Drew Barrymore\nPersevere and get it done. George Allen Sr\nNever, never, never give up. Winston Churchill\nMuch effort, much prosperity. Euripides\nSlow and steady wins the race.\nHow long should you try? Until. Jim Rohn\nIf you don’t ask, you don’t get. Stevie Wonder\nNothing worth having comes easy.\nI will not walk backward in life. J. R. R. Tolkien\nIt’s pain that changes our lives. Steve Martin\nOur whole life is solving puzzles. Erno Rubik\nThe struggle is part of the story.\nPersevere in virtue and diligence. Plautus\nLife is short and progress is slow. Gabriel Lippmann\nNo great thing is created suddenly. Epictetus\nGod helps those who help themselves. Benjamin Franklin\nPatience is the companion of wisdom. Augustine of Hippo\nPerseverance, secret of all triumphs. Victor Hugo\nVictory belongs to the most persevering. Napoleon Bonaparte\nI’m a slow walker, but I never walk back. Abraham Lincoln\nIn the middle of difficulty lies opportunity. Albert Einstein\nNever give up on the things that make you smile.\nHe that can have patience can have what he will. Benjamin Franklin\nA lost battle is a battle one thinks one has lost. Jean-Paul Sartre\nPerseverance is a virtue that cannot be understated. Bob Riley\nThe journey of a thousand miles begins with one step. Lao Tzu\nYou may see me struggle, but you will never see me quit.\nPerseverance is failing 19 times and succeeding the 20th. Julie Andrews\nThankfully, persistence is a great substitute for talent. Steve Martin\nYou get credit for what you finished, not what you started.\nI was taught the way of progress is neither swift nor easy. Marie Curie\nPersistence is to the character of man as carbon is to steel. Napoleon Hill\nA man will fight harder for his interests than for his rights. Napoleon Bonaparte\nAnyone who has ever made anything of importance was disciplined. Andrew Hendrixson\nNothing is permanent in this wicked world, not even our troubles. Charlie Chaplin\nNo matter how you feel, get up, dress up, show up and never give up.\nDon’t quit. Suffer now and live the rest of your life as a champion. Muhammad Ali\nDifficult things take a long time, impossible things a little longer.\nIt’s not that I’m so smart, it’s just that I stay with problems longer. Albert Einstein\nA river cuts through a rock not because of its power but its persistence.\nThe will to persevere is often the difference between failure and success. David Sarnoff\nAmbition is the path to success. Persistence is the vehicle you arrive in. Bill Bradley\nPerseverance is not a long race; it is many short races one after the other. Walter Elliot\nPatience, persistence and perspiration make an unbeatable combination for success. Napoleon Hill\nThrough perseverance many people win success out of what seemed destined to be certain failure. Benjamin Disraeli\nPerseverance is the hard work you do after you get tired of doing the hard work you already did. Newt Gingrich\nIt is the cheerful mind that is persevering. It is the strong mind that hews its way through a thousand difficulties. Swami Sivananda\nBelief creates the actual fact. William James\nBelieving requires action. James E. Faust\nPrayer is man’s greatest power. W. Clement Stone\nTo me faith means not worrying. John Dewey\nSet goals. Say prayers. Work hard.\nFaith is spiritualized imagination. Henry Ward Beecher\nEmpty yourself and let God fill you.\nGod gives where he finds empty hands. Augustine of Hippo\nFaith is the quiet cousin of courage. Judith Hanson Lasater\nFaith makes things possible, not easy.\nIn art as in love, instinct is enough. Anatole France\nA man of courage is also full of faith. Marcus Tullius Cicero\nFaith: not wanting to know what is true. Friedrich Nietzsche\nUnless you believe, you will not understand. Augustine of Hippo\nI believe life takes us where we need to be. Sasha Alexander\nThe Lord is greater than the giants you face. John 4.9\nIf you’re praying about it. God is working on it.\nLive your beliefs and you can turn the world around. Henry David Thoreau\nPrayer is to be in love, to be in love with the whole. Osho\nDo not pray for an easier life, pray to be a stronger man. John F. Kennedy\nFaith is not something to grasp, it is a state to grow into. Mahatma Gandhi\nPrayer is the key of the morning and the bolt of the evening. Mahatma Gandhi\nWhen someone shows you who they are, believe them the first time. Maya Angelou\nLet life happen to you. Believe me: life is in the right, always. Rainer Maria Rilke\nFaith is believing in something when common sense tells you not to.\nWe must accept finite disappointment, but never lose infinite hope. Martin Luther King Jr\nFaith is taking the first step even when you don’t see the whole staircase. Martin Luther King Jr\nPursue some path, however narrow and crooked, in which you can walk with love and reverence. Henry David Thoreau\nHumor comes from self-confidence. Rita Mae Brown\nI think you should just go for it.\nWe are always the same age inside. Gertrude Stein\nTrust is the greatest intelligence. Osho\nConfidence is one of the sexiest things. Katherine Jenkins\nYou have to laugh, especially at yourself. Madonna\nConfidence is a stain they can’t wipe off. Lil Wayne\nAll anything takes, really, is confidence. Rachel Ward\nCoffee in one hand. Confidence in the other.\nConfidence comes from discipline and training. Robert Kiyosaki\nA certain death of an artist is overconfidence. Robin Trower\nYour energy introduces you before you even speak.\nAct as if what you do makes a difference. It does. William James\nConfidence is contagious. So is lack of confidence. Vince Lombardi\nAs is our confidence, so is our capacity. William Hazlitt\nJust trust yourself, then you will know how to live. Johann Wolfgang von Goethe\nThe most beautiful thing you can wear is confidence. Blake Lively\nTalk to yourself like you would to someone you love. Brene Brown\nCourage is a mean with regard to fear and confidence. Aristotle\nA tiger doesn’t lose sleep over the opinion of sheep.\nStop doubting yourself, work hard and make it happen.\nWith confidence, you have won before you have started. Marcus Garvey\nNo one can make you feel inferior without your consent. Eleanor Roosevelt\nConfidence cannot find a place wherein to rest in safety. Virgil\nAs soon as you trust yourself, you will know how to live. Johann Wolfgang von Goethe\nConfidence is the most important single factor in this game. Jack Nicklaus\nSelf-confidence is the first requisite to great undertakings. Samuel Johnson\nAll you need is ignorance and confidence and the success is sure. Mark Twain\nConcentration comes out of a combination of confidence and hunger. Arnold Palmer\nI’m always impressed by confidence, kindness and a sense of humor. Tamara Mellon\nNothing builds self-esteem and self-confidence like accomplishment. Thomas Carlyle\nThe hardest step she ever took was to blindly trust in who she was. Atticus\nInaction breeds doubt and fear. Action breeds confidence and courage. Dale Carnegie\nThe circulation of confidence is better than the circulation of money. James Madison\nI have great faith in fools – self-confidence my friends will call it. Edgar Allan Poe\nToo many people overvalue what they are not and undervalue what they are. Malcolm S. Forbes\nConfidence in the goodness of another is good proof of one’s own goodness. Michel de Montaigne\nNever bend your head. Always hold it high. Look the world straight in the face. Helen Keller\nConfidence is not ‘they will like me’. Confidence is ‘I’ll be fine if they don’t’.\nI do not believe in taking the right decision, I take a decision and make it right. Muhammad Ali Jinnah\nThe more you know who you are and what you want, the less you let things upset you.\nMy confidence comes from the daily grind – training my butt off day in and day out. Hope Solo\nA ‘No’ uttered from the deepest conviction is better than a ‘Yes’ merely uttered to please, or worse, to avoid trouble. Mahatma Gandhi\nGo wild, for a while.\nCreativity takes courage. Henri Matisse\nAn artist is an explorer. Henri Matisse\nImagination rules the world. Napoleon Bonaparte\nBe anything but predictable.\nCreativity is not a competition.\nZeal will do more than knowledge. William Hazlitt\nPure logic is the ruin of the spirit. Antoine de Saint-Exupery\nWithout freedom, there is no creation. Jiddu Krishnamurti\nCreativity comes from a conflict of ideas. Donatella Versace\nThe man who has no imagination has no wings. Muhammad Ali\nBe yourself; everyone else is already taken. Oscar Wilde\nThe worst enemy to creativity is self-doubt. Sylvia Plath\nThe chief enemy of creativity is good sense. Pablo Picasso\nYou were born an original, don’t die a copy.\nI like nonsense, it wakes up the brain cells. Dr. Seuss\nName the greatest of all inventors. Accident. Mark Twain\nOriginality is nothing but judicious imitation. Voltaire\nCreativity is the greatest rebellion in existence. Osho\nConsistency is the last refuge of the unimaginative. Oscar Wilde\nI begin with an idea, and then it becomes something else. Pablo Picasso\nCreativity requires the courage to let go of certainties. Erich Fromm\nCreativity – like human life itself – begins in darkness. Julia Cameron\nIn order to be irreplaceable one must always be different. Coco Chanel\nMystery is at the heart of creativity. That, and surprise. Julia Cameron\nNo great mind has ever existed without a touch of madness. Aristotle\nA work of art is the unique result of a unique temperament. Oscar Wilde\nThe inner fire is the most important thing mankind possesses. Edith Södergran\nThere is no innovation and creativity without failure. Period. Brene Brown\nTo live a creative life, we must lose our fear of being wrong. Joseph Chilton Pearce\nA man may die, nations may rise and fall, but an idea lives on. John F. Kennedy\nThe true sign of intelligence is not knowledge but imagination. Albert Einstein\nIf you want something new, you have to stop doing something old. Peter F. Drucker\nLearn the rules like a pro, so you can break them like an artist. Pablo Picasso\nIt is better to fail in originality than to succeed in imitation. Herman Melville\nFashion’s not about looking back. It’s always about looking forward. Anna Wintour\nThe monotony and solitude of a quiet life stimulates the creative mind. Albert Einstein\nWhen you do things from your soul, you feel a river moving in you, a joy. Rumi\nI never made one of my discoveries through the process of rational thinking. Albert Einstein\nIf you want something you never had, you have to do something you’ve never done.\nCreativity is allowing yourself to make mistakes. Art is knowing which ones to keep. Scott Adams\nThe doer alone learneth. Friedrich Nietzsche\nBe curious. Not judgmental. Walt Whitman\nSometimes you win, sometimes you learn. John Maxwell\nThey know enough who know how to learn. Henry Adams\nLife is trying things to see if they work.\nThe only source of knowledge is experience. Albert Einstein\nAny fool can know. The point is to understand. Albert Einstein\nI never learned from a man who agreed with me. Robert A. Heinlein\nChange is the end result of all true learning. Leo Buscaglia\nThe important thing is not to stop questioning. Albert Einstein\nThe wise learns many things from their enemies. Aristophanes\nAs long as you live, keep learning how to live. Seneca\nThe noblest pleasure is the joy of understanding. Leonardo da Vinci\nBlessed are the curious for they shall have adventures.\nThe most necessary learning is that which unlearns evil. Antisthenes\nI have no special talent. I am only passionately curious. Albert Einstein\nI am learning all the time. The tombstone will be my diploma. Eartha Kitt\nYour most unhappy customers are your greatest source of learning. Bill Gates\nReal learning comes about when the competitive spirit has ceased. Jiddu Krishnamurti\nIt is only when we forget all our learning that we begin to know. Henry David Thoreau\nI like to listen. I have learned a great deal from listening carefully. Most people never listen. Ernest Hemingway\nEducation is soul crafting. Cornel West\nLove is a better teacher than duty. Albert Einstein\nNine tenths of education is encouragement. Anatole France\nThose who know how to think need no teachers. Mahatma Gandhi\nIt is a wise father that knows his own child. William Shakespeare\nThe highest result of education is tolerance. Helen Keller\nTeaching is the highest form of understanding. Aristotle\nA book is a dream that you hold in your hands. Neil Gaiman\nNothing ever becomes real till it is experienced. John Keats\nA student of life considers the world a classroom. Harvey Mackay\nAn investment in knowledge pays the best interest. Benjamin Franklin\nDon’t let schooling interfere with your education. Mark Twain\nChildren have more need of models than of critics. Carolyn Coats\nEducation is the ability to meet life’s situations. Dr. John G. Hibben\nIf you think education is expensive, try ignorance. Andy McIntyre\nThe great aim of education is not knowledge but action. Herbert Spencer\nA child educated only at school is an uneducated child. George Santayana\nTeachers open the door, but you must enter by yourself. Chinese proverb\nBe brave. Take risks. Nothing can substitute experience. Paulo Coelho\nExperience, travel. These are an education in themselves. Euripides\nThe roots of education are bitter, but the fruit is sweet. Aristotle\nThere is no greater education than one that is self-driven. Neil deGrasse Tyson\nThe mind unlearns with difficulty what it has long learned. Seneca\nEducation is not filling a pail but the lighting of a fire. William Butler Yeats\nI cannot teach anybody anything, I can only make them think. Socrates\nIn this life, all you need is for someone to believe in you. J. R. Martinez\nIf you want happiness for a lifetime, help the next generation. Chinese saying\nThe mind is not a vessel to be filled, but a fire to be kindled. Plutarch\nEducation is not preparation for life; education is life itself. John Dewey\nEducate the children and it won’t be necessary to punish the men. Pythagoras\nThe world is a book and those who do not travel read only one page. Augustine of Hippo\nIt’s not that hard to stay grounded. It’s the way I was brought up. Sidney Crosby\nEducating the mind without educating the heart is no education at all. Aristotle\nTo be successful in life what you need is education, not literacy and degrees. Munshi Premchand\nEducation is what remains after one has forgotten what one has learned in school. Albert Einstein\nIf you want your children to turn out well, spend twice as much time with them, and half as much money. Abigail Van Buren\nMore education quotes\nWork without love is slavery. Mother Teresa\nDon’t be busy, be productive.\nForget shortcuts, work for it.\nWork to become, not to acquire.\nWell done is better than well said.\nGo the extra mile – it’s never crowded.\nYou have to fight to reach your dream. Lionel Messi\nDo your duty today and repent tomorrow. Mark Twain\nWhat is once well done is done forever. Henry David Thoreau\nDon’t mistake activity with achievement. John Wooden\nAll happiness depends on courage and work. Honore de Balzac\nYou are not your resume, you are your work. Seth Godin\nWithout hard work, nothing grows but weeds. Gordon B. Hinckley\nLet the beauty of what you love be what you do. Rumi\nPleasure in the job puts perfection in the work. Aristotle\nI learned the value of hard work by working hard. Margaret Mead\nWork hard in silence. Let success make the noise.\nWork hard, be kind, and amazing things will happen. Conan O’Brien\nWork until you no longer have to introduce yourself.\nThe beginning is the most important part of the work. Plato\nThe reward of one duty is the power to fulfill another. George Eliot\nOnce you do something you love, you never have to work again. Willie Hill\nNearly everything you do is of no importance, but it is important that you do it. Mahatma Gandhi\nDo not hire a man who does your work for money, but him who does it for love of it. Henry David Thoreau\nWithout work, all life goes rotten. But when work is soulless, life stifles and dies. Albert Camus\nNever work just for money or power. They won’t save your soul or help you sleep at night. Marian Wright Edelman\nLeadership is influence. John C. Maxwell\nOne must steer, not talk. Seneca\nWe rise by lifting others.\nA leader is a dealer in hope. Napoleon Bonaparte\nTo lead people walk behind them. Lao Tzu\nA good example is the best sermon. Benjamin Franklin\nAnyone can hold the helm when the sea is calm. Publilius Syrus\nThe speed of the leader is the speed of the gang. Mary Kay Ash\nA ruler should be slow to punish and swift to reward. Ovid\nHe who is not a good servant will not be a good master. Plato\nEach person must live their life as a model for others. Rosa Parks\nLeaders don’t create followers, they create more leaders. Tom Peters\nThe strength of the group is the strength of the leaders. Vince Lombardi\nYou don’t have to hold a position in order to be a leader. Henry Ford\nBuild your reputation by helping other people build theirs. Anthony J. D’Angelo\nLeadership is the capacity to translate vision into reality. Warren Bennis\nWhen you can’t make them see the light, make them feel the heat. Ronald Reagan\nKeep your fears to yourself, but share your courage with others. Robert Louis Stevenson\nTo handle yourself, use your head; to handle others, use your heart. Eleanor Roosevelt\nTo be a leader, bring certainty, to an environment where there isn’t any. Tony Robbins\nExample is not the main thing in influencing others. It is the only thing. Albert Schweitzer\nA genuine leader is not a searcher for consensus but a molder of consensus. Martin Luther King Jr\nMay you live your life as if the maxim of your actions were to become universal law. Immanuel Kant\nIf your actions inspire others to dream more, learn more, do more and become more, you are a leader.\nAttitude is everything. Charles Swindoll\nBe groovy or leave, man. Bob Dylan\nA true man hates no one. Napoleon Bonaparte\nWhat you are comes to you. Ralph Waldo Emerson\nWho sows virtue reaps honor. Leonardo da Vinci\nDon’t find fault, find a remedy. Henry Ford\nA great mind becomes a great fortune. Seneca\nHumor is mankind’s greatest blessing. Mark Twain\nThe greatest remedy for anger is delay. Seneca\nLove all, trust a few, do wrong to none. William Shakespeare\nShowing off is the fool’s idea of glory. Bruce Lee\nLet’s not be narrow, nasty, and negative. T. S. Eliot\nBe someone who you would want to be around. Craig Jarrow\nEnergy and persistence conquer all things. Benjamin Franklin\nA great man is always willing to be little. Ralph Waldo Emerson\nEthics is nothing else than reverence for life. Albert Schweitzer\nHumility is the solid foundation of all virtues. Confucius\nGoodness is the only investment that never fails. Henry David Thoreau\nBe true to your work, your word, and your friend. Henry David Thoreau\nA quick temper will make a fool of you soon enough. Bruce Lee\nStrive not to be a success, but rather to be of value. Albert Einstein\nSwallow your pride, you will not die, it’s not poison. Bob Dylan\nAttention is the rarest and purest form of generosity.\nAttitude is a little thing that makes a big difference. Winston Churchill\nDon’t talk, act. Don’t say, show. Don’t promise, prove.\nRemind yourself that your task is to be a good human being. Marcus Aurelius\nBe careless in your dress if you will, but keep a tidy soul. Mark Twain\nLet us train our minds to desire what the situation demands. Seneca\nReally great people make you feel that you, too, can become great. Mark Twain\nWaste no more time arguing about what a good man should be. Be one. Marcus Aurelius\nBeing both soft and strong is a combination very few have mastered.\nThe firm, the enduring, the simple, and the modest are near to virtue. Confucius\nLife is good when we think it’s good. Life is bad when we don’t think. Douglas Horton\nDrop all your scientific attitudes. Become a little more fluid, more melting, more merging. Osho\nInstead of asking ‘what do I want from life?’, a more powerful question is, ‘what does life want from me?’. Eckhart Tolle\nTo hold a pen is to be at war. Voltaire\nEasy reading is damn hard writing. Nathaniel Hawthorne\nWrite what should not be forgotten. Isabel Allende\nThe first draft of anything is shit. Ernest Hemingway\nAn author, behind his words, is naked. Terri Guillemets\nTears are words that need to be written. Paulo Coelho\nIf it sounds like writing, I rewrite it. Elmore Leonard\nEvery writer I know has trouble writing. Joseph Heller\nThe wastebasket is a writer’s best friend. Isaac Bashevis Singer\nA word after a word after a word is power. Margaret Atwood\nIf I don’t write to empty my mind, I go mad. Lord Byron\nThe best style is the style you don’t notice. Somerset Maugham\nFill your paper with the breathings of your heart. William Wordsworth\nThe scariest moment is always just before you start. Stephen King\nA professional writer is an amateur who didn’t quit. Richard Bach\nYou must stay drunk on writing so reality cannot destroy you. Ray Bradbury\nOne day I will find the right words, and they will be simple. Jack Kerouac\nWe write to taste life twice, in the moment and in retrospect. Anaïs Nin\nThe art of writing is the art of discovering what you believe. Gustave Flaubert\nThere is no greater agony than bearing an untold story inside you. Maya Angelou\nThere is no real ending. It’s just the place where you stop the story. Frank Herbert\nWriting is an exploration. You start from nothing and learn as you go. E. L. Doctorow\nThe purpose of a writer is to keep civilization from destroying itself. Albert Camus\nThe most beautiful things are those that madness prompts and reason writes. André Gide\nThere is nothing to writing. All you do is sit down at a typewriter and bleed. Ernest Hemingway\nWrite with conviction. Pick a side and be bold. And if you’re wrong, admit it. Jeff Goins\nImagination is like a muscle. I found out that the more I wrote, the bigger it got. Philip Jose Farmer\nWe have to continually be jumping off cliffs and developing our wings on the way down. Kurt Vonnegut\nAll you have to do is write one true sentence. Write the truest sentence that you know. Ernest Hemingway\nBetter to write for yourself and have no public, than to write for the public and have no self. Cyril Connolly\nChange before you have to. Jack Welch\nTo say goodbye is to die a little. Raymond Chandler\nThere is nothing so stable as change. Bob Dylan\nIt is in changing that we find purpose. Heraclitus\nEvery day is a chance to change your life.\nIn a gentle way, you can shake the world. Mahatma Gandhi\nOur only security is our ability to change. John Lilly\nChange your thoughts and you change your world. Norman Vincent Peale\nIntelligence is the ability to adapt to change. Stephen Hawking\nNo map is possible because life goes on changing. Osho\nIf it doesn’t challenge you, it won’t change you.\nIt is never too late to be what you might have been. George Eliot\nChange is not merely necessary to life – it is life. Alvin Toffler\nIf you want to make enemies, try to change something. Woodrow Wilson\nFailure is not fatal, but failure to change might be. John Wooden\nYou affect your subconscious mind by verbal repetition. W. Clement Stone\nWhen you blame others, you give up your power to change. Robert Anthony\nIt is not necessary to change. Survival is not mandatory. W. Edwards Deming\nPrayer does not change God, but it changes him who prays. Soren Kierkegaard\nTo improve is to change; to be perfect is to change often. Winston Churchill\nTo change one’s life: Start immediately. Do it flamboyantly. William James\nOnly the new, accepted deeply and totally, can transform you. Osho\nNo matter what people tell you, words and ideas can change the world. Robin Williams\nLife belongs to the living, and he who lives must be prepared for changes. Johann Wolfgang von Goethe\nLet your smile change the world, but don’t let the world change your smile.\nThe world hates change, yet it is the only thing that has brought progress. Charles Kettering\nTo change the world I have to change myself, break away from my conditioning. Jiddu Krishnamurti\nEveryone thinks of changing the world, but no one thinks of changing himself. Leo Tolstoy\nYou can’t start the next chapter of your life if you keep re-reading the last one.\nThe ones who are crazy enough to think they can change the world are the ones who do. Steve Jobs\nThe secret of change is to focus all of your energy, not on fighting the old, but on building the new. Socrates\nMuch effort, much prosperity. Euripides\nMake your life a masterpiece. Brian Tracy\nSuccess is the child of audacity. Benjamin Disraeli\nThe best revenge is massive success. Franck Sinatra\nA goal without a plan is just a wish. Antoine de Saint-Exupery\nI never dream of success. I worked for it. Estee Lauder\nThe harder the battle the sweeter the victory. Bob Marley\nAction is the foundational key to all success. Pablo Picasso\nThe secret of success is constancy of purpose. Benjamin Disraeli\nWhat you think today is what you live tomorrow. Remez Sasson\nSuccess is where preparation and opportunity meet. Bobby Unser\nBe content to act, and leave the talking to others. Baltasar\nSuccess is how high you bounce when you hit bottom. George S. Patton\nNo one knows what to say in the loser’s locker room. Muhammad Ali\nIf you have no critics you’ll likely have no success. Malcolm X\nEverybody pities the weak; jealousy you have to earn. Arnold Schwarzenegger\nThe measure of success is happiness and peace of mind. Bobby Davro\nI couldn’t wait for success, so I went ahead without it. Jonathan Winters\nStart where you are. Use what you have. Do what you can. Arthur Ashe\nBefore anything else, preparation is the key to success. Alexander Graham Bell\nSuccess is the accumulation of small advantages over time. Aaron Lynn\nThe path to success is to take massive, determined action. Tony Robbins\nThe secret of my success is a two word answer: Know people. Harvey S. Firestone\nDon’t let what you cannot do interfere with what you can do. John R. Wooden\nI find that the harder I work, the more luck I seem to have. Thomas Jefferson\nIt’s not whether you get knocked down, it’s whether you get up. Vince Lombardi\nThe successful warrior is the average man, with laser-like focus. Bruce Lee\nI attribute my success to this – I never gave or took any excuse. Florence Nightingale\nMy success isn’t a result of arrogance – it’s a result of belief. Conor McGregor\nSuccess is the sum of small efforts, repeated day in and day out. Robert Collier\nI always wanted to be the best and to get the most out of myself. Sidney Crosby\nSuccess is only meaningful and enjoyable if it feels like your own. Michelle Obama\nSuccess is largely a matter of holding on after others have let go. William Feather\nSuccess usually comes to those who are too busy to be looking for it. Henry David Thoreau\nI want to be the best, so whatever comes with that, I’ll have to accept. Sidney Crosby\nSuccess is nothing more than a few simple disciplines, practiced every day. Jim Rohn\nI’ve failed over and over and over again in my life and that is why I succeed. Michael Jordan\nSuccess is the ability to go from failure to failure without losing your enthusiasm. Winston Churchill\nFear and time are inseparable. Jiddu Krishnamurti\nFear is stupid. So are regrets. Marilyn Monroe\nWhere fear is, happiness is not. Seneca\nTake every chance. Drop every fear.\nFear makes the wolf bigger than he is. German proverb\nFear is the voice of the rational mind.\nDon’t let anyone ever dull your sparkle.\nFear is destructive; love is a creative energy. Osho\nIf it scares you, it might be a good thing to try. Seth Godin\nLimits, like fear, is often an illusion. Michael Jordan\nFear tricks us into living a boring life. Donald Miller\nTo conquer fear is the beginning of wisdom. Bertrand Russell\nPeople living deeply have no fear of death. Anaïs Nin\nI’ll tell you what freedom is to me: no fear.\nFear is temporary. Regrets last forever.\nThe only thing we have to fear is fear itself. Franklin D. Roosevelt\nThinking will not overcome fear but action will. W. Clement Stone\nCuriosity will conquer fear even more than bravery will. James Stephens\nThe constant assertion of belief is an indication of fear. Jiddu Krishnamurti\nEverything you’ve ever wanted is on the other side of fear. George Addair\nNothing in life is to be feared. It is only to be understood. Marie Curie\nThe mind that is always after explanations is an afraid mind. Osho\nSometimes the fear won’t go away, so you’ll have to do it afraid.\nCourage is resistance to fear, mastery of fear, not absence of fear. Mark Twain\nFear has two meanings – Forget Everything And Run or Face Everything And Rise.\nFear is the absence of love. Do something with love, forget about fear. If you love well, fear disappears. Osho\nDon’t worry, be happy. Bobby McFerrin\nWorry less, smile more.\nPray, and let God worry. Martin Luther\nWhat worries you, masters you. John Locke\nAnxiety is the dizziness of freedom. Soren Kierkegaard\nIt’s ok to worry – it means you care.\nThe sovereign cure for worry is prayer. William James\nWorry often gives a small thing a big shadow. Swedish proverb\nMost things I worry about never happen anyway. Tom Petty\nYou can destroy your now by worrying about tomorrow. Janis Joplin\nI never worry about action, but only about inaction. Winston Churchill\nAs a cure for worrying, work is better than whiskey. Thomas A. Edison\nA day of worry is more exhausting than a day of work. John Lubbock\nThe mind that is anxious about the future is miserable. Seneca\nI try not to worry about things I can’t do anything about. Christopher Walken\nWorry is a useless mulling over of things we cannot change. Peace Pilgrim\nWe want predictability, even though it’s impossible to get. Henri Junttila\nThe problem is that worrying doesn’t actually solve anything. Celestine Chua\nLet our advance worrying become advance thinking and planning. Winston Churchill\nThrow off your worries when you throw off your clothes at night. Napoleon Bonaparte\nWorry never robs tomorrow of its sorrow, it only saps today of its joy. Leo Buscaglia\nMy life has been full of terrible misfortunes most of which never happened. Michel de Montaigne\nWorry is like a rocking chair: it gives you something to do but never gets you anywhere. Erma Bombeck\nStumbling is not falling. Malcolm X\nI’ll be ok. Just not today.\nTurn your wounds into wisdom. Oprah Winfrey\nBetter an ‘oops’ than a ‘what if’.\nFailure’s a natural part of life. John Malkovich\nGiving up is the greatest failure. Jack Ma\nNot failure, but low aim, is crime. James Russell Lowell\nIf you never try you’ll never know.\nI never lose. Either I win or I learn.\nMistakes are the portals of discovery. James Joyce\nAvoiding failure is to avoid progress.\nMy reputation grows with every failure. George Bernard Shaw\nFailure is success if we learn from it. Malcolm Forbes\nReward worthy failure – experimentation. Bill Gates\nFailure is a detour, not a dead-end street. Zig Ziglar\nExperience is the name we give to our mistakes. Oscar Wilde\nRemember that failure is an event, not a person. Zig Ziglar\nThere are no mistakes or failures, only lessons. Denis Waitley\nFear of failure has always been my best motivator. Douglas Wood\nFailure is not falling down but refusing to get up. Chinese proverb\nYou have to be able to accept failure to get better. LeBron James\nFailure is not fatal, but failure to change might be. John Wooden\nThere are some defeats more triumphant than victories. Michel de Montaigne\nFailure is the condiment that gives success its flavor. Truman Capote\nSuccess is not a good teacher, failure makes you humble. Shahrukh Khan\nThe sooner you fail, the less afraid you are to fail again. Brendan Baker\nError is just as important a condition of life as truth. Carl Gustav Jung\nOnce you can accept failure, you can have fun and success. Rickey Henderson\nTesting leads to failure, and failure leads to understanding. Burt Rutan\nAmbitious failure, magnificent failure, is a very good thing. Guy Kawasaki\nDo not fear mistakes. You will know failure. Continue to reach out. Benjamin Franklin\nLife is a succession of lessons which must be lived to be understood. Helen Keller\nThe season of failure is the best time for sowing the seeds of success. Paramahansa Yogananda\nYou get knocked down, you get up, brush yourself off, and you get back to work. Barack Obama\nI’d rather be a failure at something I love than a success at something I hate. George Burns\nThe only failure one should fear, is not hugging to the purpose they see as best. George Eliot\nRegrets belong to the past. Marlon Brando\nLife’s too short for regrets. Nicholas Hoult\nRemorse is the poison of life. Charlotte Bronte\nYou will never regret being kind.\nMy head has got regrets, but I haven’t. Frank Bruno\nThere are no regrets in life, just lessons. Jennifer Aniston\nNever regret something that made you smile.\nRegret for wasted time is more wasted time. Mason Cooley\nFear is only temporary. Regrets last forever.\nRegrets are ridiculous, so I don’t regret, no. Nicole Kidman\nRegrets are the natural property of grey hairs. Charles Dickens\nI have often regretted my speech, never my silence. Publilius Syrus\nIn the end, we only regret the chances we didn’t take.\nNever look back unless you are planning to go that way. Henry David Thoreau\nA man is not old until regrets take the place of dreams. John Barrymore\nNever make permanent decisions based on temporary feelings.\nBefore it’s too late, tell them everything you’ve ever wanted to say.\nNever regret anything because one time it was exactly what you wanted.\nI don’t regret a thing I’ve done. I only regret the things I didn’t do. Ingrid Bergman\nBe so good they can’t ignore you. Steve Martin\nBe happy. It drives people crazy.\nSilence is the best reply to a fool.\nThe haters always scream the loudest. Tucker Max\nThey told me I couldn’t. That’s why I did.\nI don’t have to be what you want me to be. Muhammad Ali\nYour opinion of me doesn’t define who I am.\nHustle until your haters ask if you’re hiring.\nLearn not to give a fuck, you will be happier.\nTo refrain from imitation is the best revenge. Marcus Aurelius\nHave you ever met a hater doing better than you?\nI destroy my enemies when I make them my friends. Abraham Lincoln\nYou never look good trying to make someone look bad.\nAsk for help, they laugh. Do it yourself, they hate.\nHaters keep on hating, cause somebody’s gotta do it. Chris Brown\nAlways forgive your enemies. Nothing annoys them so much. Oscar Wilde\nYour love makes me strong, your hate makes me unstoppable. Cristiano Ronaldo\nIf they don’t know you personally, don’t take it personal.\nYou pick up some fans and a handful of haters along the way. Bruno Mars\nThe best revenge is to be unlike him who performed the injury. Marcus Aurelius\nDear haters, I’m flattered that I’m a trending topic in your life.\nWhenever you are confronted with an opponent. Conquer him with love. Mahatma Gandhi\nDon’t worry about those who talk behind your back, they’re behind you for a reason.\nA hater is nothing but a fan. They just don’t know how to express it in positive way. Bar Refaeli\nHaters don’t really hate you, they hate themselves. You’re a reflection of what they wish to be.\nI’m thankful for all those difficult people in my life, they have shown me exactly who I don’t want to be.\nDoubts are death. Maharishi Mahesh Yogi\nInactivity is death. Benito Mussolini\nSecurity is a kind of death. Tennessee Williams\nMy life, my death, my choice. Terry Pratchett\nDeath is a debt we all must pay. Euripides\nDeath is the final wake-up call. Douglas Horton\nDeath, only, renders hope futile. Edgar Rice Burroughs\nEvery man dies. Not every man lives. William Wallace\nDeath is the beginning of something. Edith Piaf\nOur business is with life, not death. George Wald\nI don’t want to die without any scars. Chuck Palahniuk\nDeath is a distant rumor to the young. Andrew A. Rooney\nDeath is just life’s next big adventure. J. K. Rowling\nEnjoy life now – one day you’ll be dead.\nHe who doesn’t fear death dies only once. Giovanni Falcone\nGrief does not change you, it reveals you. John Green\nDeath is frightening, and so is Eternal Life. Mason Cooley\nThe idea is to die young as late as possible. Ashley Montagu\nI would rather die of passion than of boredom. Vincent van Gogh\nYou cannot save people, you can only love them.\nI feel monotony and death to be almost the same. Charlotte Bronte\nIf by my life or death I can protect you, I will. J. R. R. Tolkien\nGuilt is perhaps the most painful companion of death. Coco Chanel\nA man who won’t die for something is not fit to live. Martin Luther King Jr\nA man who lives fully is prepared to die at any time. Mark Twain\nDo not fear death so much but rather the inadequate life. Bertolt Brecht\nThe death of something can become your greatest strength.\nA thing is not necessarily true because a man dies for it. Oscar Wilde\nEven death is not to be feared by one who has lived wisely. Buddha\nI have no fear of death. More important, I don’t fear life. Steven Seagal\nOur dead are never dead to us, until we have forgotten them. George Eliot\nMy fear was not of death itself, but a death without meaning. Huey Newton\nDon’t take life too seriously. You’ll never get out of it alive. Elbert Hubbard\nDeath is the only pure, beautiful conclusion of a great passion. D. H. Lawrence\nTake care of your life and the Lord will take care of your death. George Whitefield\nTo the well-organized mind, death is but the next great adventure. J.K. Rowling\nIf life must not be taken too seriously, then so neither must death. Samuel Butler\nIt is not death or pain that is to be dreaded, but the fear of pain or death. Epictetus\nIt is the unknown we fear when we look upon death and darkness, nothing more. J.K. Rowling\nWe all die. The goal isn’t to live forever, the goal is to create something that will. Chuck Palahniuk");
    String text = sb.toString();



    LineSplitter ls = new LineSplitter();
    inspirations = ls.convert(text);



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
      show: true,
      drawVerticalLine: true,


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
        margin: 4,
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
List<Color> gradientColors = [
  const Color(0xff23b6e6),
  Color.fromARGB(255, 58, 149, 255),
];
LineChartData mainData() {
  return LineChartData(

    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        textStyle:
        const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'MAR';
            case 5:
              return 'JUN';
            case 8:
              return 'SEP';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        textStyle: const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '10k';
            case 3:
              return '30k';
            case 5:
              return '50k';
          }
          return '';
        },
        reservedSize: 28,
        margin: 8,
      ),
    ),
    borderData:
    FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
        ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}
LineChartData mainData2() {
  return LineChartData(

    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d).withOpacity(.1),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d).withOpacity(.1),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        textStyle:
        const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'DEC';
            case 5:
              return 'MAR';
            case 8:
              return 'JUN';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        textStyle: const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '10k';
            case 3:
              return '30k';
            case 5:
              return '50k';
          }
          return '';
        },
        reservedSize: 28,
        margin: 8,
      ),
    ),
    borderData:
    FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d).withOpacity(.4), width: 1)),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 2),
          FlSpot(2.6,5),
          FlSpot(4.9, 2),
          FlSpot(6.8, 2),
          FlSpot(8, 4),
          FlSpot(9.5, 1),
          FlSpot(11, 2),
        ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
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
      Color.fromARGB(255, 58, 149, 255),
    ],
    barWidth:6,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: true,
    ),
  );


  return [
    lineChartBarData1,

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