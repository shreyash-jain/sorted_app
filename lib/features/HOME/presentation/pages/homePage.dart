import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:core';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:sa_anicoto/sa_anicoto.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';
import 'package:sorted/core/global/animations/fade_animationLR.dart';

import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/presentation/pages/camera_screen.dart';
import 'package:sorted/features/HOME/presentation/widgets/bottom_tab.dart';
import 'package:sorted/features/HOME/presentation/widgets/bottom_tab_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/flexible_safe_area.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_bar.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_tab.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_tab_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/user_avatar.dart';

import 'package:supercharged/supercharged.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class SortedHome extends StatefulWidget {
  SortedHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SortedHomeState createState() => _SortedHomeState();
}

class _SortedHomeState extends State<SortedHome>
    with TickerProviderStateMixin, AnimationMixin {
  var formatterDate = new DateFormat('dd-MM-yyyy');
  List<String> imagePath = [];
  List<int> imageTotal = [];
  List<String> inspirations = [];
  bool isSearchEmpty = true;
  Shader linearGradient;
  String name = "Shreyash";
  SharedPreferences prefs;
  bool isNavEnabled = false;
  double currentSliverheight, prevSliverHeight;
  StorageReference refStorage = FirebaseStorage.instance.ref();
  DateTime today = DateTime.now();
  double top;
  Animation<double> scaleAnimation;
  Animation<double> positionAnimation;
  AnimationController scaleController;
  AnimationController positionController;
  String user_image = 'assets/images/male1.png';
  int currentSideTab;
  int currentBottomTab;
  Animation<Color> colorAnimation;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController nestedScrollController;

  final _cameraKey = GlobalKey<CameraScreenState>();

  @override
  void initState() {
    super.initState();

    nestedScrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );
    colorAnimation = Colors.red.tweenTo(Colors.blue).animatedBy(controller);
    scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              scaleController.loop(duration: 5.seconds);
            } else if (status == AnimationStatus.dismissed) {
              scaleController.forward();
            }
          });

    scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.5).animate(scaleController);

    positionController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    positionAnimation =
        Tween<double>(begin: 0.0, end: 0.0).animate(positionController);
    scaleController.curve(Curves.decelerate);
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  void _toEnd() {
    // NEW
    if (nestedScrollController != null)
      nestedScrollController.animateTo(
        // NEW
        nestedScrollController.position.minScrollExtent, // NEW
        duration: const Duration(milliseconds: 500), // NEW
        curve: Curves.decelerate, // NEW
      ); // NEW
  }

  void _toStart() {
    // NEW
    if (nestedScrollController != null)
      nestedScrollController.animateTo(
        // NEW
        nestedScrollController.position.maxScrollExtent, // NEW
        duration: const Duration(milliseconds: 500), // NEW
        curve: Curves.decelerate, // NEW
      ); // NEW
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: _scaffoldKey,
        body: SafeArea(child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              CustomPaint(
                  child: NestedScrollView(
                controller: nestedScrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      shadowColor: Colors.black26,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(OMIcons.settings,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          tooltip: 'Settings',
                          onPressed: () {
                            Router.navigator.pushNamed(Router.settingsPage);
                          },
                        ),
                      ],
                      leading: UserAvatar(
                          scaleAnimation: scaleAnimation,
                          user_image: user_image),
                      expandedHeight: 400,
                      pinned: true,
                      primary: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30.0)),
                      ),
                      flexibleSpace: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        currentSliverheight = constraints.biggest.height;
                        print(currentSliverheight);

                        bool direction;
                        if (prevSliverHeight != null &&
                            prevSliverHeight > currentSliverheight) {
                          direction = false;
                        } else if (prevSliverHeight != null &&
                            prevSliverHeight < currentSliverheight)
                          direction = true;

                        prevSliverHeight = currentSliverheight;

                        return FlexibleSpaceArea(
                            currentSliverheight: currentSliverheight,
                            name: name);
                      }),
                    ),
                  ),
                ],
                body: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeAnimationTB(
                            1.6,
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(45.0),
                                    topRight: Radius.circular(45.0)),
                              ),
                              width: 5.3 * Gparam.width / 6,
                              duration: Duration(milliseconds: 700),
                              child: ListView(children: <Widget>[]),
                            )),
                      ],
                    )),
              )),
              //
              //! Side bar
              SideBar(
                  isNavEnabled: isNavEnabled, currentSideTab: currentSideTab),
              //! side tab labels
              SideTab(
                  currentSideTab: currentSideTab,
                  isNavEnabled: isNavEnabled,
                  onTapAction: onSideTabSelected),
              //! bottom tab
            ],
          );
        })));
  }

  void onSideTabSelected(int toIndex) {
    print(toIndex);
    if (toIndex==1){
      print("plan");
      Router.navigator.pushNamed(Router.planHome);
    }
    if (currentSideTab == toIndex)
      setState(() {
        currentSideTab = null;
      });
    else
      setState(() {
        currentSideTab = toIndex;
      });
  }

  void onBottomTabSelected(int index) {
    setState(() {
      currentBottomTab = index;
    });
  }
}
