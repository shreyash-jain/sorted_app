import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:notes/bloc/todo_bloc.dart';
import 'package:notes/components/QuestionCards.dart';
import 'package:notes/components/SecondPage.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/event.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/data/todo.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/ListQuestion.dart';
import 'package:notes/screens/addEvent.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/edit.dart';
import 'package:notes/screens/richedit.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'package:notes/services/local_notications_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_porter/utils/csv_utils.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/cards.dart';

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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  bool isFlagOn = false;
  bool headerShouldHide = false;
  ThemeData theme = appThemeLight;
  List<NotesModel> notesList = [];
  List<NoteBookModel> notebookList = [];
  List<IconData> iconsList=[Icons.add,Icons.archive,Icons.done,Icons.rate_review,Icons.description];
 List<String> below_texs=["one","two","three","four","five"];
  List<EventModel> eventsList = [];
  List<EventModel> eventsListtoday = [];
  List<EventModel> eventsListtom = [];
  TodoBloc todoBloc;
  double page_offset=0;
  HashMap hashMap_today = new HashMap<int, List<Todo>>();
  HashMap hashMap_tom = new HashMap<int, List<Todo>>();
  TextEditingController searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  int _selectedCategoryIndex2=0;
  TabController _tabController;
  bool isSearchEmpty = true;
  final DateFormat _dateFormatter = DateFormat('dd MMM');
  final DateFormat _timeFormatter = DateFormat('h:mm');
  var formatter = new DateFormat('dd MMMM');
  var formatter_date = new DateFormat('dd-MM-yyyy');
  List<Todo> TodaytodoList = [];
  List<Todo> TomtodoList = [];
  String noteid;
  int date_selector=0;
  var fetchedNote;
  NotesModel noteData;
  final notifications = FlutterLocalNotificationsPlugin();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final controller =
  PageController(viewportFraction: 0.6, initialPage: 0, keepPage: false);
  var flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setNotesFromDB();
    setEventsFromDB();

    final settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);


    controller.addListener(() {
      setState(() => page_offset = controller.page); //<-- add listener and set state
    });
    startTime();

    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    if (eventsList!=null)_selectedCategoryIndex=eventsList.length + 1;
    else _selectedCategoryIndex=1;
    if (notesList!=null) _selectedCategoryIndex2=notesList.length +1;
    else _selectedCategoryIndex2=1;
    _tabController.addListener(_handleTabSelection);
  }
  Future onSelectNotification(String payload) async => {

    if (payload.startsWith("note")){

       fetchedNote=await NotesDatabaseService.db.getNoteByIDFromDB(int.parse(payload.substring(4,payload.length))),
       noteData=fetchedNote,
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
      DisplayQuestions(changeTheme: setTheme, payload: payload, )),

  )
};
  get_today_todo() async {

    String formatted_date = formatter_date.format(DateTime.now());
    print("formatted date: "+formatted_date);
    DateModel this_date;
    var fetchedDate = await NotesDatabaseService.db.getDateByDateFromDB(formatted_date);
    setState(() {
      this_date = fetchedDate;
    });
    if (this_date!=null){


      var fetchedEvents = await NotesDatabaseService.db.getEventsOfDateFromDB(this_date.id);

      setState(() {
        eventsListtoday = fetchedEvents;

      });
      for (var i=0;i<eventsListtoday.length;i++){
        if (eventsListtoday[i].todo_id!=0){
          var fetchedtodo= await NotesDatabaseService.db.getTodos(eventsListtoday[i].todo_id);
          setState(() {
            TodaytodoList = fetchedtodo;

          });
          hashMap_today.putIfAbsent(eventsListtoday[i].id, () => TodaytodoList);

        }


      }

    }

  }
  get_tom_todo() async {

    String formatted_date = formatter_date.format(DateTime.now().add(new Duration(days: 1)));
    print("formatted date: "+formatted_date);
    DateModel this_date;
    var fetchedDate = await NotesDatabaseService.db.getDateByDateFromDB(formatted_date);
    setState(() {
      this_date = fetchedDate;
    });
    if (this_date!=null){


      var fetchedEvents = await NotesDatabaseService.db.getEventsOfDateFromDB(this_date.id);


      setState(() {
        eventsListtom = fetchedEvents;

      });
      for (var i=0;i<eventsListtom.length;i++){
        if (eventsListtom[i].todo_id!=0){
          var fetchedtodo= await NotesDatabaseService.db.getTodos(eventsListtom[i].todo_id);
          setState(() {
            TomtodoList = fetchedtodo;

          });
          hashMap_tom.putIfAbsent(eventsListtom[i].id, () => TomtodoList);

        }


      }

    }

  }
  void _handleTabSelection(){
    setState(() {
      date_selector=
      _tabController.index;
    });
  }
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time

    } else {// First time
      prefs.setBool('first_time', false);
      showOngoingNotification(notifications,
          title: 'How was your Day buddy ?', body: 'Lets fill a small survey');
      NoteBookModel quicknote= new NoteBookModel(title: "Quick Notes",notes_num:0,isImportant: true,date:DateTime.now());
     await  NotesDatabaseService.db.addNoteBookInDB(quicknote);

     QuestionModel newQuestion=new QuestionModel(title: "How was my day",type: 0,interval:1,priority: 5,archive: 0,correct_ans: 0,num_ans: 0,ans1:"",ans2: "",ans3: "");
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="How was my work";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="Something Interesting happended today?";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="any Plans for tomorrow ?";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="any Plans for tomorrow ?";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion); newQuestion.title="How was my school/college ?";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion); newQuestion.title="Anything i learned today ?";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion); newQuestion.title="Describe your meditation experience ?";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion); newQuestion.title="Did i buy something new today ?";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion); newQuestion.title="How about today's finances?";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);

      newQuestion.title="How many hours i studied ?";
      newQuestion.type=2;
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="How many hours i wasted ?";
      newQuestion.type=2;
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);newQuestion.title="How many hours i used social media?";
      newQuestion.type=2;
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);newQuestion.title="How many hours i slept today?";
      newQuestion.type=2;
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);newQuestion.title="How many Liters of water i drink ?";
      newQuestion.type=2;
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="How much time did you spend in meditating?";
      newQuestion.type=2;
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);newQuestion.title="Did i had some Helath issues last week ?";
      newQuestion.type=2;
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="Satisfied by my today's work ?";
      newQuestion.type=1;
      newQuestion.num_ans=3;
      newQuestion.ans1="Yes";
      newQuestion.ans2="No";
      newQuestion.ans3="May be";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="Did i excercised today ?";
      newQuestion.type=1;
      newQuestion.num_ans=3;
      newQuestion.ans1="Yes";
      newQuestion.ans2="No";
      newQuestion.ans3="May be";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="Did you meditate today?";
      newQuestion.type=1;
      newQuestion.num_ans=3;
      newQuestion.ans1="Yes";
      newQuestion.ans2="No";
      newQuestion.ans3="May be";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="Had my meals on time ?";
      newQuestion.type=1;
      newQuestion.num_ans=3;
      newQuestion.ans1="Yes";
      newQuestion.ans2="No";
      newQuestion.ans3="May be";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);
      newQuestion.title="Followed my skin regimen today ?";
      newQuestion.type=1;
      newQuestion.num_ans=3;
      newQuestion.ans1="Yes";
      newQuestion.ans2="No";
      newQuestion.ans3="May be";
      await  NotesDatabaseService.db.addLibraryQuestionInDB(newQuestion);

   //  EventModel sampleevent=new EventModel(title:"Sample Event",time:DateTime(2000,1,1,DateTime.now().hour,DateTime.now().minute,DateTime.now().second),content: "Its easy to make events",isImportant:false,date:DateTime.now(),todo_id: 0,);
    }
  }
  setNotesFromDB() async {
    print("Entered setNotes");
    var fetchedNotes =await NotesDatabaseService.db.getAllNotesFromDB();
    setState(() {
      notesList = fetchedNotes;
    });

    for(int i=0;i<notesList.length;i++){
      print(notesList[i].title);
      var fetchedNotebook = await NotesDatabaseService.db.getNotebookByIDFromDB(notesList[i].book_id);
      notebookList.add(fetchedNotebook);
    }



  }
  setEventsFromDB() async {
    print("Entered setEvents");
    var fetchedEvents = await NotesDatabaseService.db.getEventsFromDB();
    setState(() {
      eventsList = fetchedEvents;
    });

    DateTime now=DateTime.now();
    for (int i=0;i<eventsList.length;i++){
      DateTime event_date=new DateTime(eventsList[i].date.year,eventsList[i].date.month,eventsList[i].date.day,eventsList[i].time.hour,eventsList[i].time.minute,eventsList[i].time.second);
      if (event_date.isBefore(now)) eventsList.removeAt(i);
    }
    eventsList.sort((a, b) {
      if (a.isImportant && !b.isImportant) return 0;
      if (a.isImportant && b.isImportant) return 1;
      if (a.date.day==b.date.day && a.date.month==b.date.month && a.date.year==b.date.year){
        return a.time.compareTo(b.time);
      }
      return a.date.compareTo(b.date);
    });
    get_today_todo();
    get_tom_todo();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation:

      FloatingActionButtonLocation.centerDocked,
      drawer: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).canvasColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(


              decoration:
              BoxDecoration(color: Theme.of(context).primaryColor,),
              child: Text("Shubham Jain",style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(bottom: 8,left: 16,right: 16,top: 8),
              trailing: Icon(Icons.keyboard_arrow_right),
              leading: CircleAvatar(
            backgroundColor:  Theme.of(context).primaryColor,
                child:Icon(Icons.book,color: Theme.of(context).backgroundColor),
              ),
              title: Text("All Notebooks",style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            MyDashPage(title: "home",changeTheme: setTheme)));
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(bottom: 8,left: 16,right: 16),
              trailing: Icon(Icons.keyboard_arrow_right),
              leading: CircleAvatar(
                backgroundColor:  Theme.of(context).primaryColor,
                child:Icon(Icons.event,color: Theme.of(context).backgroundColor),
              ),
              title: Text("All Events",style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(bottom: 8,left: 16,right: 16),
              trailing: Icon(Icons.keyboard_arrow_right),
              leading: CircleAvatar(
                backgroundColor:  Theme.of(context).primaryColor,
                child:Icon(Icons.question_answer,color: Theme.of(context).backgroundColor),
              ),
              title: Text("Your Questions",style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                Navigator.push(
                    context,
                    FadeRoute(
                        page: ListQuestion(title: 'Home', changeTheme: setTheme)));
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(bottom: 8,left: 16,right: 16),
              trailing: Icon(Icons.keyboard_arrow_right),
              leading: CircleAvatar(
                backgroundColor:  Theme.of(context).primaryColor,
                child:Icon(Icons.rate_review,color: Theme.of(context).backgroundColor),
              ),
              title: Text("Daily Survey",style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),),
              onTap: () {
                Navigator.push(context,
                    FadeRoute(page: DisplayQuestions(changeTheme: setTheme)));
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(bottom: 8,left: 16,right: 16),
              trailing: Icon(Icons.keyboard_arrow_right),

              leading: CircleAvatar(
                backgroundColor:  Theme.of(context).primaryColor,
                child:Icon(Icons.rate_review,color: Theme.of(context).backgroundColor),
              ),
              title: Text("Habit Analysis",style: TextStyle(
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: "btn1",
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                var time = Time(20, 13, 0);
                var androidPlatformChannelSpecifics =
                AndroidNotificationDetails('repeatDailyAtTime channel id',
                    'repeatDailyAtTime channel name', 'repeatDailyAtTime description');
                var iOSPlatformChannelSpecifics =
                IOSNotificationDetails();
                var platformChannelSpecifics = NotificationDetails(
                    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
                await flutterLocalNotificationsPlugin.showDailyAtTime(
                    1,
                    'How was your Day ?',
                    'Time to fill a small daily survey buddy',
                    time,
                    platformChannelSpecifics);

              },
              label: Text('Add Note'.toUpperCase(),style: TextStyle(color: Colors.white),),
              icon: Icon(Icons.add),
            ),
            FloatingActionButton.extended(
              heroTag: "btn2",
              backgroundColor: Theme.of(context).primaryColor,
              onPressed : () async {
                gotoEditEvent();
              },
              label: Text('Add Event'.toUpperCase(),style: TextStyle(color: Colors.white)),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
      body:ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
            behavior: HitTestBehavior.opaque,
                onTap: () {

                    _scaffoldKey.currentState.openDrawer();

                },
                  child:Container(
                  height: 50.0,
                  width: 50.0,

                  child:Icon(Icons.dashboard),
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),),

                SizedBox(width: 20.0),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SettingsPage(
                                changeTheme: widget.changeTheme)));
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      OMIcons.settings,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade600
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child:Text(

              'Upcoming Events',
              style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color:Color(0xFFAFB4C6),
              ),
            ),),
          Container(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: eventsList.length + 2,
              itemBuilder: (BuildContext context, int index) {

                if (index == 0) {
                  return SizedBox(width: 20.0);
                }
                if (index==eventsList.length + 1){
                  return GestureDetector(


                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });

                      gotoEditEvent();
                    },


                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
                      height: 180.0,
                      width: 125.0,
                      decoration: BoxDecoration(


                        color:(_selectedCategoryIndex==eventsList.length + 1)?Theme.of(context).primaryColor:Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor,offset: Offset(0, 0),
                            blurRadius:10),
                        ],
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(16),

                        child:Text(


                          'Add an Event ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:(_selectedCategoryIndex==eventsList.length + 1)?Colors.white:Color(0xFFAFB4C6),


                            fontFamily: 'ZillaSlab',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,

                          ),
                        ),)
                      ,),);
                }
                return _buildCategoryCard(
                  index - 1,
                  eventsList[index-1],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child:Text(

              'Recent Notes',
              style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color:Color(0xFFAFB4C6),
              ),
            ),),
          Container(
            height: 180.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: notesList.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return SizedBox(width: 20.0);
                }
                if (index==notesList.length + 1){
                  return GestureDetector(
                      onTap: () {
                    setState(() {
                      _selectedCategoryIndex2 = index;
                    });
                    gotoEditNote();
                  },
                child: Container(
                  alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
                height: 180.0,
                width: 125.0,
                decoration: BoxDecoration(


                    color:(_selectedCategoryIndex2==notesList.length + 1)?Theme.of(context).primaryColor:Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor,offset: Offset(0, 0),
                blurRadius:10),
                ],
                ),

                child: Padding(

                  padding: EdgeInsets.all(16),
                  child:Text(

                    'Add a Note ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color:(_selectedCategoryIndex2==notesList.length + 1)?Colors.white:Color(0xFFAFB4C6),

                    ),
                  ),)
                  ,),);
                }
                return _buildCategoryCard2(
                  index - 1,
                  notesList[index - 1].title,
                    "In "+notebookList[index - 1].title,
                    formatter.format(notesList[index-1].date),

                notesList[index-1]);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,


              unselectedLabelColor: Color(0xFFAFB4C6),
              indicatorColor: Theme.of(context).primaryColor,
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
                    ),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 20.0),
          ...buildNoteComponentsList(),
          GestureDetector(
            onTap:(){gotoEditEvent();} ,
            child:Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color:Color(0xFFAFB4C6),
              borderRadius: BorderRadius.circular(20.0),
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

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
              height: 240,
              width: 125.0,

              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color:Color(0xFFAFB4C6),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: <Widget>[

                Expanded(
                  child:PageView.builder(
                    controller: controller,

                    scrollDirection: Axis.horizontal,


                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {



                      return _buildIcons(
                        index,
                        iconsList[index],
                        below_texs[index],
                          page_offset-index
                      );
                    },
                  ),),
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
            ),

          SizedBox(height:80.0),

        ],
      ),
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
  List<Widget> buildNoteComponentsList()  {
    HashMap hashMap_asked;
    List<EventModel> asked = [];
    if (date_selector==1){
      setState(() {
        asked=eventsListtom;
        hashMap_asked=hashMap_tom;
      });
    }
    else {
      setState(() {
        asked=eventsListtoday;
        hashMap_asked=hashMap_today;
      });
    }

    List<Widget> noteComponentsList = [];

    asked.sort((a, b) {
      if (a.date.day==b.date.day && a.date.month==b.date.month && a.date.year==b.date.year){
        return a.time.compareTo(b.time);
      }
      return a.date.compareTo(b.date);
    });


    int position =1;
    asked.forEach((event){
      if (event.duration==0){
      List<Todo> TodoList=[];
      if (event.todo_id!=0){
        TodoList =hashMap_asked[event.id];
      }

      noteComponentsList.add(NoteCardComponent(
        eventData: event,
        onTapAction:setIsdone,
        openEvent: openEventToEdit,
        todoList: (TodoList!=null)?TodoList:null,
        position: position,
      ));

    }});
    asked.forEach((event)  {
      if (event.duration!=0) {
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
      }});

    return noteComponentsList;
  }
  Widget _buildCategoryCard(int index, EventModel this_event) {
    final date2 = DateTime.now();
    final difference = this_event.date.difference(date2).inDays;
    //formatter.format(this_event.date)
    String bottom_text="At ${_timeFormatter.format(this_event.time)}";
    if (difference>1){
      bottom_text="In\n${difference} days";
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;


        });

      },
      onLongPress:(){
        openEventToEdit(this_event);
      } ,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        height: 240.0,
        width: 175.0,
        decoration: BoxDecoration(
            color: _selectedCategoryIndex == index
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
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
              padding:EdgeInsets.only(left:20.0,bottom:0,top:20,right:8),
              child: Text(
                this_event.title,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',

                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      : Color(0xFFAFB4C6),
                  fontSize:18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:20.0,bottom:20,top:8,right:8),
              child: Text(
                bottom_text,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',

                  color: _selectedCategoryIndex == index
                      ? Colors.white
                      : Theme.of(context).textSelectionColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildIcons(int index, IconData this_icon, String bottom_text, double offset) {

    double gauss = exp(-(pow((offset.abs() - 0.5), 2) / 0.08)); //<--caluclate Gaussian function
    return Transform.translate(
        offset: Offset(-32 * gauss * offset.sign, 0),
    child:GestureDetector(


      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        height: 240.0,
        width: 175.0,
        decoration: BoxDecoration(
          color
              : Theme.of(context).cardColor,
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

              padding:EdgeInsets.only(left:20.0,bottom:0,top:20,right:8),
              child:Align(
                alignment: Alignment(offset, 0),
                child: Icon(this_icon,size: 48,
              ),)

            ),
      Transform.translate(
        offset: Offset(16 * offset, 0), //<-- translate the name label
            child:Padding(
              padding: EdgeInsets.only(left:20.0,bottom:20,top:8,right:8),
              child: AnimatedDefaultTextStyle(
                style: offset==0
                    ? TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)
                    : TextStyle(
                    fontSize:14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w100),
                duration: const Duration(milliseconds: 100),
                child: Text(bottom_text),
              ),
            ),)
          ],
        ),
      ),
    ),);
  }
  Widget _buildCategoryCard2(int index, String title, String count,String date,NotesModel this_note) {
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
          color: _selectedCategoryIndex2 == index
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
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
              padding: EdgeInsets.only(top:12.0,left: 12),
              child: Text(
                  '${title.trim().length <= 16 ? title.trim() : title.trim().substring(0, 16) + '...'}',
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
        margin: EdgeInsets.only(left:12,right: 12,top: 8),

        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [

            ]
        ),
      child: Padding(
        padding: EdgeInsets.only(top:8.0,left: 8,bottom: 8,right: 8),
        child: Text(
          '${count.trim().length <= 60 ? count.trim() : count.trim().substring(0, 60) + '...'}',
          style: TextStyle(
            fontFamily: 'ZillaSlab',

            color
                : Theme.of(context).textSelectionColor,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      ),

            Padding(
              padding: EdgeInsets.only(top:4.0,left: 12,bottom: 12,right: 4),
              child: Text(
                date,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',

                  color: _selectedCategoryIndex2 == index
                      ? Colors.white
                      : Theme.of(context).textSelectionColor,
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
            builder: (context) => EditorPage(
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
            page: AddEventPage(triggerRefetch: refetchEventsFromDB,existingEvent: eventData,)));
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }



  setIsdone(Todo todoData) {
    setState(() {
      todoData.isDone=!todoData.isDone;
    });
    print(todoData.isDone);
    setEventsFromDB();
  }
}
