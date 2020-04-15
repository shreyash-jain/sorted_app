import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/LibraryQuestion.dart';
import 'package:notes/screens/QuestionForm.dart';
import 'package:page_transition/page_transition.dart';



class SurveyHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SurveyHomePage> with TickerProviderStateMixin {
  PageController _pageController;

  AnimationController rippleController;
  AnimationController scaleController;
  ThemeData theme = appThemeLight;
  Animation<double> rippleAnimation;
  Animation<double> scaleAnimation;
  static var formatter = new DateFormat('MMMM\nEEEE d');
  static DateTime TofillDate=DateTime.now();
  String formatted=formatter.format(TofillDate);



  Shader linearGradient;

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
            FadeRoute(page: DisplayQuestions(changeTheme: setTheme)));
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

    scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 30.0
    ).animate(scaleController);

    rippleController.forward();
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
            padding: EdgeInsets.all(40),
            child: ListView(

              children: <Widget>[
                SizedBox(height: 40,),
                Row(
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
                             formatted = formatter.format(ndate);
                           });
                          }
                        } ,
                        child:Icon(Icons.play_arrow,size:60,color: Colors.blue.withOpacity(.8),))

                  ],
                ),

                SizedBox(height: 40,),
                Row(
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
                ),
                SizedBox(height: 30,),
            GestureDetector(
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
                    ))),

                GestureDetector(
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
                        ))),

                SizedBox(height: 100,),

                SizedBox(height: 12,),
    FadeAnimation(1.6, Container(child:Align(
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
                )),)
              ],
            ),
          ),
        )
    );

  }
}
