import 'dart:collection';
import 'dart:math';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/LibraryQuestion.dart';
import 'package:notes/screens/QuestionForm.dart';
import 'package:notes/services/database.dart';




class SurveyHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SurveyHomePage> with TickerProviderStateMixin {
  PageController _pageController;
  double page_offset = 6;
  AnimationController rippleController;
  AnimationController scaleController;
  ThemeData theme = appThemeLight;
  final _random = new Random();
  Animation<double> rippleAnimation;
  Animation<double> scaleAnimation;
  static var formatter = new DateFormat('MMMM\nEEEE d');
  static DateTime TofillDate=DateTime.now();
  String formatted=formatter.format(TofillDate);
  HashMap DateTime_survey = new HashMap<String, int>();
  ScrollController _controller = ScrollController(initialScrollOffset: 3180);
  final scontrollerDay =
  PageController(viewportFraction: 0.5, initialPage: 6, keepPage: false);
  int show_button=1;
  DateTime today=DateTime.now();
  var formatter_date_builder = new DateFormat('EEE, d');
  var formatter_day = new DateFormat('d');
  var formatter_year = new DateFormat('yyyy');
  var formatter_day_name = new DateFormat('EEEE');
  var formatter_month = new DateFormat('MMMM');
  ScrollController _scrollController = new ScrollController();
  List<String> ImagesUrl=["https://i.picsum.photos/id/18/200/300.jpg","https://i.picsum.photos/id/14/200/300.jpg","https://i.picsum.photos/id/17/200/300.jpg","https://i.picsum.photos/id/108/200/300.jpg","https://i.picsum.photos/id/84/200/300.jpg","https://i.picsum.photos/id/108/200/300.jpg","https://i.picsum.photos/id/104/200/300.jpg"];

  Shader linearGradient;
  var formatterDate = new DateFormat('dd-MM-yyyy');
  int current_position=-1;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
        initialPage: 0
    );

    rippleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1)
    );

    scaleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1)
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {

        Navigator.pop(context);
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
    getPastWeek();
    getImages();
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
  void dispose() {
    rippleController.dispose();
    _pageController.dispose();
    scaleController.dispose();
    super.dispose();
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
      body: PageView(
        controller: _pageController,

        children: <Widget>[
          makePage(image: 'assets/images/one.jpg'),


        ],
      ),
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
  Widget makePage({image}) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover
            )
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(.3),
                    Colors.black.withOpacity(.3),
                  ]
              )
          ),
          child: Padding(
            padding: EdgeInsets.all(0),
            child: ListView(


              controller: _scrollController,

              children: <Widget>[
                SizedBox(height: 10,),
                Padding(
                    padding: EdgeInsets.only(left:40,right:20,top:20,bottom: 20),child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(formatted, style: TextStyle(fontFamily: 'ZillaSlab',
                      fontSize: 32.0,
                      foreground: Paint()..shader = linearGradient,
                      fontWeight: FontWeight.bold,),),
                    GestureDetector(
                        onTap:() async {
                          final DateTime ndate = await showDatePicker(
                              context: context,


                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(new Duration(days: 30)),
                              lastDate:DateTime.now().add(new Duration(days: 0)));
                          if (ndate != null ){

                            var formatter = new DateFormat('MMMM\nEEEE d');

                           setState(() {
                             TofillDate=ndate;
                             formatted = formatter.format(ndate);
                             show_button=DateTime_survey[formatterDate.format(TofillDate)];
                             print(show_button);
                           });
                          }
                        } ,
                        child:Icon(Icons.play_arrow,size:60,color: Colors.blue.withOpacity(.8),))

                  ],
                )),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  margin: EdgeInsets.only(top:0, bottom: 0, left: 0,right:0),

                  child: Container(
                      height: 100,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(8),
                      decoration:
                      new BoxDecoration(
                        borderRadius: new BorderRadius.only(topLeft:  Radius.circular(0.0),topRight:   Radius.circular((0)),bottomLeft:   Radius.circular((0)),bottomRight:   Radius.circular((0)),),
                        gradient: new LinearGradient(
                            colors: [
                              Colors.black45,

                              Colors.black12,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.00),
                            stops: [0.0,1.0],
                            tileMode: TileMode.clamp),
                      ),
                child:Padding(
                  padding: EdgeInsets.only(left: 0),
                  child:ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7 ,
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {

                        return _buildActivityCard(
                            index,
                            today.subtract(Duration(days: 6-index))
                        );

                      }
                  ),),)),
                AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.decelerate,
                    height: (current_position==-1)?0:360,
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
                                formatted = formatter.format(this_date);

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
                SizedBox(height: 10,),
                Padding(
                    padding: EdgeInsets.only(left:40,right:40,top:0),child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("15", style: TextStyle( fontFamily: 'ZillaSlab',color:Colors.white.withOpacity(.9),fontSize: 40, fontWeight: FontWeight.bold),),
                        Text("Minutes", style: TextStyle( fontFamily: 'ZillaSlab',color:Colors.white.withOpacity(.6),fontSize: 30),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("9", style: TextStyle( fontFamily: 'ZillaSlab',color:Colors.white.withOpacity(.9),fontSize: 40, fontWeight: FontWeight.bold),),
                        Text("Questions", style: TextStyle( fontFamily: 'ZillaSlab',color:Colors.white.withOpacity(.6),fontSize: 30),),
                      ],
                    ),
                  ],
                )),
                SizedBox(height: 30,),
                Padding(
                    padding: EdgeInsets.only(left:40,right:40,top:00),child:GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: LibraryQuestion(

                          )));
                },

                child:Container(
                    margin: EdgeInsets.fromLTRB(10, 8, 10, 8),

                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black26,
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        padding: EdgeInsets.only(top:8,bottom:8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                                        'Questions from library',
                                        style: TextStyle(
                                            fontFamily: 'ZillaSlab',
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 18),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )))),

                Padding(
                    padding: EdgeInsets.only(left:40,right:40,top:00),child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: EditQuestionPage(

                              )));
                    },

                    child:Container(
                        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),

                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black26,
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            padding: EdgeInsets.only(top:8,bottom:8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
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
                                            'Custom Question',
                                            style: TextStyle(
                                                fontFamily: 'ZillaSlab',
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 18),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )))),

                if (show_button==0)SizedBox(height: 50,),

                if (show_button==0)SizedBox(height: 12,),
                if (show_button==0)FadeAnimation(.8, Container(child:Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedBuilder(
                    animation: rippleAnimation,
                    builder: (context, child) => Container(
                      width: rippleAnimation.value,
                      height: rippleAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withOpacity(.4)
                        ),
                        child: InkWell(
                          onTap: () {
                            scaleController.forward();
                          },
                          child: AnimatedBuilder(
                            animation: scaleAnimation,
                            builder: (context, child) => Transform.scale(
                              scale: scaleAnimation.value,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )



                ),),

                if (show_button==1)SizedBox(height: 50,),
                if (show_button==1) Padding(
                padding: EdgeInsets.only(left:40,right:40,top:00),child:AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 1000),
                  decoration: BoxDecoration(
                    color
                        : Colors.white54,
                    border: Border.all(width:4,
                        color: Colors.blueAccent,),
                    borderRadius: BorderRadius.all(
                        Radius.circular(16)),
                  ),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                     Icons.check,
                      size: 60,
                      color: Colors.white,
                    ),

                    SizedBox(
                      width:  30.0 ,
                    ),
    Text(
   "Done",
    style: TextStyle(
    fontFamily: 'ZillaSlab',
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize:28),
    )
                  ],
                ),),),
              ],
            ),
          ),
        )
    );

  }
  Widget _buildActivityCard(int index,
      DateTime this_date) {
    String day=formatter_date_builder.format(this_date);
    if (index==6)day="Today";
    IconData myIcon=Icons.check_circle;
    if (DateTime_survey[formatterDate.format(this_date)]==0)
      myIcon=Icons.cancel;


    String count= "";

    return GestureDetector(
      onTap: () {
        setState(() {


          current_position=index;
          scontrollerDay.animateToPage(index,
            duration: Duration(milliseconds:800),
            curve: Curves.easeInOut,
          );

        });


        setState(() {
          TofillDate = this_date;
          formatted = formatter.format(this_date);

          show_button=DateTime_survey[formatterDate.format(TofillDate)];

        });
        setState(() {

        });
      },
      child: Padding(

        padding:EdgeInsets.only(),child:Container(
        margin: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
        height: 100,
        width: 100,

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
                    borderRadius:  BorderRadius.all( Radius.circular(10.0) ),
                    color: (current_position==index)?Theme.of(context).primaryColor.withOpacity(.1):Colors.transparent
                )


            ),

            Padding(
              padding: EdgeInsets.all(4),

              child:Align(

                alignment: Alignment.topCenter,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(

                      color: (index==6)?Colors.white70:Colors.white38 ,
                      fontFamily: 'ZillaSlab',
                      fontSize: 24,

                      fontWeight: (index==6)?FontWeight.bold:FontWeight.w500),

                ),),
            ),


        Padding(
          padding: EdgeInsets.all(0),
          child:Align(

                alignment: Alignment.bottomCenter,child:
            AnimatedContainer(

              alignment: Alignment.bottomCenter,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds:400),
                width: index==current_position?45:30,
                height: index==current_position?45:30,


                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.4), width: index==current_position?0:3),
                    borderRadius: index==current_position? BorderRadius.all( Radius.circular(40.0) ): BorderRadius.all( Radius.circular(40.0)),

                ),

                    child:   new LayoutBuilder(builder: (context, constraint) {
            return new Icon(myIcon, size: constraint.biggest.height);

          }),



            ))),






          ],
        ),
      ),),
    );
  }
  int next(int min, int max) => min + _random.nextInt(max - min);


  Widget _buildBigActivityCard(int index,
      DateTime this_date,double offset) {
    double gauss = exp(-(pow((offset.abs() - 0.5), 2) /
        0.08));

    int id=next(1,1084);



    String day=formatter_date_builder.format(this_date);
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
        scale:1 / (1 + 0.2*offset.abs()),
        child:GestureDetector(
      onTap: () {
        setState(() {


          current_position=index;

        });


        setState(() {
          TofillDate = this_date;
          formatted = formatter.format(this_date);

          show_button=DateTime_survey[formatterDate.format(TofillDate)];

        });
        setState(() {

        });
      },
      child: Padding(

        padding:EdgeInsets.only(),child:Container(
        margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0),


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
                ),
                child:ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),child:FadeInImage(

                  placeholder:
                  new AssetImage("assets/images/SortedLogo.png"),
                  image: new NetworkImage(ImagesUrl[index]),

                  fit: BoxFit.cover,

                ))


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
          offset: Offset(
              100 * gauss * offset.sign, 0),
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
                offset: Offset(20 * gauss * offset.sign, 0),
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
                                 _scrollController.animateTo(
                                  500,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                                scaleController.forward();
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
}
