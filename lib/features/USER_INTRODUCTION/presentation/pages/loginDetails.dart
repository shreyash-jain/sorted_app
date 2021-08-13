import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/ONBOARDING/presentation/widgets/button_up_down.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/ageAndProfessionPV.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/health_profile.dart';

import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/nameAndGenderPV.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/notificationPV.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/progressBar.dart';

class LoginPage extends StatefulWidget {
  final UserDetail userDetail;

  final int valid;
  final String message;
  LoginPage({
    this.userDetail,
    this.valid,
    this.message,
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  int _currentPage = 0;
  Animation<double> scaleAnimation;
  AnimationController scaleController;
  UserIntroductionBloc bloc;

  final _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);

  Color scaleColor = Colors.white;

  @override
  void initState() {
    bloc = BlocProvider.of<UserIntroductionBloc>(context);
    super.initState();
    setUpScaleAnimation();

    print("Login Body");
  }

  void dispose() {
    _pageController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.9],
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: PageView(
                    allowImplicitScrolling: true,
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      NameAndGender(
                        loginWidget: widget,
                        currentPage: _currentPage,
                      ),
                      HealthProfileWidget(
                          loginWidget: widget, currentPage: _currentPage),
                      // InterestsPV(
                      //     loginWidget: widget, currentPage: _currentPage),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: Gparam.height,
              alignment: Alignment.bottomRight,
              child: Container(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 50,
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          topRight: Radius.circular(0.0),
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0)),
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade200, width: 2)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (_currentPage > 0)
                        Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Button(
                              direction: false,
                              onTapAction: moveUp,
                            )),
                      if (_currentPage < _numPages - 1)
                        Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Button(
                              direction: true,
                              isActive: (widget.valid == 9 || widget.valid == 8)
                                  ? false
                                  : true,
                              onTapAction: moveDown,
                            )),
                      if (_currentPage == _numPages - 1)
                        FlatButton(
                          onPressed: () {
                            print("pressed");
                            if (widget.valid == 10) {
                              scaleColor = Colors.white;
                              scaleController.forward();
                            } else {
                              print("pressed 2");
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(widget.message),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.black,
                                  size: 45.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                height: Gparam.height,
                alignment: Alignment.bottomRight,
                child: AnimatedBuilder(
                  animation: scaleAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: scaleAnimation.value,
                    child: Container(
                      height: 10,
                      width: 10,
                      margin: EdgeInsets.all(0),
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: scaleColor),
                    ),
                  ),
                )),
          ],
        ),
      );
    }));
  }

  moveDown() {
    if ((bloc.state is LoginState)) {

      
      if ((bloc.state as LoginState).isPhoneCorrect)
        setState(() {
          _pageController.animateToPage(
            _currentPage + 1,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        });
     
    }
  }

  moveUp() {
    print("button Up");
    setState(() {
      if (_currentPage > 0) {
        _pageController.animateToPage(
          _currentPage - 1,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void setUpScaleAnimation() {
    scaleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              print("done");
              if (bloc.state is LoginState) {
                bloc.add(SaveDetails((bloc.state as LoginState).userDetail,
                    (bloc.state as LoginState).healthProfile));
              }
            }
          });
    scaleAnimation =
        Tween<double>(begin: 1, end: 350.0).animate(scaleController);
  }
}
