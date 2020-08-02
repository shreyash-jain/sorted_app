
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/LibraryCards.dart';
import 'package:notes/components/animated_button.dart';
import 'package:notes/components/bookcards.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/animated-wave.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/screens/home.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'QuestionForm.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/bookcards.dart';
import 'dart:convert' as convert;
class SurveyEnd extends StatefulWidget {
  Function() triggerRefetch;
  Function(Brightness brightness) changeTheme;
  DateTime date;

  SurveyEnd(
      {Key key,
        Function() triggerRefetch,
        this.title,
        this.date,
        Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.triggerRefetch = triggerRefetch;
  }

  final String title;

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<SurveyEnd> {
  PageController _pageController;
  ThemeData theme = appThemeLight;
  final scontrollerDay =
  PageController(viewportFraction: 0.3, initialPage: 5, keepPage: true);
  FocusNode titleFocus = FocusNode();
  final _random = new Random();
  List<String> ImagesUrl=["https://picsum.photos/510/370"];
  double page_offset=0 ;
  int current_position=0;
  TextEditingController titleController = TextEditingController();
  var formatter_month = new DateFormat('d MMMM EEEE');
  String date_month;

  @override
  void initState() {
    super.initState();
    date_month=formatter_month.format(widget.date);
    NotesDatabaseService.db.init();
    scontrollerDay.addListener(() {
      setState(() =>
      page_offset = scontrollerDay.page); //<-- add listener and set state
    });
    getImages();



  }
  int next(int min, int max) => min + _random.nextInt(max - min);
  getImages() async {
    int i=0;
    int rand=next(1,100);

    ImagesUrl=await NotesDatabaseService.db.getPlaceHolders();


   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Theme.of(context).primaryColor,

      body:Container(
    height: MediaQuery.of(context).size.height ,
    decoration: BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0)),
    ),

    child:AnimatedContainer(

        duration: Duration(milliseconds: 200),
        child: Stack(

          children: <Widget>[
            onBottom(FadeAnimation(1, Container(child:AnimatedWave(
              height:250,
              speed: 0.9,
              offset: pi,
            )))),
            onBottom(FadeAnimation(1, Container(child:AnimatedWave(
              height: 390,
              speed: .7,
              offset: pi/2,

            )))),
            onBottom(FadeAnimation(1, Container(child:AnimatedWave(
              height: 130,
              speed: .7,
              offset: pi/4,
            )))),

            AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.decelerate,
                height:190,
                margin: EdgeInsets.only(top:40, bottom: 0, left: 0,right:0),

                child: Container(
                  height: 210,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(top:0,bottom: 0),
                  decoration:
                  new BoxDecoration(
                    borderRadius: new BorderRadius.only(topLeft:  Radius.circular(0.0),topRight:   Radius.circular((0)),bottomLeft:   Radius.circular((0)),bottomRight:   Radius.circular((0)),),

                  ),
                  child:Padding(
                    padding: EdgeInsets.only(left: 0),
                    child:PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 12 ,
                        controller: scontrollerDay,



                        onPageChanged: (int page){
                          setState(() {


                            current_position=page;


                          });


                          setState(() {






                          });

                        },
                        itemBuilder: (BuildContext context, int index) {


                          return _buildBigActivityCard(
                              index,

                              page_offset-index
                          );

                        }
                    ),),)),
            Align(
                alignment: Alignment.topCenter,
                child:AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.decelerate,
                  margin: EdgeInsets.only(top: 250),

                  height: 200,
                  width: 200,

                  decoration:
                  new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(50.0)),

                    color: Colors.white60,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(8, 0),
                          color: Colors.black.withAlpha(30),
                          blurRadius: 16)
                    ],
                  ),


                )

            ),
            Hero(
                tag: "survey",
                transitionOnUserGestures: true,
                child:Align(
                    alignment: Alignment.topCenter,
                    child:AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.decelerate,
                        margin: EdgeInsets.only(top: 250),

                        height:100,
                        width: 160,

                        decoration:
                        new BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(40.0)),

                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 8),
                                color: Colors.black.withAlpha(20),
                                blurRadius: 16)
                          ],
                        ),

                        child:Column(

                          children: <Widget>[

                            SizedBox(height: 6,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                AnimatedContainer(
                                    duration: Duration(milliseconds: 600),
                                    curve: Curves.decelerate,
                                    padding: EdgeInsets.all(8),



                                    decoration:
                                    new BoxDecoration(
                                      borderRadius: new BorderRadius.all(Radius.circular(20.0)),

                                      color: Colors.blue,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 8),
                                            color: Colors.black.withAlpha(20),
                                            blurRadius: 16)
                                      ],
                                    ),

                                    child:Icon(Icons.move_to_inbox)
                                ),
                                AnimatedContainer(
                                    duration: Duration(milliseconds: 600),
                                    curve: Curves.decelerate,
                                    padding: EdgeInsets.all(8),



                                    decoration:
                                    new BoxDecoration(
                                      borderRadius: new BorderRadius.all(Radius.circular(20.0)),

                                      color: Colors.blue,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 8),
                                            color: Colors.black.withAlpha(20),
                                            blurRadius: 16)
                                      ],
                                    ),

                                    child:                    Text('18 coins',textAlign: TextAlign.center,   style: TextStyle(

                                        color: Colors.white.withOpacity(.75) ,

                                        fontFamily: 'ZillaSlab',
                                        fontSize:18,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 30.0,
                                            color: Colors.white,
                                            offset: Offset(1.0,1.0),
                                          ),
                                        ],

                                        fontWeight: FontWeight.w500),)
                                ),

                              ],)

                          ],)

                    )

                )),
            Align(
                alignment: Alignment.bottomCenter,
                child:AnimatedContainer(
              duration: Duration(milliseconds:300),
              curve: Curves.easeInOutQuad,
              height:MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.height/3,

              margin: EdgeInsets.only(right: 0,top:2,bottom:20,left:0),


              child: Stack(

                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),


                      child:FadeInImage(

                        height: MediaQuery.of(context).size.height/2,
                        width: double.infinity,
                        placeholder:
                        new AssetImage("assets/images/one.jpg"),
                        image: new NetworkImage(ImagesUrl[page_offset.floor()]),

                        fit: BoxFit.fill,

                      )),




                  Container(



                      decoration: BoxDecoration(
                        // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                        borderRadius:  BorderRadius.all( Radius.circular(20.0) ),
                        border: Border.all(color: Theme.of(context).primaryColor, width:3),
                        color: Colors.black.withOpacity(.65),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black.withAlpha(80),
                              blurRadius: 4)
                        ],
                      ),


                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(

                            padding:EdgeInsets.only(left:16,right:16),
                            child:Text(
                              "Survey completed,",
                              textAlign: TextAlign.left,
                              style: TextStyle(


                                  fontFamily: 'ZillaSlab',
                                  fontSize: 24,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 20.0,
                                      color: Colors.black38,
                                      offset: Offset(1.0,1.0),
                                    ),
                                  ],

                                  fontWeight: FontWeight.w500),

                            )),
                        SizedBox(height:10,),
                        Padding(

                            padding:EdgeInsets.only(left:16,right:16),
                            child:Text(
                              date_month,
                              textAlign: TextAlign.center,
                              style: TextStyle(


                                  fontFamily: 'ZillaSlab',
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 20.0,
                                      color: Colors.white,
                                      offset: Offset(1.0,1.0),
                                    ),
                                  ],

                                  fontWeight: FontWeight.w800),

                            )),
                      SizedBox(height: 40,),
                      Padding(

                          padding:EdgeInsets.only(left:16,right:16),
                          child:TextField(


                        focusNode: titleFocus,

                        controller: titleController,
                        keyboardType: TextInputType.multiline,

                        maxLines:2,
                        maxLength: 22,
                        onSubmitted: (text) {

                        },
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 20,

                            color: Colors.white54,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enter a title\nto this day',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w500),
                          border: InputBorder.none,
                        ),
                      )),
                    ],)

                  ),






















                ],
              ),
            )),







          ],
        ),

      ),)
    );
  }



  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );

  Widget _buildBigActivityCard(int index,
    double offset) {



    double gauss = exp(-(pow((offset.abs() - 0.5), 2) /
        0.08));

    int id=next(1,1084);











    String count= "";

    return Transform.scale(
        scale:50 / (50 + 5*offset.abs()),
        child:GestureDetector(
          onTap: () {
            setState(() {


              current_position=index;

            });



            setState(() {

            });
          },
          child: Padding(

            padding:EdgeInsets.only(),

            child:

          AnimatedContainer(
            duration: Duration(milliseconds:300),
            curve: Curves.easeInOutQuad,


            margin: EdgeInsets.only(right:(offset==1)?10: 0,top:(offset!=0)?10:2,bottom:(offset!=0)?10:2,left:(offset==-1)?10:0),


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


                    child:(ImagesUrl==null ||  ImagesUrl.length<1+index)?Container():ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),

                        child:FadeInImage(

                          height: 200,
                          width: double.infinity,
                          placeholder:
                          new AssetImage("assets/images/one.jpg"),
                          image: new NetworkImage(ImagesUrl[index]),

                          fit: BoxFit.fill,

                        ))
                ),



                if (offset==0)Padding(
                  padding: EdgeInsets.only(bottom:30),

                  child:Align(

                    alignment: Alignment.bottomCenter,
                    child: Icon(Icons.check,color:Colors.black.withOpacity(.5),size: 120,),

                  ),),
















              ],
            ),
          ),),
        ));
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
