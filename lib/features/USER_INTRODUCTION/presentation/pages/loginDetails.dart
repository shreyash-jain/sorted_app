import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/ONBOARDING/presentation/widgets/button_up_down.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/ageAndProfessionPV.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/interestsPV.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/nameAndGenderPV.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/notificationPV.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/progressBar.dart';

class LoginPage extends StatefulWidget {
  final UserDetail userDetail;
  final List<ActivityModel> allActivities;
  final List<UserAModel> userActivities;
  final int valid;
  final String message;
  LoginPage({
    this.userDetail,
    this.allActivities,
    this.userActivities,
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

  final _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);

  Color scaleColor = Colors.transparent;

  @override
  void initState() {
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.9],
          colors: [
            Theme.of(context).backgroundColor,
            Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 80,
                margin: EdgeInsets.only(top: Gparam.heightPadding),
                child: Stack(
                  children: [
                    Row(children: <Widget>[
                      SizedBox(
                        width: Gparam.widthPadding,
                      ),
                      if (widget.userDetail.imageUrl != null &&
                          Gparam.isHeightBig)
                        Hero(
                            tag: UserIntroStrings.userImageTag,
                            child: Container(
                              height: Gparam.height / 10,
                              width: Gparam.height / 10,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black12, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      widget.userDetail.imageUrl,
                                    ),
                                    radius: Gparam.height / 25,
                                    backgroundColor: Colors.transparent,
                                  )
                                ],
                              ),
                            )),
                      Container(
                          height: Gparam.height / 10,
                          width: ((Gparam.width / 1.1 - Gparam.height / 10) > 0
                              ? (Gparam.width / 1.1 - Gparam.height / 10)
                              : Gparam.width / 1.6),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: Gparam.height / 100,
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0)),
                                      color: Colors.black.withOpacity(.04),

                                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ProgressBar(
                                      currentPage: _currentPage, widget: widget)
                                ],
                              ),
                            ],
                          )),
                    ]),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 80,
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
                    NameAndGender(loginWidget: widget),
                    AgeAndProfession(loginWidget: widget),
                    InterestsPV(loginWidget: widget),
                    NotificationPV(
                        title: UserIntroStrings.notificationHeading,
                        description: UserIntroStrings.notificationDescription,
                        imagepath: UserIntroStrings.notificationImagePath),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: Gparam.height,
            alignment: Alignment.bottomRight,
            child: Container(
              width: 90,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topRight: Radius.circular(0.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0)),
                gradient: new LinearGradient(
                    colors: [
                      (_currentPage < _numPages - 1)
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColorLight,
                      (_currentPage < _numPages - 1)
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).accentColor,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.00),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
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
                          onTapAction: moveDown,
                        )),
                  if (_currentPage == _numPages - 1)
                    FlatButton(
                      onPressed: () {
                        print("pressed");
                        if (widget.valid == 10) {
                          scaleColor = Theme.of(context).primaryColor;
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
                              color: Colors.white,
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
  }

  moveDown() {
    print("button down");
    if (_currentPage + 1 == _numPages - 1) {
      print("add openbottomsheet");
      // BlocProvider.of<OnboardingBloc>(context).add(OpenBottomSheet());
    }
    setState(() {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
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
              print(widget.userActivities.length);
              BlocProvider.of<UserIntroductionBloc>(context)
                  .add(SaveDetails(widget.userDetail, widget.userActivities));
            }
          });
    scaleAnimation =
        Tween<double>(begin: 1, end: 350.0).animate(scaleController);
  }
}
