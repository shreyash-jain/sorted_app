
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/LibraryCards.dart';
import 'package:notes/components/bookcards.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/data/timeline.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/TimelineView.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/screens/home.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'QuestionForm.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/bookcards.dart';

class AllTimelines extends StatefulWidget {

  Function(Brightness brightness) changeTheme;

  AllTimelines(
      {Key key,

        this.title,
        Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;

  }

  final String title;

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AllTimelines>  with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  ThemeData theme = appThemeLight;
  bool isFlagOn = false;
  Timer _timer;

  List<TimelineModel> Timelines = [];
  TextEditingController searchController = TextEditingController();
  int _currentPage = 0;
  AnimationController icon_controller;
  bool isSearchEmpty = true;
  bool headerShouldHide = false;
  double timeline_card_h=50;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    _timer= Timer.periodic(Duration(seconds: 8), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });

    icon_controller =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    NotesDatabaseService.db.init();
    setTimelinesFromDB();
  }
  @override
  void dispose() {
    icon_controller.dispose();
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }
  setTimelinesFromDB() async {
    print("Entered setTimelines");
    var fetchedQues = await NotesDatabaseService.db.getTimelinesFromDB();
    print("Timelines" + fetchedQues.length.toString());
    setState(() {
      Timelines = fetchedQues;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Theme.of(context).primaryColor,

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
                "All Timelines",
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),


              background: Container(
                padding: EdgeInsets.only(top:120,left:73),
                child:FadeAnimation(1.6, Container(

                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[



                        Expanded(child:Text("List of important events arranged in the order in which they happened",style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black26
                        ),
                          textAlign: TextAlign.left,),)
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

    child:AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child:



            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child:ListView.builder(scrollDirection: Axis.vertical,
                    itemCount: Timelines.length+2,

                    itemBuilder: (BuildContext context, int index) {
                      if (index==0) return Padding(
                        padding: EdgeInsets.only(left:20,top:26,bottom: 12),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Select to view",
                            style: TextStyle(

                                fontFamily: 'ZillaSlab',
                                fontSize: 18,

                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                      if (index == Timelines.length+1) {

                        return  AnimatedContainer(
                          duration:  Duration(milliseconds: 500),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5.0),
                          height: 280,
                          curve: Curves.easeInOut,

                          decoration: BoxDecoration(
                              color:  Colors.white,
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
                                padding: EdgeInsets.only(left:0,top:0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child:Icon(
                                    Icons.timeline,color: Theme.of(context).primaryColor.withOpacity(.15),size: 300,
                                  ),
                                ),
                              ),


                              Padding(
                                padding: EdgeInsets.only(left:10,top:8,right:10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: PageView(
                                      scrollDirection: Axis.horizontal,

                                      controller: _pageController,
                                      children: <Widget>[

                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Stack(

                                            children: <Widget>[


                                              Padding(padding :EdgeInsets.only(top:0),
                                                child:FadeAnimation(0.6, Container(
                                                    padding: EdgeInsets.only(left:12,right:12),
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all( Radius.circular(20.0)),
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

                                                    child: Text(
                                                      'So what is Timeline ?',
                                                      style: TextStyle(
                                                          fontFamily: 'ZillaSlab',
                                                          fontSize: 20.0,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white70

                                                      ),
                                                    )
                                                )),),


                                              Padding(padding :EdgeInsets.only(top:40),
                                                child:FadeAnimation(1.2, Container(


                                                    padding: EdgeInsets.only(left:12,right:12,top:4,bottom:12),
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all( Radius.circular(20.0)),
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

                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: 'Provides a visual representation of events that helps you better understand',
                                                        style: TextStyle(
                                                            fontFamily: 'ZillaSlab',
                                                            fontSize: 21,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black45

                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(text: ' history', style: TextStyle(fontWeight: FontWeight.bold)),
                                                          TextSpan(text: ', a ',),
                                                          TextSpan(text: 'story', style: TextStyle(fontWeight: FontWeight.bold)),
                                                          TextSpan(text: ', a ',),
                                                          TextSpan(text: 'process', style: TextStyle(fontWeight: FontWeight.bold)),
                                                          TextSpan(text: '  or any other form of an event sequence arranged in chronological order and displayed along a line '),
                                                        ],
                                                      ),
                                                    )
                                                )),),


                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Stack(

                                            children: <Widget>[





                                              Padding(padding :EdgeInsets.only(top:0),
                                                child:FadeAnimation(1.2, Container(


                                                    padding: EdgeInsets.only(left:12,right:12,top:4,bottom:4),
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all( Radius.circular(20.0)),
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

                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: 'Project Management',
                                                        style: TextStyle(
                                                            fontFamily: 'ZillaSlab',
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black45

                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(text: '\nProcess Timeline', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                          TextSpan(text: '\nCompletion Timeline', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),

                                                        ],
                                                      ),
                                                    )
                                                )),),
                                              Padding(padding :EdgeInsets.only(top:80,left: 00),
                                                child:FadeAnimation(1.2, Container(


                                                    padding: EdgeInsets.only(left:12,right:12,top:4,bottom:4),
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all( Radius.circular(20.0)),
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

                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: 'Self-Life Tracking',
                                                        style: TextStyle(
                                                            fontFamily: 'ZillaSlab',
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black45

                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(text: '\nLife success Timeline', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                          TextSpan(text: '\nHealth/Fitness Timeline', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),

                                                        ],
                                                      ),
                                                    )
                                                )),),
                                              Padding(padding :EdgeInsets.only(top:160,left: 0),
                                                child:FadeAnimation(1.2, Container(


                                                    padding: EdgeInsets.only(left:12,right:12,top:4,bottom:4),
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all( Radius.circular(20.0)),
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

                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: 'Studies Track',
                                                        style: TextStyle(
                                                            fontFamily: 'ZillaSlab',
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.black45

                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(text: '\nProgress Report Timeline', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                                                          TextSpan(text: '\nSyllabus Completion Timeline', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),

                                                        ],
                                                      ),
                                                    )
                                                )),),




                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: Stack(

                                            children: <Widget>[
                                              Padding(
                                                padding :EdgeInsets.only(top:50),
                                                child:FadeAnimation(1.6, Container(

                                                  child:Image(
                                                    image: AssetImage(
                                                      'assets/images/timeline.png',
                                                    ),

                                                    fit: BoxFit.fill,
                                                  ),),),),

                                              Padding(padding :EdgeInsets.only(top:5,left:10),
                                                child:FadeAnimation(0.6, Container(
                                                    padding: EdgeInsets.only(left:12,right:12),
                                                    decoration: new BoxDecoration(
                                                      borderRadius: new BorderRadius.all( Radius.circular(20.0)),
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

                                                    child: Text(
                                                      'Representation',
                                                      style: TextStyle(
                                                          fontFamily: 'ZillaSlab',
                                                          fontSize: 20.0,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white70

                                                      ),
                                                    )
                                                )),),




                                            ],
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),








                            ],
                          ),
                        );
                      }
                      return _buildTimelineCard(
                          index-1, Timelines[index-1]);
                    }))
          ,
        margin: EdgeInsets.only(top: 2),
        padding: EdgeInsets.only(left: 15, right: 15),
      ),)),
    );
  }



  Widget _buildTimelineCard(int index, TimelineModel this_note) {
    String count = "";
    String status="Ongoing";
    if (this_note.status==1){
      status="Ongoing";
    }
    else if (this_note.status==2){
      status="Paused";
    }
    else if (this_note.status==3){
      status="Completed";
    }



    var formatter = new DateFormat('d MMM yyyy');
    String  formatted = formatter.format(this_note.date);
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
              context,
              FadeRoute(
                  page: TimelineView(
                    title: 'Home',
                    this_timeline: this_note,
                    changeTheme: setTheme,)));

          print("tapped");

        });
      },
      child: AnimatedContainer(
        duration:  Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5.0),
        height: timeline_card_h,
        curve: Curves.easeInOut,

        decoration: BoxDecoration(
            color:  Theme.of(context).cardColor.withOpacity(.6),
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
              padding: EdgeInsets.only(left:20,top:8),
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
              padding: EdgeInsets.only(left:40,top:0),
              child: Align(
                alignment: Alignment.topRight,
                child:IconButton(
                  iconSize: 25,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: icon_controller,
                  ),
                  onPressed: () => _onpressed(),
                ),
              ),
            ),
            if (isPlaying)Padding(
              padding: EdgeInsets.only(left:20,top:45),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Status: "+status,
                  style: TextStyle(

                      fontFamily: 'ZillaSlab',
                      fontSize: 16,


                      fontWeight: FontWeight.w700),
                ),
              ),
            ),

            if (isPlaying)Padding(
              padding: EdgeInsets.only(left:50,top:45),
              child: Align(
                alignment: Alignment.topCenter,
                child:Icon(
                  Icons.repeat,color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            if (isPlaying)Padding(
              padding: EdgeInsets.only(left:20,top:75),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Start date: "+formatted,
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
      isPlaying
          ? icon_controller.forward()
          : icon_controller.reverse();

      if (isPlaying){
        setState(() {
          timeline_card_h=110;
        });
      }
      else {
        setState(() {
          timeline_card_h=50;
        });

      }
    });
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


}
