import 'dart:async';

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/animated_button.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/activityLog.dart';
import 'package:notes/data/animated-wave.dart';
import 'package:notes/data/answer.dart';
import 'package:notes/data/custom_slider_thumb_circle.dart';
import 'package:notes/data/custom_slider_thumb_circle_text.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/eCat.dart';
import 'package:notes/data/expense.dart';
import 'package:notes/data/friend.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/data/user_activity.dart';
import 'package:notes/main.dart';
import 'package:notes/screens/Survey_end.dart';
import 'package:notes/screens/addEvent.dart';
import 'package:notes/services/database.dart';



class DisplayQuestions extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  String payload;
  DateTime setDate;
  DisplayQuestions({Key key,String payload, Function(Brightness brightness) changeTheme,DateTime setDate})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.setDate=setDate;
    this.payload=payload;
  }

  @override
  _DisplayQuestionsState createState() => _DisplayQuestionsState();
}

class _DisplayQuestionsState extends State<DisplayQuestions> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int _radioValue1 = -1;
  int selected = -1;
  int front=1;
  int expense_type=0;
  int _currentValue = 1;
  List<int> write_about_today=[];
  Animatable<Color> background;
  ThemeData theme = appThemeLight;
  List<QuestionModel> quesList = [];
  List<CatModel> catsList = [];
  List<FriendModel> friendsList = [];
  List<AnswerModel> ansList=[];
  Timer _timer;
  int min=0;

  List<Widget> TracksWidget=[];
  int sec=0;

  Animation<double> scaleAnimation;
  AnimationController scaleController;
List<UserAModel> userAct =[];
  AnimationController rippleController;
  Animation<double> rippleAnimation;
  int current_page=0;
  int _start = 600;
  int _extra =600;
  double _valueDay=0;
  double _valueWork=0;
  List<double> _value_act=[];
int started=0;
  QuestionModel currentQues;
  List<bool> visited;
  List<IconData> iconsList = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied
  ];
  List<IconData> iconsListWork = [
  Icons.hotel,
    Icons.mood_bad,
    Icons.face,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied
  ];
  double page_offsetDay = 0;
  double page_offsetWork = 0;
  List<String> below_texs = ["Really terrible", "somewhat bad", "just okay", "Pretty good", "Awesome"];
  List<String> below_texsWork = ["No work", "Bad Day", "Could be better", "I'm Satisfied", "Best day"];

  int timeline=0;
  int _numPages = 3;
  String questiosn_name="";
  String question_content="How was my day ?";
  FocusNode titleFocus = FocusNode();
  FocusNode expenseTitleFocus = FocusNode();
  FocusNode expenseContentFocus = FocusNode();
  FocusNode expenseMoneyFocus = FocusNode();
  TextEditingController expenseTitle = TextEditingController();
  TextEditingController expenseContent = TextEditingController();
  TextEditingController expenseMoney = TextEditingController();
  TextEditingController FriendName = TextEditingController();
  FocusNode FriendNameFocus = FocusNode();
  int chosen_expense_cat=11;
  int chosen_friend=0;
  List<TextEditingController> titleController = [];
  Decoration _decoration = new BoxDecoration(
    color: Colors.transparent,
    border: new Border(
      top: new BorderSide(
        style: BorderStyle.solid,
        color: Colors.white,
      ),
      bottom: new BorderSide(
        style: BorderStyle.solid,
        color: Colors.white,
      ),
    ),
  );
  final scontrollerDay =
  PageController(viewportFraction: 0.4, initialPage: 0, keepPage: false);
  final scontrollerWork =
  PageController(viewportFraction: 0.4, initialPage: 0, keepPage: false);

  final controller =
      PageController(viewportFraction: 1.0, initialPage: 0, keepPage: false);

  IconData backicon=Icons.person_pin;
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    int type=0;
    for (int i = 0; i < _numPages; i++) {
      if (i==current_page)type=1;

      list.add(i <= current_page ? _indicator(true,type:type) : _indicator(false,type:type));
    }
    return list;
  }
  void initState() {


    super.initState();
    startTimer();
    scaleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1)
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
        Navigator.push(context,
            FadeRoute(page:MyApp(false)));
      }
    });
    scontrollerDay.addListener(() {
      setState(() =>
      page_offsetDay = scontrollerDay.page); //<-- add listener and set state
    });
    scontrollerWork.addListener(() {
      setState(() =>
      page_offsetWork = scontrollerWork.page); //<-- add listener and set state
    });



    NotesDatabaseService.db.init();
    setQuesFromDB();


  }
  Widget _indicator(bool isActive,{int type}) {
    if (type==null)type==0;
    Color c=Colors.white70;
    if (type==1)c=Colors.black12;
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(vertical: 4.0,horizontal: (_numPages<10)?3:2),
      width: (_numPages<15)?8:6,
      height: isActive ? 24.0 : 14.0,
      decoration: BoxDecoration(
        color: isActive ? c : Colors.black38,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  setQuesFromDB() async {
    print("Entered setQues");
    var fetchedQues = await NotesDatabaseService.db.getQuestionsFromDB();
    print("questions" + fetchedQues.toString());
    var fetchedCats= await NotesDatabaseService.db.getCatsFromDB();
    var fetchedFriends= await NotesDatabaseService.db.getFriendsDB();
    var fetchedActivities= await NotesDatabaseService.db.getUserActiviyFromDB();
    setState(() {
      catsList=fetchedCats;
      quesList = fetchedQues;
      friendsList=fetchedFriends;
      userAct=fetchedActivities;
      AnswerModel temp = AnswerModel(content: "",res1: 0,res2: 0,res3: 0,a_rating: 0);
      for (var i = 0; i < userAct.length; i++) {
        _value_act.add(0);
      }
      TextEditingController temp_text = TextEditingController();
      for (var i = 0; i < quesList.length; i++) {
        titleController.add(TextEditingController());
        AnswerModel temp =new AnswerModel(content: "hbh",res1: 0,res2: 0,res3: 0,a_rating: 0,date_id: 0);
        ansList.add(temp);
        write_about_today.add(0);
      }
    });
    _numPages= quesList.length;
    print("questions title " + quesList[0].interval.toString());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,



      body: SingleChildScrollView(child:
        Stack(
        children: [


          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [ 0, 0.8],
                colors: [


                  Theme.of(context).primaryColor,
                  Color(0xFF4563DB),
                ],
              ),
            ),
              child: Stack(

      children: <Widget>[
        if (expense_type==0)onBottom(FadeAnimation(1, Container(child:AnimatedWave(
          height: MediaQuery.of(context).size.height/6,
          speed: 0.9,
          offset: pi,
        )))),
        if (expense_type==0)onBottom(FadeAnimation(1, Container(child:AnimatedWave(
          height: MediaQuery.of(context).size.height/7,
          speed: .7,
          offset: pi/2,
        )))),
        if (expense_type==0)onBottom(FadeAnimation(1, Container(child:AnimatedWave(
          height: MediaQuery.of(context).size.height/8,
          speed: .7,
          offset: pi/4,
        )))),
        Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius:
              new BorderRadius.only(
                bottomLeft:Radius.circular((20)),bottomRight: Radius.circular((20))
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                stops: [ 0, 0.8],
                colors: [

                  Colors.white30,

                  Colors.white24,
                ],
              ),
            ),),

        FadeAnimation(.6, Container(
            margin: EdgeInsets.only(top:0,left:0),
            alignment: Alignment.center,
            child:  Icon(backicon,size: 350,color:Theme.of(context).cardColor.withOpacity(.05)))),

        PageView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                controller: controller,
                onPageChanged: (int page) {

                  setState(() {

                    titleFocus.unfocus();
                    current_page = page;
                    questiosn_name=quesList[current_page].title;
                    if (quesList[current_page].content!=null)
                      {question_content=quesList[current_page].content;

                      }
                    else {
                      question_content="";
                    }
                    expense_type=0;
                    if (current_page==0){
                      backicon=Icons.person_pin;
                    }
                    else if (current_page==1){
                      backicon=Icons.work;
                    }
                    else if (current_page==2){
                      backicon=Icons.wb_sunny;
                    }
                    else if (quesList[current_page].id==4){
                      backicon=Icons.calendar_today;
                    }
                    else if (quesList[current_page].id==5){
                      backicon=Icons.monetization_on;
                    }
                    else if (quesList[current_page].id==6){
                      backicon=Icons.access_time;
                    }
                     else if (quesList[current_page].type==1){
                    backicon=Icons.edit;
                    }
                    else if (quesList[current_page].type==3){
                      backicon=Icons.check_circle;
                    }
                    else if (quesList[current_page].type==2){
                      backicon=Icons.filter_1;
                    }
                  });
                },
                itemBuilder: (context, position) {


                  print("grey.shade900 : " + position.toString());
                  int type = quesList[position].type;
                  ansList[position].q_id = 0;




                  return Stack(
                    children:[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Padding(
                            padding:  EdgeInsets.only(top: 20,bottom: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: buildImportantIndicatorText(
                                  position,
                                  type,
                                  quesList[position]),
                            ),
                          ),


                          if (position + 1 == quesList.length)
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child:

                                AnimatedButton(
                                  onTap: () {
                                    print("animated button pressed");
                                    handleSave();
                                  },
                                  animationDuration: const Duration(milliseconds: 2000),
                                  initialText: "Submit ?",
                                  finalText: "Submitted",
                                  iconData: Icons.check,
                                  iconSize:80,
                                  buttonStyle: ButtonStyle(
                                    primaryColor: Colors.blue,

                                    secondaryColor: Colors.white,
                                    elevation: 20.0,
                                    initialTextStyle:TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                    finalTextStyle: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 22,
                                        color:Colors.blueAccent,
                                        fontWeight: FontWeight.w800),
                                    borderRadius:30,
                                  ),
                                ),/*RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0),



                                  ),
                                  color: Colors.white30,
                                  elevation: 0,
                                  onPressed: () {
                                    handleSave();
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),*/
                              ),
                            )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topRight,
                        ),
                      ),
                    ],
                  );
                },

                itemCount: quesList.length,
              ),
        if (expense_type==0)FadeAnimation(1.6, Container(

            child:Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:20,top:110,bottom: 20,right:20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                if (questiosn_name!="")Container(
                  padding:EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    borderRadius:
                    new BorderRadius.all(
                        Radius.circular((10))
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      stops: [ 0, 0.8],
                      colors: [

                        Colors.black38,

                        Colors.black38,
                      ],
                    ),
                  ),child:Text(

                  questiosn_name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',

                      color: Colors.white,
                      fontSize:14,
                      fontWeight: FontWeight.w700),
                ),),

                SizedBox(height: 4,),
                if (question_content!=null && question_content!="")Container(
                  padding:EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    borderRadius:
                    new BorderRadius.all(
                        Radius.circular((10))
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      stops: [ 0, 0.8],
                      colors: [

                        Colors.white30,

                        Colors.white24,
                      ],
                    ),
                  ),child:Text(

                  question_content,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',

                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),),

              ],)

          ),
        ),)),
        Padding(
          padding: EdgeInsets.only(top: 50,left: 20),
          child:Align(
            alignment: FractionalOffset.topRight,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _buildPageIndicator(),
            ),),),
        Padding(
          padding: EdgeInsets.only(top: 50,right: 10),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: FractionalOffset.topRight,
                child: GestureDetector(
                  onTap: () {
                    controller.animateToPage(quesList.length,
                      duration: Duration(milliseconds:1200),
                      curve: Curves.easeInOut,
                    );
                    print("hahaha");
                  },
                  child:Column(children: <Widget>[



                    Icon(Icons.skip_next,size: 24,),
                    Text("SKIP",style: TextStyle(
    fontFamily: 'ZillaSlab',

    color: Colors.white70,
    fontSize: 12,
    fontWeight: FontWeight.w500))
                  ],)




                ),

              ),



            ],),),
        Padding(
          padding: EdgeInsets.only(top: 50,left: 20),
          child:Align(
            alignment: FractionalOffset.topRight,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _buildPageIndicator(),
            ),),),
              Padding(
                  padding: EdgeInsets.only(bottom: 10,left: 10),
                child:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: FractionalOffset.bottomLeft,
              child: FlatButton(
                onPressed: () {

                },
                child: Container(
                    padding:EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      borderRadius:
                      new BorderRadius.all(
                          Radius.circular((10))
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        stops: [ 0, 0.8],
                        colors: [

                          Colors.white30,

                          Colors.white30,
                        ],
                      ),
                    ),child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[


                    Text(
                      "$min"+" : "
                    ,style: TextStyle(
                        fontFamily: 'ZillaSlab',

                        color: (front==1)?Colors.white:Colors.black54,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
                    Text(
                        "$sec",style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        color: (front==1)?Colors.white:Colors.black54,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)
                    ),
                  ],
                )),
              ),

            ),



          ],),),


        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: FractionalOffset.bottomRight,
              child: FlatButton(
                onPressed: () {
                 // titleFocus.unfocus();
                  if (current_page>0){
                    controller.animateToPage(current_page-1,
                      duration: Duration(milliseconds:1200),
                      curve: Curves.easeInOut,
                    );}
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[


                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white.withOpacity(.4),
                      size: 30.0,
                    ),
                  ],
                ),
              ),

            ),
            if(current_page!=quesList.length)Align(
              alignment: FractionalOffset.bottomRight,
              child: FlatButton(
                onPressed: () {
                //  titleFocus.unfocus();
                  controller.animateToPage(current_page+1,
                    duration: Duration(milliseconds:1200),
                    curve: Curves.easeInOut,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size:30.0,
                    ),
                  ],
                ),
              ),

            )


          ],),

      ])
          ),
      /*if (current_page + 1 < quesList.length && current_page!=-1)
        Padding(
        padding: const EdgeInsets.all(2.0),
    child: Align(
    alignment: Alignment.bottomCenter,
    child: SmoothPageIndicator(
    controller: controller,
    count: quesList.length,
    effect: SlideEffect(
    spacing: 6.0,
    radius: 10.0,
    dotWidth: 22.0,
    dotHeight: 16.0,
    paintStyle: PaintingStyle.fill,
    strokeWidth: 1.5,
    dotColor: Colors.grey,
    activeDotColor: Theme.of(context).primaryColor),
    ),
    ),
    ),*/

    ]
      )));
  }

  void _handleRadioValueChange1(int value, int position) {
    setState(() {
      _radioValue1 = value;
      print(position);
      switch (_radioValue1) {
        case 0:
          selected = 0;
          ansList[position].res1 = 1;
          ansList[position].res2 = 0;
          ansList[position].res3 = 0;
          print("ye kia " + selected.toString());
          break;
        case 1:
          selected = 1;
          ansList[position].res1 = 0;
          ansList[position].res2 = 1;
          ansList[position].res3 = 0;
          print("ye kia " + selected.toString());
          break;
        case 2:
          selected = 2;
          ansList[position].res1 = 0;
          ansList[position].res2 = 0;
          ansList[position].res3 = 1;
          print("ye kia " + selected.toString());
          break;
      }
    });
  }
  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );
  Widget buildImportantIndicatorText(
      int position, int type, QuestionModel this_question) {
    print("type : "+type.toString());

    DateTime today=DateTime.now();
    print(position.toString()+" "+type.toString()+" hhhd");

    Widget child;
    if (quesList[position].id==1) { // Day
      child = type6widget(position);
    }
    else if (quesList[position].id==2) { // Work
      child = type7widget(position);
    }
    else if (quesList[position].id==4) { // Event
      child = type8widget(position);
    }
    else if (quesList[position].id==5) { // Expense
      child = type9widget(position);
    }
    else if (quesList[position].id==6) { // Activity

      child = type10widget(position);
    }
    else if (quesList[position].type==1) {
      child = type1widget(position,this_question);
    } else if (type == 0) {
      child =  type0widget(position);
    } else if (type == 2 && quesList[position].type==2) {
      child =type2widget(position);
    }
    else {

      child =  Padding(
        padding: EdgeInsets.only(left:0,right:0),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 00),
          height: 240,


          padding: EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(
              Radius.circular((48 * .3)),
            ),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[

              Expanded(
                child:PageView.builder(
                  controller: scontrollerDay,
                  physics:new NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,


                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {



                    return _buildIconsWork(
                        index,
                        iconsList[index],
                        below_texs[index],
                        page_offsetDay-index
                    );
                  },
                ),),
              Container(

                width: true
                    ? double.infinity
                    : (48) * 5.5,
                height: (48),
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(
                      Radius.circular((48 * .3)),
                    ),
                    color: Colors.transparent
                ),
                child: Padding(
                  padding: EdgeInsets.only(left:16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${"Rate"}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize:48 * .3,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,

                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white.withOpacity(1),
                              inactiveTrackColor: Colors.white.withOpacity(.5),

                              trackHeight: 4.0,
                              thumbShape: CustomSliderThumbCircle(
                                thumbRadius: 48 * .4,
                                min: 1,
                                max: 4,
                              ),
                              overlayColor: Colors.white.withOpacity(.4),
                              //valueIndicatorColor: Colors.white,
                              activeTickMarkColor: Colors.white,
                              inactiveTickMarkColor: Colors.red.withOpacity(.7),
                            ),
                            child: null
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 48 * .1,
                      ),
                      Text(
                        '${5}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48 * .3,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),);
    }
    return new Container(child: child);
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  Widget type6widget(int position){ // Day
    return Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if(write_about_today[position]==0)Padding(
                padding: EdgeInsets.only(left:0,right:0),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 00),
                  height: (MediaQuery.of(context).size.height>400)?240:100,


                  padding: EdgeInsets.all(5.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(
                      Radius.circular((48 * .3)),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: <Widget>[

                      if (MediaQuery.of(context).size.height>400)Expanded(
                        child:PageView.builder(
                          controller: scontrollerDay,
                          physics:new NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,


                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {



                            return _buildIconsDay(
                                index,
                                iconsList[index],
                                below_texs[index],
                                page_offsetDay-index
                            );
                          },
                        ),),
                      if (MediaQuery.of(context).size.height<400)SizedBox(height: 100,),
                      Container(

                        width:  double.infinity,
                        margin: EdgeInsets.only(left: 10,right:10),


                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(
                              Radius.circular((45)),
                            ),
                            color: Colors.white70
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top:0,left:20),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${"Rate"}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,

                                ),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Expanded(
                                child: Center(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.black.withOpacity(1),
                                      inactiveTrackColor: Colors.blue.withOpacity(.5),

                                      trackHeight: 4.0,
                                      thumbShape: CustomSliderThumbCircle(
                                        thumbRadius: 48 * .4,
                                        min: 1,
                                        max: 4,
                                      ),
                                      overlayColor: Colors.black.withOpacity(.4),
                                      //valueIndicatorColor: Colors.white,
                                      activeTickMarkColor: Colors.black54,
                                      inactiveTickMarkColor: Colors.red.withOpacity(.7),
                                    ),
                                    child: Slider(

                                        value: _valueDay,
                                        onChanged: (value) {
                                          setState(() {
                                            ansList[current_page].a_rating=_valueDay*5;
                                            _valueDay = value;
                                            if (MediaQuery.of(context).size.height>400){
                                              if (_valueDay<.2 ){
                                                scontrollerDay.animateToPage(0, duration: const Duration(milliseconds: 500),
                                                    curve: Curves.easeInOut);
                                              }
                                              else if (_valueDay<.4 ){
                                                scontrollerDay.animateToPage(1, duration: const Duration(milliseconds: 500),
                                                    curve: Curves.easeInOut);
                                              }
                                              else if (_valueDay<.6 ){
                                                scontrollerDay.animateToPage(2, duration: const Duration(milliseconds: 500),
                                                    curve: Curves.easeInOut);
                                              }
                                              else if(_valueDay<.8){
                                                scontrollerDay.animateToPage(3, duration: const Duration(milliseconds: 500),
                                                    curve: Curves.easeInOut);
                                              }
                                              else {
                                                scontrollerDay.animateToPage(4, duration: const Duration(milliseconds: 500),
                                                    curve: Curves.easeInOut);
                                              }}
                                          });
                                        }),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),

                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                ),),
              if(write_about_today[position]==1)Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child:TextField(

                    focusNode: titleFocus,

                    controller: titleController[position],
                    keyboardType: TextInputType.multiline,

                    maxLines:6,
                    onSubmitted: (text) {
                      titleFocus.unfocus();
                      ansList[position].content =
                          titleController[position].toString();
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,

                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your answer...',
                      hintStyle: TextStyle(
                          color: Colors.white60,
                          fontSize: 22,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                  ),
                ),),
              if(write_about_today[position]==0)Padding(
                padding: EdgeInsets.only(left:20,right:20,top:80),
                child: Align(

                  alignment: Alignment.center,
                  child:RaisedButton(
                    onPressed:(){
                      write_about_today[position]=1;
                    },
                    color: Colors.white30,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),

                    ),
                    textColor: Colors.white,


                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    child: new Text(
                      "Write about it",style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,


                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    ),
                  ),),),
            ]));
  }
  Widget type7widget(int position){ // Work
    return Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if(write_about_today[position]==0)Padding(
                padding: EdgeInsets.only(left:0,right:0),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 00),
                  height: 240,


                  padding: EdgeInsets.all(5.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(
                      Radius.circular((48 * .3)),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: <Widget>[

                      Expanded(
                        child:PageView.builder(
                          controller: scontrollerWork,
                          physics:new NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,


                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {



                            return _buildIconsWork(
                                index,
                                iconsListWork[index],
                                below_texsWork[index],
                                page_offsetWork-index
                            );
                          },
                        ),),
                      Container(

                        width: true
                            ? double.infinity
                            : (48) * 5.5,

                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(
                              Radius.circular((48 * .3)),
                            ),
                            color: Colors.transparent
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top:20,left:20),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${"Rate"}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,

                                ),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Expanded(
                                child: Center(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.white.withOpacity(1),
                                      inactiveTrackColor: Colors.white.withOpacity(.5),

                                      trackHeight: 4.0,
                                      thumbShape: CustomSliderThumbCircle(
                                        thumbRadius: 48 * .4,
                                        min: 1,
                                        max: 4,
                                      ),
                                      overlayColor: Colors.white.withOpacity(.4),
                                      //valueIndicatorColor: Colors.white,
                                      activeTickMarkColor: Colors.white,
                                      inactiveTickMarkColor: Colors.red.withOpacity(.7),
                                    ),
                                    child: Slider(

                                        value: _valueWork,
                                        onChanged: (value) {
                                          setState(() {
                                            _valueWork = value;
                                            ansList[current_page].a_rating=_valueWork*5;
                                            print(ansList[current_page].a_rating.toString() +" "+current_page.toString());
                                            if (_valueWork<.2 ){
                                              scontrollerWork.animateToPage(0, duration: const Duration(milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                            }
                                            else if (_valueWork<.4 ){
                                              scontrollerWork.animateToPage(1, duration: const Duration(milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                            }
                                            else if (_valueWork<.6 ){
                                              scontrollerWork.animateToPage(2, duration: const Duration(milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                            }
                                            else if(_valueWork<.8){
                                              scontrollerWork.animateToPage(3, duration: const Duration(milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                            }
                                            else {
                                              scontrollerWork.animateToPage(4, duration: const Duration(milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                            }
                                          });
                                        }),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),

                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                ),),
              if(write_about_today[position]==1)Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child:TextField(

                    focusNode: titleFocus,

                    controller: titleController[position],
                    keyboardType: TextInputType.multiline,

                    maxLines:6,
                    onSubmitted: (text) {
                      titleFocus.unfocus();
                      write_about_today[position]=0;
                      ansList[position].content =
                          titleController[position].toString();
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,

                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your answer...',
                      hintStyle: TextStyle(
                          color: Colors.white60,
                          fontSize: 22,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                  ),
                ),),
              if(write_about_today[position]==0)Padding(
                padding: EdgeInsets.only(left:20,right:20,top:80),
                child: Align(

                  alignment: Alignment.center,
                  child:RaisedButton(
                    onPressed:(){
                      write_about_today[position]=1;
                    },

                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),

                    ),
                    color: Colors.white30,
                    elevation: 0,
                    padding: const EdgeInsets.all(12.0),
                    child: new Text(
                      "Write about it",style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,


                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    ),
                  ),),),
            ]));
  }
  Widget type8widget(int position){ // Event
    return  Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left:20,right:20,bottom:12),
                child: Align(

                  alignment: Alignment.center,
                  child:RaisedButton(
                    onPressed:(){
                      Navigator.push(
                          context,
                          CupertinoPageRoute(

                              builder: (context) =>

                                  AddEventPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),

                    ),
                    textColor: Colors.white,

                    color: Colors.white30,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    child: new Text(
                      "Add an event",style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,


                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    ),
                  ),),),
              if(write_about_today[position]==1)Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child:TextField(

                    focusNode: titleFocus,

                    controller: titleController[position],
                    keyboardType: TextInputType.multiline,

                    maxLines:3,
                    onSubmitted: (text) {
                      titleFocus.unfocus();
                      ansList[position].content =
                          titleController[position].toString();
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,

                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your answer...',
                      hintStyle: TextStyle(
                          color: Colors.white60,
                          fontSize: 22,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                  ),
                ),),
              if(write_about_today[position]==0)Padding(
                padding: EdgeInsets.only(left:20,right:20,top:10),
                child: Align(

                  alignment: Alignment.center,
                  child:RaisedButton(
                    onPressed:(){
                      write_about_today[position]=1;
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),

                    ),
                    textColor: Colors.white,

                    color: Colors.white30,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    child: new Text(
                      "Write about it",style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,


                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    ),
                  ),),),
            ]));
  }
  Widget type9widget(int position){ // Expense
    DateTime today=DateTime.now();
    return  Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (expense_type==0)Padding(
                padding: EdgeInsets.only(left:20,right:20,bottom:12),
                child: Align(

                  alignment: Alignment.center,
                  child:RaisedButton(
                    onPressed:(){

                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => expenseEdit(

                              )));


                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),

                    ),
                    textColor: Colors.white,

                    color: Colors.white30,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    child: new Text(
                      "Add an expense",style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,


                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    ),
                  ),),),
             /* if(expense_type==1)Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 0, right: 0, top: 0),

                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                            ]
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 4.0, left: 8, bottom: 4, right: 8),
                          child: TextField(

                            focusNode: expenseTitleFocus,

                            controller: expenseTitle,
                            keyboardType: TextInputType.multiline,
                            cursorColor: Colors.black,
                            maxLines: 1,
                            onSubmitted: (text) {
                              expenseTitleFocus.unfocus();

                            },
                            textInputAction: TextInputAction.done,
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 20,


                                color: Colors.white54,
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Enter expense title',
                              focusColor: Colors.black,
                              hoverColor:Colors.black ,
                              hintStyle: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 20,
                                  fontFamily: 'ZillaSlab',
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                            ),
                          ),),),
                      Container(
                          margin: EdgeInsets.only(left: 0, right: 0, top: 8,bottom: 4),

                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                              ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 2, left: 8, bottom: 2, right: 8),
                            child: TextField(

                              focusNode: expenseMoneyFocus,

                              controller:expenseMoney,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,
                              maxLines:1,
                              onSubmitted: (text) {
                                expenseMoneyFocus.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 16,

                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter amount in Rs',
                                hintStyle: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                              ),
                            ),)),

                      Container(
                        height:70,
                        child: FadeAnimation(2.6, Container(

                          child:ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: catsList.length ,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {

                                return _buildCats(
                                    index,
                                    catsList[index]
                                );

                              }
                          ),)),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 0, right: 0, top: 8,bottom: 8),

                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                              ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0, left: 8, bottom: 0, right: 8),
                            child: TextField(

                              focusNode: expenseContentFocus,

                              controller:expenseContent,
                              keyboardType: TextInputType.multiline,
                              cursorColor: Colors.black,
                              maxLines:1,
                              onSubmitted: (text) {
                                expenseContentFocus.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 16,

                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter a discription',
                                hintStyle: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                              ),
                            ),)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[




                          Padding(
                            padding: EdgeInsets.only(left:20,right:20),
                            child: Align(


                              child:RaisedButton(
                                onPressed:(){
                                  expense_type=0;
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),

                                ),
                                textColor: Colors.white,

                                color: Colors.white12,
                                elevation: 0,
                                padding: const EdgeInsets.all(12),
                                child: new Text(
                                  "Back",style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 16,


                                    color: Colors.white54,
                                    fontWeight: FontWeight.w500),
                                ),
                              ),),),
                          Padding(
                            padding: EdgeInsets.only(right:20),
                            child: Align(


                              child:RaisedButton(
                                onPressed:() async {
                                  ExpenseModel new_exp=new ExpenseModel(title: expenseTitle.text,type: 1,friend_id: 0,cat_id:chosen_expense_cat,content:expenseContent.text,money: double.parse(expenseMoney.text),date: today );
                                  await NotesDatabaseService.db.addExpense(new_exp);
                                  expenseTitle.clear();
                                  expenseMoney.clear();
                                  expenseContent.clear();
                                  expenseContentFocus.unfocus();
                                  expenseMoneyFocus.unfocus();
                                  expenseTitleFocus.unfocus();
                                  expense_type=0;
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),

                                ),
                                textColor: Colors.white,

                                color: Colors.white38,
                                elevation: 0,
                                padding: const EdgeInsets.all(12),
                                child: new Text(
                                  "Save",style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 16,


                                    color: Colors.white54,
                                    fontWeight: FontWeight.w500),
                                ),
                              ),),),
                        ],)
                    ]
                ),),*/
             /* if (expense_type==0)Padding(
                padding: EdgeInsets.only(left:20,right:20,top:10),
                child: Align(

                  alignment: Alignment.center,
                  child:RaisedButton(
                    onPressed:(){
                      expense_type=2;
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),

                    ),
                    textColor: Colors.white,

                    color: Colors.white30,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    child: new Text(
                      "Gave money to a friend",style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,


                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    ),
                  ),),),*/
              /*if(expense_type==2)Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 0, right: 0, top: 0),

                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                            ]
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 4.0, left: 8, bottom: 4, right: 8),
                          child: TextField(

                            focusNode: expenseTitleFocus,

                            controller: expenseTitle,
                            keyboardType: TextInputType.multiline,
                            cursorColor: Colors.black,
                            maxLines: 1,
                            onSubmitted: (text) {
                              expenseTitleFocus.unfocus();

                            },
                            textInputAction: TextInputAction.done,
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 20,


                                color: Colors.white54,
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Enter expense title',
                              focusColor: Colors.black,
                              hoverColor:Colors.black ,
                              hintStyle: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 20,
                                  fontFamily: 'ZillaSlab',
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                            ),
                          ),),),
                      Container(
                          margin: EdgeInsets.only(left: 0, right: 0, top: 8,bottom: 4),

                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                              ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 2, left: 8, bottom: 2, right: 8),
                            child: TextField(

                              focusNode: expenseMoneyFocus,

                              controller:expenseMoney,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,
                              maxLines:1,
                              onSubmitted: (text) {
                                expenseMoneyFocus.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 16,

                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter amount in Rs',
                                hintStyle: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                              ),
                            ),)),

                      Container(
                        height:40,
                        child: FadeAnimation(2.6, Container(

                          child:ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: friendsList.length +1 ,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {

                                if (index==0){
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {


                                        _settingModalBottomSheet(context);
                                      });
                                    },
                                    child: Padding(

                                      padding:EdgeInsets.all(0),child:

                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
                                      height: 50,

                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(color: Colors.white30, width: 2),
                                        borderRadius:  BorderRadius.all( Radius.circular(10.0) ),

                                      ),

                                      child: Stack(

                                        children: <Widget>[


                                          Padding(
                                            padding: EdgeInsets.only(right:8,left:8),

                                            child:Align(

                                              alignment: Alignment.center,
                                              child: Text(
                                                "Add a friend",
                                                style: TextStyle(
                                                    color: Colors.white ,
                                                    fontFamily: 'ZillaSlab',
                                                    fontSize: 16,

                                                    fontWeight: FontWeight.w500),

                                              ),),
                                          ),



                                        ],
                                      ),
                                    ),),
                                  );
                                }

                                return _buildFriends(
                                    index - 1,
                                    friendsList[index - 1]
                                );

                              }
                          ),)),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 0, right: 0, top: 8,bottom: 8),

                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                              ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0, left: 8, bottom: 0, right: 8),
                            child: TextField(

                              focusNode: expenseContentFocus,

                              controller:expenseContent,
                              keyboardType: TextInputType.multiline,
                              cursorColor: Colors.black,
                              maxLines:1,
                              onSubmitted: (text) {
                                expenseContentFocus.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 16,

                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter a discription',
                                hintStyle: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                              ),
                            ),)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[




                          Padding(
                            padding: EdgeInsets.only(left:20,right:20),
                            child: Align(


                              child:RaisedButton(
                                onPressed:(){
                                  expense_type=0;
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),

                                ),
                                textColor: Colors.white,

                                color: Colors.white12,
                                elevation: 0,
                                padding: const EdgeInsets.all(12),
                                child: new Text(
                                  "Back",style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 16,


                                    color: Colors.white54,
                                    fontWeight: FontWeight.w500),
                                ),
                              ),),),
                          Padding(
                            padding: EdgeInsets.only(right:20),
                            child: Align(


                              child:RaisedButton(
                                onPressed:() async {
                                  ExpenseModel new_exp=new ExpenseModel(title: expenseTitle.text,type: 2,friend_id: chosen_friend,cat_id:0,content:expenseContent.text,money: double.parse(expenseMoney.text),date: today );
                                  await NotesDatabaseService.db.addExpense(new_exp);
                                  expenseTitle.clear();
                                  expenseMoney.clear();
                                  expenseContent.clear();
                                  expenseContentFocus.unfocus();
                                  expenseMoneyFocus.unfocus();
                                  expenseTitleFocus.unfocus();
                                  expense_type=0;
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),

                                ),
                                textColor: Colors.white,

                                color: Colors.white38,
                                elevation: 0,
                                padding: const EdgeInsets.all(12),
                                child: new Text(
                                  "Save",style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 16,


                                    color: Colors.white54,
                                    fontWeight: FontWeight.w500),
                                ),
                              ),),),
                        ],)
                    ]
                ),),*/
            ]));
  }
  Widget type10widget(int position){ // Activity

    return  Container(
        height: MediaQuery.of(context).size.height-250,
        child:Padding(
            padding: const EdgeInsets.only(top: 40,left: 8),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: userAct.length ,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {

                  return _buildActivies(
                      index,
                      userAct[index]
                  );

                }
            )));
  }
  Widget type0widget(int position){ // Activity

    return  Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child:TextField(

                    focusNode: titleFocus,

                    controller: titleController[position],
                    keyboardType: TextInputType.multiline,

                    maxLines:6,
                    onSubmitted: (text) {
                      titleFocus.unfocus();

                      ansList[position].content =
                          titleController[position].toString();
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,

                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your answer...',
                      hintStyle: TextStyle(
                          color: Colors.white60,
                          fontSize: 22,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                  ),
                ),),

            ]));
  }
  Widget type1widget(int position,QuestionModel this_question){ // Activity

    return  Padding(
        padding:EdgeInsets.only(left: 10),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Radio(
                    value: 0,
                    groupValue: _radioValue1,
                    activeColor: Colors.white30,
                    onChanged: (int) => _handleRadioValueChange1(0, position),
                  ),
                  new Text(
                    this_question.ans1,
                    style: new TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 22,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  new Radio(
                    value: 1,
                    activeColor: Colors.white30,
                    groupValue: _radioValue1,
                    onChanged: (int) => _handleRadioValueChange1(1, position),
                  ),
                  new Text(
                    this_question.ans2,
                    style: new TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 22,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  new Radio(
                    value: 2,
                    activeColor: Colors.white30,
                    groupValue: _radioValue1,
                    onChanged: (int) => _handleRadioValueChange1(2, position),
                  ),
                  new Text(
                    this_question.ans3,



                    style: new TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 22,
                        color: Colors.white54,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ]));
  }
  Widget type2widget(int position){ // Activity

    return  Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: true,
        child:TextField(

          focusNode: titleFocus,

          controller: titleController[position],
          keyboardType: TextInputType.number,

          maxLength: 3,
          maxLines:null,
          onSubmitted: (text) {
            titleFocus.unfocus();
            ansList[position].content =
                titleController[position].toString();
            titleFocus.unfocus();
          },
          textInputAction: TextInputAction.done,
          style: TextStyle(
              fontFamily: 'ZillaSlab',
              fontSize: 32,

              color: Colors.white54,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration.collapsed(
            hintText: 'Enter a number',
            hintStyle: TextStyle(
                color: Colors.white60,
                fontSize: 32,
                fontFamily: 'ZillaSlab',
                fontWeight: FontWeight.w500),
            border: InputBorder.none,
          ),
        ),
      ),);
  }
  Widget type3widget(int position){ // Activity

    return  Container(
        height: MediaQuery.of(context).size.height-250,
        child:Padding(
            padding: const EdgeInsets.only(top: 20,left: 8),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: userAct.length ,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {

                  return _buildActivies(
                      index,
                      userAct[index]
                  );

                }
            )));
  }
  void _settingModalBottomSheet(context) {
    FriendModel new_frd=new FriendModel(name: "",total: 0);
    showModalBottomSheet(

        context: context,

        builder: (BuildContext bc) {
          return Padding(
              padding: EdgeInsets.only(
              bottom: 0,
          left: 0,
          top: 0),
          child:Container(

            alignment: Alignment.topCenter,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft:Radius.circular((48 * .3)),
                topRight: Radius.circular((48 * .3)),
              ),
              color:Theme.of(context).primaryColor,
            ),
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 0,
                      left: 20,
                      top: 20),
                  child: TextField(
                    focusNode: FriendNameFocus,

                    controller: FriendName,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSubmitted: (text) async {
                      FriendNameFocus.unfocus();
                    new_frd.name=FriendName.text;
                    await NotesDatabaseService.db.addFriend(new_frd);
                     friendsList.add(new_frd);
                     chosen_friend=friendsList.length-1;
                      Navigator.pop(context);
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 28,
                        color: Colors.white60,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: 'type your friend name',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize:28,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('Add'),
                      onPressed: () async {
                        FriendNameFocus.unfocus();
                        new_frd.name=FriendName.text;
                        await NotesDatabaseService.db.addFriend(new_frd);
                        friendsList.add(new_frd);
                        chosen_friend=friendsList.length-1;
                        Navigator.pop(context);
                      },
                    ),
                    new RaisedButton(
                        child: new Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ],
            ),
          ));
        });
  }
  Widget _buildActivies(int index,
      UserAModel this_note) {
    String count= "";
    String image='assets/images/'+this_note.image+'.jpg';

    return Row(children: <Widget>[


      Container(
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5.0),
    height: 60,
    width: 80,
    decoration: BoxDecoration(
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
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
    BoxShadow(
    offset: Offset(0, 8),
    color: Colors.black.withAlpha(20),
    blurRadius: 16)
    ]
    ),
    child: Stack(

    children: <Widget>[

    Container(



    decoration: BoxDecoration(
    border: Border.all(color: Theme.of(context).primaryColor, width: 3),
    borderRadius:  BorderRadius.all( Radius.circular(10.0) ),
    image: DecorationImage(
    image: AssetImage(image),
    fit: BoxFit.cover
    )
    )


    ),

    Padding(
    padding: EdgeInsets.all(4),

    child:Align(

    alignment: Alignment.center,
    child: Text(
    this_note.name,
    style: TextStyle(
    color: Colors.white ,
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

    ),),
    ),


    ],
    ),
    ),
      Container(

        width:MediaQuery.of(context).size.width-120,

        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(
              Radius.circular((48 * .3)),
            ),
            color: Colors.transparent
        ),
        child: Padding(
          padding: EdgeInsets.only(top:20,left:20),
          child: Row(
            children: <Widget>[
              Text(
                '${"Hrs"}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,

                ),
              ),
              SizedBox(
                width: 1,
              ),
              Expanded(
                child: Center(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white.withOpacity(1),
                      inactiveTrackColor: Colors.white.withOpacity(.5),

                      trackHeight: 4.0,
                      thumbShape: CustomSliderThumbCircleText(
                        thumbRadius: 48 * .4,
                        min: 0,
                        max:10,
                      ),
                      overlayColor: Colors.white.withOpacity(.4),
                      //valueIndicatorColor: Colors.white,
                      activeTickMarkColor: Colors.white,
                      inactiveTickMarkColor: Colors.red.withOpacity(.7),
                    ),
                    child: Slider(

                        value: _value_act[index],
                        onChanged: (value) {
                          setState(() {
                            _value_act[index] = value;

                          });
                        }),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),

            ],
          ),
        ),
      ),

    ],) ;


  }
  Widget _buildCats(int index,
      CatModel this_cat) {
    String count= "";
    String image=this_cat.image;

    return GestureDetector(
      onTap: () {
        setState(() {

          chosen_expense_cat=index;

        });
      },
      child: Padding(

        padding:EdgeInsets.all(0),child:

      Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
        height: 120,

        decoration: BoxDecoration(
          color: (chosen_expense_cat==index)?Colors.white60:Colors.transparent,
          border: Border.all(color: Colors.white30, width: 2),
          borderRadius:  BorderRadius.all( Radius.circular(10.0) ),

        ),

        child: Stack(

          children: <Widget>[

            Container(
              padding: EdgeInsets.only(top:2,right:8,left:8),




                child:Icon(toic(image)),
            ),
            Padding(
              padding: EdgeInsets.only(top:14,right:8,left:8),

              child:Align(

                alignment: Alignment.bottomLeft,
                child: Text(
                  this_cat.name,
                  style: TextStyle(
                      color: Colors.white ,
                      fontFamily: 'ZillaSlab',
                      fontSize: 12,

                      fontWeight: FontWeight.w500),

                ),),
            ),



          ],
        ),
      ),),
    );
  }
  Widget _buildFriends(int index,
      FriendModel this_cat) {
    String count= "";


    return GestureDetector(
      onTap: () {
        setState(() {

          chosen_friend=index;

        });
      },
      child: Padding(

        padding:EdgeInsets.all(0),child:

      Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
        height: 120,

        decoration: BoxDecoration(
          color: (chosen_friend==index)?Colors.white60:Colors.transparent,
          border: Border.all(color: Colors.white30, width: 2),
          borderRadius:  BorderRadius.all( Radius.circular(10.0) ),

        ),

        child: Stack(

          children: <Widget>[


            Padding(
              padding: EdgeInsets.only(right:8,left:8),

              child:Align(

                alignment: Alignment.center,
                child: Text(
                  this_cat.name,
                  style: TextStyle(
                      color: Colors.white ,
                      fontFamily: 'ZillaSlab',
                      fontSize: 16,

                      fontWeight: FontWeight.w500),

                ),),
            ),



          ],
        ),
      ),),
    );
  }
  IconData toic(String str){


    if (str=="Icons.restaurant") return (Icons.restaurant);
    else  if (str=="Icons.receipt") return (Icons.receipt);
    else if (str=="Icons.movie_filter") return (Icons.movie_filter);
    else  if (str=="Icons.healing") return (Icons.healing);
    else if (str=="Icons.directions_bus") return (Icons.directions_bus);
    else  if (str=="Icons.ev_station") return (Icons.ev_station);
    else  if (str=="Icons.local_atm") return (Icons.local_atm);
    else  if (str=="Icons.trending_up") return (Icons.trending_up);
    else  if (str=="Icons.home") return (Icons.home);
    else  if (str=="Icons.library_books") return (Icons.library_books);
    else  if (str=="Icons.scatter_plot") return (Icons.scatter_plot);

    else return Icons.scatter_plot;
  }
  Widget  _buildIconsWork(int index, IconData this_icon, String bottom_text,
      double offset) {
    double gauss = exp(-(pow((offset.abs() - 0.5), 2) /
        0.08)); //<--caluclate Gaussian function
    return Transform.scale(
      scale: 1 / (0.6 + offset.abs()),
      child: GestureDetector(


        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          height: 102,
          width: 75,
          decoration: BoxDecoration(
            color
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(-32 * gauss * offset.sign, 0),
                child: Padding(

                    padding: EdgeInsets.only(
                        left: 8, bottom: 0, top: 20, right: 8),
                    child: Align(
                      alignment: Alignment(offset, 0),
                      child: Icon(this_icon, size: 48,color: Colors.white54,
                      ),)

                ),),
              Transform.translate(
                offset: Offset(-32 * gauss * offset.sign, 0),

                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8, bottom: 20, top: 8, right: 8),
                  child: AnimatedDefaultTextStyle(
                    style: offset == 0
                        ? TextStyle(
                        fontSize: 10,
                        color: Colors.white,

                        fontWeight: FontWeight.w500)
                        : TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                    duration: const Duration(milliseconds: 200),
                    child: Text(bottom_text, textAlign: TextAlign.center,),
                  ),
                ),)
            ],
          ),
        ),
      ),);
  }
  Widget  _buildIconsDay(int index, IconData this_icon, String bottom_text,
      double offset) {
    double gauss = exp(-(pow((offset.abs() - 0.5), 2) /
        0.08)); //<--caluclate Gaussian function
    return Transform.scale(
      scale: 1 / (1+ offset.abs()),
      child: GestureDetector(


        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          height: 102,
          width: 75,
          decoration: BoxDecoration(
            color
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(-32 * gauss * offset.sign, 0),
                child: Padding(

                    padding: EdgeInsets.only(
                        left: 8, bottom: 0, top: 20, right: 8),
                    child: Align(
                      alignment: Alignment(offset, 0),
                      child: Icon(this_icon, size:70,color: Colors.white54,
                      ),)

                ),),
              Transform.translate(
                offset: Offset(-32 * gauss * offset.sign, 0),

                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8, bottom: 20, top: 8, right: 8),
                  child: AnimatedDefaultTextStyle(
                    style: offset == 0
                        ? TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'ZillaSlab',

                        fontWeight: FontWeight.w500)
                        : TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'ZillaSlab',
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                    duration: const Duration(milliseconds: 200),
                    child: Text(bottom_text, textAlign: TextAlign.center,),
                  ),
                ),)
            ],
          ),
        ),
      ),);
  }

  void startTimer() {
    started=1;

    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
              if (front==0){

                _start = _start + 1;
                Duration d=Duration(seconds: _start);
                min=d.inMinutes;
                sec=d.inSeconds.remainder(60);
              }

          else if (_start < 1 ) {
            setState(() {
              front =0;
            });

            _start=_extra;

          } else if (front ==1) {
            _start = _start - 1;
            Duration d=Duration(seconds: _start);
            min=d.inMinutes;
            sec=d.inSeconds.remainder(60);
          }
        },
      ),
    );
  }

  void handleSave() async {
    DateModel this_date;

    DateTime date = widget.setDate;

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
      });
    }
    this_date.survey=1;
    await NotesDatabaseService.db.updateDateInDB(this_date);


    for (var i = 0; i < quesList.length; i++) {
      quesList[i].last_date=DateTime.now();
      print(ansList[i].content);
      print(ansList[i].a_rating);
      print(titleController[i].text);
      ansList[i].date=date;
      ansList[i].q_id=quesList[i].id;

      ansList[i].discription=quesList[i].title;
      ansList[i].content=titleController[i].text;
      await NotesDatabaseService.db.updateQuestionInDB(quesList[i]);
      await NotesDatabaseService.db.addAnswerInDB(ansList[i]);
      print("fianlly "+ ansList[i].content);
    }
    for (var i=0;i<userAct.length;i++){
      print(_value_act[i]);
      AlogModel entry = new AlogModel(a_id:userAct[i].a_id,date:DateTime.now(),duration: Duration(hours: (_value_act[i]*10).floor()).inMinutes);
      await NotesDatabaseService.db.addActivityLogInDB(entry);
    }
    Navigator.pop(context);
    Navigator.push(context,
        FadeRoute(page: SurveyEnd(date: widget.setDate,)));
  }
}