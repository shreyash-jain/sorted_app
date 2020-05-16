import 'dart:async';
import 'dart:convert';
import 'package:notes/components/timeline_card.dart';
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
import 'package:notes/data/timeline.dart';
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

class TimelineView extends StatefulWidget {
  Function(Brightness brightness) changeTheme;



  TimelineView(
      {Key key,
      this.title,
        this.this_timeline,
      Function(Brightness brightness) changeTheme,
  })
      : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final String title;
  final TimelineModel this_timeline;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TimelineView> with TickerProviderStateMixin  {
  List<NoteBookModel> notebookList = [];
  bool isFlagOn = false;
 int current_position=50;
  static var formatter = new DateFormat('d MMMM, EEE');
  static DateTime TofillDate=DateTime.now();
  String formatted=formatter.format(TofillDate);
  bool headerShouldHide = false;
  List<NotesModel> notesList = [];
  TextEditingController searchController = TextEditingController();
  ThemeData theme = appThemeLight;
  DateTime selectedDate=DateTime.now();
  AnimationController rippleController;

  Animation<double> rippleAnimation;

  List<EventModel> eventsListtoday = [];
  bool isSearchEmpty = true;
  DateTime today=DateTime.now();
  var formatter_date = new DateFormat('dd-MM-yyyy');
  var formatter_date_builder = new DateFormat('EEE\nd');
  HashMap hashMap_today = new HashMap<int, List<Todo>>();
  ScrollController _controller = ScrollController(initialScrollOffset: 0);
  List<Todo> TodaytodoList = [];
  @override
  void initState() {
    super.initState();
    get_today_todo(DateTime.now());

    rippleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1)
    );
    rippleAnimation = Tween<double>(
        begin:0,
        end: 49.0
    ).animate(rippleController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rippleController.reverse();
      } else if(status == AnimationStatus.dismissed) {
        rippleController.forward();
      }
    });
    rippleController.forward();
  }
  @override
  void dispose() {
    rippleController.dispose();

    super.dispose();
  }
  get_today_todo(DateTime at_date) async {

    String formatted_date = formatter_date.format(at_date);
    print("formatted date: " + formatted_date);
    DateModel this_date;




      var fetchedEvents = await NotesDatabaseService.db.getEventsOfTimelineFromDB(widget.this_timeline.id);

      setState(()  {
        eventsListtoday = fetchedEvents;
      });



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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

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

                                  AddEventPage(triggerRefetch: refetchEventsFromDB,event_tl: widget.this_timeline,)));
                    },
                    label: Text(''.toUpperCase(),
                        style: TextStyle(color: Colors.white)),
                    icon: Icon(Icons.add),
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
                widget.this_timeline.title,
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.white),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),


              background: Container(
                padding: EdgeInsets.only(top:45,left:73),
                child:FadeAnimation(1.6, Container(

                    child:Stack(children: <Widget>[

                      Padding(
                        padding: EdgeInsets.only(left:0,top:0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child:Icon(
                            OMIcons.timeline,color: Theme.of(context).cardColor.withOpacity(.10),size: 300,
                          ),
                        ),
                      ),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget>[


                            SizedBox(height: 60,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[




                                Text("Start Date : ${formatter_date.format(widget.this_timeline.date)}",style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45
                                ),
                                  textAlign: TextAlign.left,),
                              ],),
                            SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[




                                Text("Status : Ongoing",style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45
                                ),
                                  textAlign: TextAlign.left,),

                                Padding(
                                    padding:EdgeInsets.only(top:4,left:4),
                                    child:Icon(Icons.repeat,color: Colors.black.withOpacity(.4),))
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

    child:GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
    child:MediaQuery.removePadding(
    removeTop: true,
    context: context, child: ListView(

            children: <Widget>[




              Container(height: 0),
              ...buildNoteComponentsList(),

              Container(height: 0)
            ],
          ),),


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

    noteComponentsList.add(
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
        child:ListView.builder(
          shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: asked.length ,
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          List<Todo> TodoList = [];
          if (asked[index].todo_id != 0) {
            TodoList = hashMap_asked[asked[index].id];
          }
          if(index==0){
            rippleController.forward();
          }

          return _TimelineCard(index,  asked[index],null,TodoList, index+1,setIsdone);

        }
    )));

    if (asked.length==0){
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

                      AddEventPage(triggerRefetch: refetchEventsFromDB)));
        },
        child:Container(
            margin: EdgeInsets.fromLTRB(30, 30, 20, 8),

            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(65.0),topRight:Radius.circular(20.0) ,bottomRight:Radius.circular(20.0) ,bottomLeft:Radius.circular(20.0) ),
            ),
            child: Material(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(65.0),topRight:Radius.circular(20.0) ,bottomRight:Radius.circular(20.0) ,bottomLeft:Radius.circular(20.0) ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: EdgeInsets.only(top:8,bottom:8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'You have no events\nin this Timeline',textAlign: TextAlign.center,
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
              ),





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
                        color: (index==50)?Colors.indigo.withOpacity(.5):Colors.white30
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

                      fontWeight: (index==50)?FontWeight.bold:FontWeight.w500),

                ),),
            ),

            


          ],
        ),
      ),),
    );
  }

  Widget _TimelineCard(int index,
      EventModel eventData,Function(EventModel eventData) openEvent, List<Todo> todoList,int position,Function(Todo todoData) onTapAction) {
    var formatter_date = new DateFormat('d MMM\ny');
    var formatter = new DateFormat('Hm');
    double height = 300;
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

    String side_text="";
    if (index==0) side_text="Start     ";
    else if (index==eventsListtoday.length-1)side_text="End";
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
                      width: 120,
                      height: height,

                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(

                              margin: EdgeInsets.only(bottom: 5),
                              width: 4,
                              height: height / 2-35,
                              decoration: new BoxDecoration(
                                borderRadius:
                                BorderRadius.only(bottomRight:Radius.circular(75.0),bottomLeft:Radius.circular(75.0) ),
                                gradient: new LinearGradient(
                                    colors: [
                                      Colors.grey.withOpacity(.2),
                                      Colors.grey.withOpacity(.2)
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
                                            left: 18, right: 8, top: 0),
                                        child: Text(
                                          position.toString(),
                                          style: TextStyle(
                                              fontFamily: 'ZillaSlab',
                                              fontSize: 45,
                                              color: (Theme.of(context).brightness == Brightness.dark)?Colors.white.withOpacity(.3):Colors.black45.withOpacity(.1),
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ])),
                          Stack(
                            children: <Widget>[
                              Container(
                                width: 10,
                                  height:10,
                                decoration: new BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(75.0)),

                                ),


                              )
                            ],
                          ),

                          Padding(
                              padding: EdgeInsets.only(left: 8, right: 8, top: 0),
                              child: Text(
                                formatter_date.format(eventData.date),textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize:18,
                                    color: (Theme.of(context).brightness == Brightness.dark)?Colors.white:Colors.black45,

                                    fontWeight: FontWeight.bold),
                              )),
                          Container(

                            margin: EdgeInsets.only(top: 5),
                            width: 4,
                            height: height / 2-35,
                            decoration: new BoxDecoration(
                              borderRadius:
                              BorderRadius.only(topRight:Radius.circular(75.0),topLeft:Radius.circular(75.0) ),
                              gradient: new LinearGradient(
                                  colors: [
                                    Colors.grey.withOpacity(.2),
                                    Colors.grey.withOpacity(.2)
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
                      width: 2,
                    ),
                    Flexible(
                      child: Container(
                        height: height-15,

                        margin: EdgeInsets.only(top: 10),
                        padding:EdgeInsets.all(10),

                        decoration: new BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0) ),
                          gradient: new LinearGradient(
                              colors: [
                                Theme.of(context).cardColor.withOpacity(.5),
                                Theme.of(context).cardColor.withOpacity(.5),

                              ],
                              begin: const FractionalOffset(.2, .2),
                              end: const FractionalOffset(1.0, 1.00),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child:Column(
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
                                  decoration:
                                       BoxDecoration(
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


                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 12),

                                        child: Text(
                                          '${eventData.title.trim().length <= 18 ? eventData.title.trim() : eventData.title.trim().substring(0, 18) + '...'}',
                                          style: TextStyle(
                                              color: Colors.white,

                                              fontFamily: 'ZillaSlab',
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),

                                    ],
                                  ),
                                )),

                            Padding(
                              padding: EdgeInsets.only(top:10,left: 4),
                              child:Text(
                              'Duration : $neatDate',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'ZillaSlab',
                                  color: (Theme.of(context).brightness==Brightness.dark)?Colors.white70:Colors.black26,

                                  fontWeight:
                                  FontWeight.w500
                              ),
                            ),),
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
                                            onTapAction
                                        );
                                      })),
                            if (todoList != null && todoList.length != 0)
                              SizedBox(
                                height: 16,
                              )
                          ],
                        ),
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
                              padding: EdgeInsets.only(top:30
                              ),
                              child: Text(
                                side_text,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 16,
                                    color:   (Theme.of(context).brightness == Brightness.dark)?Colors.white.withOpacity(0.9):Colors.black87
                                    ,fontWeight: FontWeight.bold),
                              ))),
                    ]),

                    FadeAnimation(.6, Container(
                        height: 50,
                        width: 50,

                        margin: EdgeInsets.only(top:85,left: 35),

                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            AnimatedBuilder(
                              animation: rippleAnimation,
                              builder: (context, child) => Container(
                                width: rippleAnimation.value,
                                height: rippleAnimation.value,

                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:   Theme.of(context).textSelectionHandleColor.withOpacity((rippleAnimation.value*2)/100)
                                  ),
                                  child: InkWell(
                                    onTap: () {



                                    },
                                    child:  Container(
                                      width: 10,
                                      height:10,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(75.0)),

                                      ),
                                    ),

                                  ),

                                ),
                              ),
                            )
                          ],))

                ),

                FadeAnimation(.6, Container(
                    height: 50,
                    width: 50,

                    margin: EdgeInsets.only(top:85,left: 35),

                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        AnimatedBuilder(
                          animation: rippleAnimation,
                          builder: (context, child) => Container(
                            width: 24-rippleAnimation.value/4,
                            height: 24-rippleAnimation.value/4,

                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:   (Theme.of(context).brightness == Brightness.dark)?Colors.white:Colors.black87
                              ),
                              child: InkWell(
                                onTap: () {



                                },
                                child:  Container(
                                  width: 10,
                                  height:10,
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(75.0)),

                                  ),
                                ),

                              ),

                            ),
                          ),
                        )
                      ],))

                )
              ],)
          ),
        ));
  }
  Widget _buildCategoryCard(BuildContext context, int index, Todo this_todo, Function(Todo todoData) onTapAction) {
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





}
