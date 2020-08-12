import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/components/animated_button.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/activity.dart';
import 'package:notes/data/animated-wave.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/data/user_activity.dart';
import 'package:notes/main.dart';

import 'package:notes/screens/home.dart';
import 'package:notes/services/auth.dart';
import 'package:notes/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/FadeAnimation.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends  State<IntroductionScreen>
    with TickerProviderStateMixin {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Animation<double> scaleAnimation;
  AnimationController scaleController;
  Animatable<Color> background;
  SharedPreferences prefs;
  AnimationController rippleController;
  Animation<double> rippleAnimation;
  ThemeData theme = appThemeLight;
  List<String> ActivityList = [
    'male1',
    'female1',
    'male2',
    'female2',
    'male3',
    'female3'
  ];
  TextEditingController nameController = TextEditingController();
  List<ActivityModel> AllActivityList = [];
  List<ActivityModel> AlladdedList = [];
  FocusNode nameFocus = FocusNode();
  bool old_user = false;
  int startPage=0;
  String avatar = 'assets/images/male1.png';
  int avatar_position = -1;
  bool _loading;
  double _progressValue;

  var activity_position;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  void initState() {
    _initialize();
    super.initState();
    scaleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              Navigator.of(context).pop();
              Navigator.push(context, FadeRoute(page: MyApp(false)));
            }
          });
    _loading = false;
    _progressValue = 0.0;
    rippleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    rippleAnimation =
        Tween<double>(begin: 80.0, end: 90.0).animate(rippleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              rippleController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              rippleController.forward();
            }
          });
    getStarted();

    scaleAnimation =
        Tween<double>(begin: 1.0, end: 35.0).animate(scaleController);
    rippleController.forward();
    _loading = !_loading;
    _progressValue = 0;

  }

  get_ActivityModel() async {
    var fetchedDate = await NotesDatabaseService.db.getActiviyAfterFromDB(8);
    setState(() {
      AllActivityList = fetchedDate;
      print("hello "+AllActivityList.length.toString());
      activity_position =
          new List<int>.filled(AllActivityList.length, 0, growable: true);
    });
  }

  void dispose() {
    rippleController.dispose();
    _pageController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  setInitials() {
    nameController.text = prefs.getString("google_name");
    old_user = prefs.getBool("old_user");
    if (old_user){
      _updateProgress();
      setState(() {
        startPage=1;
      });


    }
    if (!old_user){
      setState(() {
        startPage=2;
      });

      _updateProgressFirstTime();}
  }

  void _initialize() {
    background = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Color(0xFF4563DB),
          end: Colors.deepPurple[400],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.deepPurple[400],
          end: Colors.orange[400],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.orange[400],
          end: Colors.blue[400],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.blue[400],
          end: Colors.orange[400],
        ),
      ),
    ]);
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      height: 8.0,
      width: isActive ? 16.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  void reassemble() {
    _initialize();
    super.reassemble();
  }

  getStarted() async {
    prefs = await SharedPreferences.getInstance();
    setInitials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.9],
              colors: [
                Color(0xFF4563DB),
                Theme.of(context).primaryColor,
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    final color = _pageController.hasClients
                        ? _pageController.page / 4
                        : .0;

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color:
                            background.evaluate(AlwaysStoppedAnimation(color)),
                      ),
                      child: child,
                    );
                  },
                  child: PageView(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      nameFocus.unfocus();
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: FadeAnimation(
                                1.6,
                                Container(
                                  child: Text(
                                    'It was very nice\nmeeting you\n\nso what do i call you ...\nlike you have any nickname?',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(.8)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 340),
                              child: FadeAnimation(
                                  4.2,
                                  Container(
                                    child: TextField(
                                      focusNode: nameFocus,
                                      controller: nameController,
                                      maxLength: 16,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      onSubmitted: (text) {
                                        nameFocus.unfocus();
                                      },
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontSize: 32,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w500),
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Enter your name',
                                        hintStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 32,
                                            fontFamily: 'ZillaSlab',
                                            fontWeight: FontWeight.w500),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 30),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: FadeAnimation(
                                1.6,
                                Container(
                                  child: Text(
                                    'I am trying to imagine you :-)\n\nPlease help, which avatar suits you more ?',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(.8)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0, top: 280),
                              child: Container(
                                height: 150,
                                child: FadeAnimation(
                                    2.6,
                                    Container(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: ActivityList.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buildCategoryCard2(
                                                index, ActivityList[index]);
                                          }),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40.0, top: 30),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: FadeAnimation(
                                1.6,
                                Container(
                                  child: Image(
                                    image: AssetImage(
                                      avatar,
                                    ),
                                    height: 75,
                                    width: 75,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 110),
                              child: FadeAnimation(
                                1.6,
                                Container(
                                  child: Text(
                                    'Please tell me about some of your hobbies\nAdd all those hobbies you do or you want learn it as a skill',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(.8)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0, top: 250),
                              child: Container(
                                height: 200,
                                child: FadeAnimation(
                                    2.6,
                                    Container(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: AllActivityList.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buildActivityCard(
                                                index, AllActivityList[index]);
                                          }),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0, top: 480),
                              child: Container(
                                height: 50,
                                child: FadeAnimation(
                                    2.6,
                                    Container(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: AlladdedList.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return _buildAddedCard(
                                                index, AlladdedList[index]);
                                          }),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40.0, top: 30),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: FadeAnimation(
                                1.6,
                                Container(
                                  child: Image(
                                    image: AssetImage(
                                      avatar,
                                    ),
                                    height: 75,
                                    width: 75,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 140, right: 60),
                              child: FadeAnimation(
                                2.6,
                                Container(
                                  child: Text(
                                    nameController.text +
                                        ', it was a pleasure knowing you, As you need food to live, I need your regular data\nto help you track, analyse and organize your life.',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(.8)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 270, right: 20),
                              child: FadeAnimation(
                                  2.6,
                                  Container(
                                      child: Text(
                                    'To make this process easier we smarty set a small daily survey to know about your life',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black.withOpacity(.5)),
                                  ))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 370),
                              child: FadeAnimation(
                                2.6,
                                Container(
                                  child: Text(
                                    'We will remind you to fill it everyday before you sleep',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(.8)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, right: 30),
                child: Align(
                  alignment: FractionalOffset.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _buildPageIndicator(),
                  ),
                ),
              ),
              _currentPage != _numPages - 1
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: ()  {
                              if (_currentPage > 0) {
                                _pageController.animateToPage(
                                  _currentPage - 1,
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                );
                              }

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.white.withOpacity(.4),
                                  size: 50.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_currentPage < 3)
                          Align(
                            alignment: FractionalOffset.bottomRight,
                            child: FlatButton(
                              onPressed: () async {
                                _pageController.animateToPage(
                                  _currentPage + 1,
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                );
                                if
                                (_currentPage==1)
                                  await get_ActivityModel();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    )
                  : Text(''),
              if (startPage==1)
                Container(
                  padding: EdgeInsets.all(32),
                  alignment: Alignment.center,
                  color: Colors.blueGrey.withOpacity(.95),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Welcome back',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60),
                          children: <TextSpan>[
                            TextSpan(
                                text: '\n${nameController.text}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32)),
                            TextSpan(
                                text:
                                    '\n\nLooks like we have your previous data saved in our cloud, So lets bring it back to you',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black54)),
                            TextSpan(
                                text:
                                    '\n\nThis might take few minutes, Please do not close me',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                          ],
                        ),
                      ),
                      SizedBox(height:10),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: _loading
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                            height:20,
                                            child: LinearProgressIndicator(
                                              value: _progressValue,
                                            ))),
                                    Text('${(_progressValue * 100).round()}%'),
                                  ],
                                )
                              : Text("Download Complete",
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                        ),
                      ),

                    ],
                  ),
                ),
              if (startPage==2)
                Container(
                  padding: EdgeInsets.all(32),
                  alignment: Alignment.center,
                  color: Colors.blueGrey.withOpacity(.95),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Welcome',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60),
                          children: <TextSpan>[
                            TextSpan(
                                text: '\n${nameController.text}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32)),
                            TextSpan(
                                text:
                                '\n\nSetting up your data !',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black54)),
                            TextSpan(
                                text:
                                '\n\nThis might take few minutes, Please do not close me',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                          ],
                        ),
                      ),
                      SizedBox(height:10),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: _loading
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                      height:20,
                                      child: LinearProgressIndicator(
                                        value: _progressValue,
                                      ))),
                              Text('${(_progressValue * 100).round()}%'),
                            ],
                          )
                              : Text("Setup Complete",
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),

                    ],
                  ),
                )
            ],
          ),
        ),
        if (_currentPage >= 1)
          onBottom(FadeAnimation(
              1,
              Container(
                  child: AnimatedWave(
                height: 160,
                speed: 0.9,
                offset: pi,
              )))),
        if (_currentPage >= 2)
          onBottom(FadeAnimation(
              1,
              Container(
                  child: AnimatedWave(
                height: 200,
                speed: .7,
                offset: pi / 4,
              )))),
        if (_currentPage >= 3)
          onBottom(FadeAnimation(
              1,
              Container(
                  child: AnimatedWave(
                height: 220,
                speed: 1.5,
                offset: pi / 2,
              )))),
      ]),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      height: 120,
                      color: Colors.transparent,
                      padding: EdgeInsets.all(16),
                      child: FadeAnimation(
                          5.6,
                          Container(
                              child: AnimatedBuilder(
                            animation: rippleAnimation,
                            builder: (context, child) => Container(
                              width: rippleAnimation.value,
                              height: rippleAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black45.withOpacity(.4)),
                                child: InkWell(
                                  onTap: () async {

                                    if(AlladdedList.length>0) {
                                      await NotesDatabaseService.db.deleteUserActivityTable();
                                      for (var i = 0;
                                      i < AlladdedList.length;
                                      i++) {
                                        UserAModel usera = new UserAModel(
                                            name: AlladdedList[i].name,
                                            a_id: AlladdedList[i].id,
                                            image: AlladdedList[i].image);
                                        await NotesDatabaseService.db
                                            .addUserActivity(usera);
                                      }

                                    }
                                    prefs.setString(
                                        'user_name', nameController.text);
                                    prefs.setString('user_image', avatar);
                                    prefs.setBool('onboard', false);
                                    scaleController.forward();
                                  },
                                  child: AnimatedBuilder(
                                    animation: scaleAnimation,
                                    builder: (context, child) =>
                                        Transform.scale(
                                      scale: scaleAnimation.value,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))))
                ],
              ))
          : Text(''),
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

  _updateProgress() async {
    NotesDatabaseService.db.GetCloudData().listen((value) {
      setState(() {
        _progressValue = value;
      });
    }).onDone(() {
      setState(() {
        _loading=!_loading;
      });

      print("1 hahja");
      sleep(const Duration(seconds:2));
      print("2 hahja");
      setState(() {
       startPage=0;
      });
    });
  }
  _updateProgressFirstTime() async {
    NotesDatabaseService.db.GetCloudDataFirstTime().listen((value) {
      setState(() {
        _progressValue = value;
      });
    }).onDone(() {
      setState(() {
        _loading=!_loading;
      });

      print("1 hahja");
      sleep(const Duration(seconds:2));
      print("2 hahja");
      setState(() {
        startPage=0;
      });
    });
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  Widget _buildAddedCard(int index, ActivityModel this_act) {
    String count = "";
    String image = 'assets/images/' + this_act.image + '.jpg';

    return GestureDetector(
      onTap: () {
        setState(() {
          activity_position[index] = 1 - activity_position[index];
        });
      },
      child: Padding(
        padding: EdgeInsets.only(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2.0),
          height: 100,
          width: 50,
          child: Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.cover))),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(int index, ActivityModel this_act) {
    String count = "";
    String image = 'assets/images/' + this_act.image + '.jpg';

    return GestureDetector(
      onTap: () {
        setState(() {
          activity_position[index] = 1 - activity_position[index];
          if (activity_position[index] == 1)
            AlladdedList.add((this_act));
          else
            AlladdedList.remove((this_act));
        });
      },
      child: Padding(
        padding: EdgeInsets.only(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4.0),
          height: 100,
          width: 120,
          child: Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.cover))),
              if (activity_position[index] != 1)
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      this_act.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'ZillaSlab',
                          fontSize: 20,
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
                    ),
                  ),
                ),
              if (activity_position[index] == 1)
                Padding(
                  padding: EdgeInsets.only(),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add_circle,
                      size: 50,
                      color: Colors.orange[400].withOpacity(.8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard2(int index, String image) {
    String count = "";
    image = 'assets/images/' + image + '.png';

    return GestureDetector(
      onTap: () {
        setState(() {
          avatar_position = index;
          avatar = image;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
        height: 80,
        width: (avatar_position == index) ? 140 : 80,
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover))),
            if (avatar_position == index)
              Padding(
                padding: EdgeInsets.only(),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check_circle,
                    size: 50,
                    color: Colors.deepPurple[400].withOpacity(.8),
                  ),
                ),
              ),
        /*   Align(
                alignment:Alignment.bottomCenter,
                child:Text("Female\n25-50",style: TextStyle(
                color: Colors.white,
                fontFamily: 'ZillaSlab',
                fontSize: 20,
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
                fontWeight: FontWeight.w700),))*/
          ],
        ),
      ),
    );
  }
}