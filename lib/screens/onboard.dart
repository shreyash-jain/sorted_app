import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/main.dart';
import 'package:notes/screens/introduction.dart';
import 'package:notes/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../components/FadeAnimation.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Animation<double> scaleAnimation;
  AnimationController scaleController;
  AnimationController rippleController;
  SharedPreferences prefs;
  Animation<double> rippleAnimation;
  ThemeData theme = appThemeLight;
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }
  void initState() {
    super.initState();
    scaleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1)
    )..addStatusListener((status) async {
      if (status == AnimationStatus.completed) {

        await authService.googleSignIn();



        Navigator.of(context).pop();
        Navigator.push(context,
            FadeRoute(page: IntroductionScreen(),));


      }
    });
    rippleController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1)
    );
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
        end: 35.0
    ).animate(scaleController);
    rippleController.forward();
  }
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      height: 12.0,
      width: isActive ? 30.0 : 20.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
  @override
  void dispose() {
    rippleController.dispose();
    _pageController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [ 0.2, 0.9],
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
                  child: PageView(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Stack(

                          children: <Widget>[
                           Padding(
                                padding :EdgeInsets.only(top:140),
                               child:FadeAnimation(1.6, Container(

                                child:Image(
                                image: AssetImage(
                                  'assets/images/onboarding1.png',
                                ),
                                height: 150,
                                width: 150,
                              ),),),),

                            Padding(padding :EdgeInsets.only(top:300),
                              child:FadeAnimation(2.6, Container(

                                child: Text(
                                  'Track everything\nthat revolves around you',
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withOpacity(.5)
                                  ),
                                )
                              )),),


                            Padding(padding :EdgeInsets.only(top:380),
                              child:FadeAnimation(4.2, Container(

                                  child: Text(
                                    'AI generated predictions\nand past patterns of our activities helps us guide, motivate and if required modify them in future',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45
                                    ),

                                ),
                              )),),

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Stack(

                          children: <Widget>[
                            Padding(
                              padding :EdgeInsets.only(top:140),
                              child:FadeAnimation(1.6, Container(

                                child:Image(
                                  image: AssetImage(
                                    'assets/images/onboarding0.png',
                                  ),
                                  height: 150,
                                  width: 150,
                                ),),),),

                            Padding(padding :EdgeInsets.only(top:300),
                              child:FadeAnimation(2.6, Container(

                                  child: Text(
                                    'Smart journaling',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white.withOpacity(.5)
                                    ),
                                  )
                              )),),


                            Padding(padding :EdgeInsets.only(top:340),
                              child:FadeAnimation(4.2, Container(

                                child: Text(
                                  'Organize everything\nYour Plans, Events, Todos and we will intelligently make your dairy entry for each day',
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45
                                  ),

                                ),
                              )),),

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Stack(

                          children: <Widget>[
                            Padding(
                              padding :EdgeInsets.only(top:140),
                              child:FadeAnimation(1.6, Container(

                                child:Image(
                                  image: AssetImage(
                                    'assets/images/onboarding2.png',
                                  ),
                                  height: 150,
                                  width: 150,
                                ),),),),

                            Padding(padding :EdgeInsets.only(top:300),
                              child:FadeAnimation(2.6, Container(

                                  child: Text(
                                    'Highly Secure',
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white.withOpacity(.5)
                                    ),
                                  )
                              )),),


                            Padding(padding :EdgeInsets.only(top:340),
                              child:FadeAnimation(4.2, Container(

                                child: Text(
                                  'From AI processing to database everything is Offline, so you can share your personal things',
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45
                                  ),

                                ),
                              )),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        Padding(
          padding: EdgeInsets.only(top: 50,right: 40),
          child:Align(
          alignment: FractionalOffset.topRight,
          child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildPageIndicator(),
                ),),),
                _currentPage != _numPages - 1
                    ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          if (_currentPage>0){
                            _pageController.animateToPage(_currentPage-1,
                              duration: Duration(milliseconds:800),
                              curve: Curves.easeInOut,
                            );}
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
                    if(_currentPage<3)Align(
                      alignment: FractionalOffset.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          _pageController.animateToPage(_currentPage+1,
                            duration: Duration(milliseconds:800),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size:50.0,
                            ),
                          ],
                        ),
                      ),

                    )


                  ],)
                    : Text(''),
              ],
            ),

        ),]
      ),
      bottomSheet: _currentPage == _numPages - 1
          ?
      Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          Text("Get started   >>", style: TextStyle(
        fontFamily: 'ZillaSlab',
        fontSize: 24.0,


      ),),
        Container(

          height: 120,
          padding:EdgeInsets.all(16),




          child:FadeAnimation(5.6, Container(child:AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) => Container(
              width: rippleAnimation.value,
              height: rippleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:  Colors.indigo
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
                            color: Color(0xFF4563DB),
                        ),
                      ),
                    ),
                  ),
                ),

              ),
            ),
          ))

          )


      )],)
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

}