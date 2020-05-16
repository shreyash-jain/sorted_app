import 'dart:async';
import 'dart:convert';
import 'package:notes/data/date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes/components/cards2.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/rEvent.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/ListQuestion.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/screens/richedit.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
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
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
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


Color primaryColor = Color.fromARGB(255, 58, 149, 255);
final int id = 0;

class AnswerView extends StatefulWidget {
  Function(Brightness brightness) changeTheme;


  AnswerView(
      {Key key,
      this.title,
      Function(Brightness brightness) changeTheme,
  })
      : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AnswerView> {
  List<NoteBookModel> notebookList = [];
  bool isFlagOn = false;
 int current_position=100;
  static var formatter = new DateFormat('d MMMM, EEE');
  static DateTime TofillDate=DateTime.now();
  String formatted=formatter.format(TofillDate);
  bool headerShouldHide = false;
  List<NotesModel> notesList = [];
  TextEditingController searchController = TextEditingController();
  ThemeData theme = appThemeLight;
  DateTime selectedDate=DateTime.now();
  List<EventModel> eventsListtoday = [];
  bool isSearchEmpty = true;
  DateTime today=DateTime.now();
  var formatter_date = new DateFormat('dd-MM-yyyy');
  var formatter_date_builder = new DateFormat('EEE\nd');
  HashMap hashMap_today = new HashMap<int, List<Todo>>();
  ScrollController _controller = ScrollController(initialScrollOffset: 6460);
  List<Todo> TodaytodoList = [];

  int view_type=1;
  @override
  void initState() {
    super.initState();
    get_today_todo(DateTime.now());
  }
  get_today_todo(DateTime at_date) async {

    String formatted_date = formatter_date.format(at_date);
    print("formatted date: " + formatted_date);
    DateModel this_date;
    int weekday=at_date.weekday;
    weekday=weekday+1;
    if (weekday>7)
      weekday=weekday%7;
    print(weekday);
    List<ReventModel> days_Revents;
    var days_Revents_var = await NotesDatabaseService.db.getReventsWithFilterDayFromDB(weekday);

    var fetchedDate = await NotesDatabaseService.db.getDateByDateFromDB(
        formatted_date);
    setState(()  {
       this_date = fetchedDate;
      days_Revents = days_Revents_var;
    });
    if (this_date != null) {
      var fetchedEvents = await NotesDatabaseService.db.getEventsOfDateFromDB(
          this_date.id);

      setState(()  {
        eventsListtoday = fetchedEvents;
      });

    }


    for (var i=0;i<days_Revents.length;i++){
      int diffDaysStart = at_date.difference(days_Revents[i].start_date).inDays;
      int diffDaysEnd = at_date.difference(days_Revents[i].end_date).inDays;
      if ((diffDaysStart == 0 && at_date.day == days_Revents[i].start_date.day) ||(diffDaysEnd == 0 && at_date.day == days_Revents[i].end_date.day) || (at_date.isAfter(days_Revents[i].start_date) && at_date.isBefore(days_Revents[i].end_date) )){
        var fetchedEventFromR= await NotesDatabaseService.db.getEventOfReventFromDB(days_Revents[i].id);
        setState(() {
          eventsListtoday.add(fetchedEventFromR);
        });

      }
    }

    for (var i = 0; i < eventsListtoday.length; i++) {
      if (eventsListtoday[i].todo_id != 0) {
        var fetchedtodo = await NotesDatabaseService.db.getTodos(
            eventsListtoday[i].todo_id);
        setState(() {
          TodaytodoList = fetchedtodo;
          hashMap_today.putIfAbsent(eventsListtoday[i].id, () => TodaytodoList);
        });

      }
    }
  }

  void refetchEventsFromDB() async {
    await get_today_todo(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,

      floatingActionButton:
      Padding(
        padding: const EdgeInsets.only(left:33.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(

                shape: StadiumBorder(),

                child: Ink(
                  decoration:
                  new BoxDecoration(
                    borderRadius: new BorderRadius.all(
                      Radius.circular((40)),
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
                  FloatingActionButton(
                    elevation: 0,


                    heroTag: "btn1",

                    backgroundColor: Colors.transparent,
                    onPressed: () async {
                      var formatter = new DateFormat('d MMMM, EEE');
                      setState(() {
                        selectedDate=selectedDate.subtract(Duration(days: 1));
                        formatted = formatter.format(selectedDate);
                        double current_pos=_controller.position.pixels-65;
                        _controller.animateTo(current_pos, duration: new Duration(seconds: 1), curve: Curves.ease);

                        current_position--;
                        eventsListtoday.clear();
                        hashMap_today.clear();
                        TodaytodoList.clear();
                      });
                      setState(() {
                        get_today_todo(selectedDate);
                      });
                    },

                    child: Icon(Icons.arrow_back_ios),
                  ),)),
            Material(
                shape: StadiumBorder(),

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

                      Navigator.push(
                          context,
                          CupertinoPageRoute(

                              builder: (context) =>

                                  AddEventPage(triggerRefetch: refetchEventsFromDB,event_date: selectedDate,)));
                    },
                    label: Text('Event'.toUpperCase(),
                        style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.add),
                  ),)),
            Material(
                shape: StadiumBorder(),

                child: Ink(
                  decoration:
                  new BoxDecoration(
                    borderRadius: new BorderRadius.all(
                      Radius.circular((40)),
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
                  FloatingActionButton(
                    elevation: 0,
                    heroTag: "btn3",
                    backgroundColor: Colors.transparent,
                    onPressed: () async {

                      var formatter = new DateFormat('d MMMM, EEE');
                      setState(() {
                        selectedDate=selectedDate.add(Duration(days: 1));
                        current_position++;
                        double current_pos=_controller.position.pixels+65;
                        _controller.animateTo(current_pos, duration: new Duration(seconds: 1), curve: Curves.ease);
                        formatted = formatter.format(selectedDate);
                        eventsListtoday.clear();
                        hashMap_today.clear();
                        TodaytodoList.clear();
                      });
                      setState(() {
                        get_today_todo(selectedDate);
                      });
                    },

                    child:Icon(Icons.arrow_forward_ios),

                  ),)),
          ],
        ),
      ),

      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [

      SliverSafeArea(
        top: false,
        sliver: SliverAppBar(
          backgroundColor:    Color(0xFFAFB4C6).withOpacity(.9),
          actions: <Widget>[

          ],
          leading: IconButton(
            icon: const Icon(OMIcons.arrowBack),
            tooltip: 'Add new entry',
            onPressed: () { Navigator.pop(context);},
          ),
          expandedHeight: 250,
          pinned: true,
          primary:true,
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomRight: Radius.circular(45.0)),

          ),
          flexibleSpace: FlexibleSpaceBar(
              title: Text(
                formatted,
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.white),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),


              background: Container(
                padding: EdgeInsets.only(top:40,left:0),
                child:FadeAnimation(1.6, Container(

                    child:Stack(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:0,top:0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child:Icon(
                            OMIcons.edit,color: Theme.of(context).cardColor.withOpacity(.10),size: 270,
                          ),
                        ),
                      ),

                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Padding(padding: EdgeInsets.only(top:0),child:AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 400),

                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.indigo.withOpacity(.2), width: 1),
                                      borderRadius:  BorderRadius.all( Radius.circular(30.0) ),
                                      color: Theme.of(context).scaffoldBackgroundColor
                                  ),
                                  height:46,
                                  width: 245,
                                  child:Row(children: <Widget>[

                          Container(

                            decoration: BoxDecoration(

                              boxShadow: [
                                (view_type==1)? BoxShadow(
                                    offset: Offset(4, 8),
                                    color: Colors.black.withAlpha(50),
                                    blurRadius: 16):BoxShadow(
                                    offset: Offset(0, 8),
                                    color: Colors.black.withAlpha(0),
                                    blurRadius: 16)
                              ],

                            ),

                            child:Padding(
                              padding: EdgeInsets.only(left:0,),
                              child: Align(

                                alignment: Alignment.center,
                                child:RaisedButton(
                                  onPressed:(){
                                    print("hello");

                                    setState(() {
                                      view_type=1;

                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),

                                  ),


                                  color: (view_type==1)?Theme.of(context).cardColor:Colors.transparent,
                                  elevation: 0,
                                  padding: const EdgeInsets.all(12),
                                  child: new Text(
                                    "Date view",style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: 16,



                                    ),
                                  ),
                                ),),),),
                          Container(
                            decoration: BoxDecoration(

                              boxShadow: [
                                (view_type==2)? BoxShadow(
                                    offset: Offset(4, 8),
                                    color: Colors.black.withAlpha(50),
                                    blurRadius: 16):BoxShadow(
                                    offset: Offset(0, 8),
                                    color: Colors.black.withAlpha(0),
                                    blurRadius: 16)
                              ],

                            ),

                            child:Padding(
                              padding: EdgeInsets.only(right:0,left: 2),
                              child: Align(

                                alignment: Alignment.center,
                                child:RaisedButton(
                                  onPressed:(){
                                    setState(() {
                                      view_type=2;

                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),

                                  ),


                                  color: (view_type==2)?Theme.of(context).cardColor:Colors.transparent,

                                  elevation: 0,
                                  padding: const EdgeInsets.all(12),
                                  child: new Text(
                                    "Question view",style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: 16,



                                      ),
                                  ),
                                ),),),)
                        ],))),]),


                        SizedBox(height: 10,),
                        Padding(
                            padding: EdgeInsets.only(left:73),
                            child:Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[



                            Text("My\nAnswers",style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 32.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54
                            ),
                              textAlign: TextAlign.left,),
                          ],)),
                        if (current_position==100)Padding(
                          padding: EdgeInsets.only(top: 6,left:73),
                          child:
                          Text("Today",style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60
                          ),
                            textAlign: TextAlign.left,),),
                        if (current_position==101)Padding(
                          padding: EdgeInsets.only(top: 6,left:73),
                          child:
                          Text("Tomorrow",style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60
                          ),
                            textAlign: TextAlign.left,),),
                        if (current_position==99)Padding(
                          padding: EdgeInsets.only(top: 6,left:73),
                          child:
                          Text("Yesterday",style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60
                          ),
                            textAlign: TextAlign.left,),),

                      ],)],)
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

    child:GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: MediaQuery.removePadding(
    removeTop: true,
    context: context, child:ListView(

            children: <Widget>[

              Stack(children: <Widget>[


                Padding(
                  padding :EdgeInsets.only(left:60,top:10),
                  child:Text("GO TO A DATE",style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 26,
                      color:Colors.grey.withOpacity(.6),


                  ),
                    textAlign: TextAlign.left,),),


            Container(
              margin: EdgeInsets.only(left:310,top: 4),
              width: 36,
              height: 36,

              decoration:
              new BoxDecoration(
                borderRadius: new BorderRadius.all(  Radius.circular(60.0)),
              //  border: Border.all(color: Colors.grey.shade400, width: 2),

              ),
              child:Padding(
                  padding :EdgeInsets.only(left:0,top:4),
                  child:Icon(OMIcons.navigateNext,size: 40,color: Colors.grey.withOpacity(.6),),)),
                Container(
                    margin: EdgeInsets.only(left:320,top: 4),
                    width: 36,
                    height: 36,

                    decoration:
                    new BoxDecoration(
                      borderRadius: new BorderRadius.all(  Radius.circular(60.0)),
                      //  border: Border.all(color: Colors.grey.shade400, width: 2),

                    ),
                    child:Padding(
                      padding :EdgeInsets.only(left:0,top:4),
                      child:Icon(OMIcons.navigateNext,size: 40,color: Colors.grey.withOpacity(.4),),)),

              ],),
              Container(height: 10),
              buildHeaderWidget(context),


              Container(height: 32),
              ...buildNoteComponentsList(),

              Container(height: 100)
            ],
          )),


        ),
      ),)),
    );
  }


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


      setState(() {
        asked = eventsListtoday;
        hashMap_asked = hashMap_today;
      });


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
          openEvent:null,
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
          openEvent: null,
          todoList: (TodoList != null) ? TodoList : null,
          position: position,
        ));
        position = position + 1;
      }
    });
    if (asked==null || asked.length==0){
      noteComponentsList.add(buildNoListItem(context));
    }

    return noteComponentsList;
  }
  setIsdone(Todo todoData) {
    setState(() {
      todoData.isDone = !todoData.isDone;
    });
    print(todoData.isDone);
    get_today_todo(selectedDate);
  }
  Widget buildNoListItem(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              CupertinoPageRoute(

                  builder: (context) =>

                      AddEventPage(triggerRefetch: refetchEventsFromDB,event_date: selectedDate,)));
        },
        child:Container(
            margin: EdgeInsets.fromLTRB(30, 0, 20, 8),

            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: EdgeInsets.only(top:8,bottom:8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'You have no events\non this day',textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Add an event ?',
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));}
  Widget buildHeaderWidget(BuildContext context) {
    return Column(


      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start ,
    children: <Widget>[

        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top:0, bottom: 0, left: 13,right:0),
          width: headerShouldHide ? 0 : null,
          child: Container(
            height: 80,
            margin: EdgeInsets.only(left: 12),
            padding: EdgeInsets.all(8),
            decoration:
            new BoxDecoration(
              borderRadius: new BorderRadius.only(topLeft:  Radius.circular(75.0),topRight:   Radius.circular((0)),bottomLeft:   Radius.circular((20)),bottomRight:   Radius.circular((0)),),
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
              padding: EdgeInsets.only(left: 10),
              child:ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 200 ,
              controller: _controller,
                itemBuilder: (BuildContext context, int index) {

                  return _buildActivityCard(
                      index,
                      today.add(Duration(days: index-100))
                  );

                }
            ),),





          )
        ),
      ],
    );
  }





  Widget _buildActivityCard(int index,
      DateTime this_date) {
    String count= "";
   
    return GestureDetector(
      onTap: () {
        setState(() {


          current_position=index;
         
        });

        var formatter = new DateFormat('d MMMM, EEE');
        setState(() {
          selectedDate=this_date;
          formatted = formatter.format(this_date);
          eventsListtoday.clear();
          hashMap_today.clear();
          TodaytodoList.clear();
        });
        setState(() {
          get_today_todo(this_date);
        });
      },
      child: Padding(

        padding:EdgeInsets.only(),child:Container(
        margin: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
        height: 100,
        width: 60,

        child: Stack(

          children: <Widget>[
            if (current_position!=index)Align(
                alignment: Alignment.bottomCenter,
                child:Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                        borderRadius:  BorderRadius.all( Radius.circular(10.0) ),
                        color: (index==100)?Colors.indigo.withOpacity(.5):Colors.white30
                    )

                )
            ),

            Container(



                decoration: BoxDecoration(
                  // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                    borderRadius:  BorderRadius.all( Radius.circular(10.0) ),
                   color: (current_position==index)?Colors.white30:Colors.transparent
                )


            ),

         Padding(
              padding: EdgeInsets.all(4),

              child:Align(

                alignment: Alignment.center,
                child: Text(
                  formatter_date_builder.format(this_date),
                  textAlign: TextAlign.center,
                  style: TextStyle(

                      color: (index==50)?Colors.white70:Colors.white ,
                      fontFamily: 'ZillaSlab',
                      fontSize: 20,

                      fontWeight: (index==100)?FontWeight.bold:FontWeight.w500),

                ),),
            ),

            


          ],
        ),
      ),),
    );
  }





}
