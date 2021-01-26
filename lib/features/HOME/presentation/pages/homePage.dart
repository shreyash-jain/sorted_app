import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:core';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sa_anicoto/sa_anicoto.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';
import 'package:sorted/core/global/animations/fade_animationLR.dart';

import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/presentation/pages/camera_screen.dart';
import 'package:sorted/features/HOME/presentation/widgets/animated_fab.dart';
import 'package:sorted/features/HOME/presentation/widgets/bottom_tab.dart';
import 'package:sorted/features/HOME/presentation/widgets/bottom_tab_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/flexible_safe_area.dart';

import 'package:sorted/features/HOME/presentation/widgets/side_bar.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_tab.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_tab_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/slide_stack.dart';
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
  bool showSideTab = true;
  Animation<double> scaleAnimation;
  Animation<double> positionAnimation;
  AnimationController scaleController;
  AnimationController positionController;

  int currentSideTab;
  int currentBottomTab;
  AnimationController tabController;
  Animation<double> tabAnimation;
  Animation<Color> colorAnimation;
  TabController tab_Controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController nestedScrollController;

  final _cameraKey = GlobalKey<CameraScreenState>();

  var bottomNavIndex = 0;
 
  @override
  void initState() {
    super.initState();
    tab_Controller = new TabController(length: 2, vsync: this);

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

    tabController = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this)
      ..addListener(() => setState(() {}));
    tabAnimation = Tween<double>(begin: 0, end: Gparam.width / 7).animate(
        new CurvedAnimation(parent: tabController, curve: Curves.decelerate));

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
        key: _scaffoldKey,
       
        body: SafeArea(child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SlideStack(
            drawer: Container(
              color: (Theme.of(context).brightness == Brightness.light)
                  ? Colors.transparent
                  : Colors.white12,
              width: Gparam.width,
              child: Stack(
                children: [
                  SideTab(
                      currentSideTab: currentSideTab,
                      isNavEnabled: isNavEnabled,
                      onTapAction: onSideTabSelected),
                  Container(
                      width: Gparam.width,
                      height: Gparam.height,
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: Gparam.width / 2,
                        alignment: Alignment.bottomLeft,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Gparam.heightPadding,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Gparam.widthPadding / 2),
                                  child: Text("Chat with",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Gparam.widthPadding / 2),
                                  child: Text("Experts",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textMedium,
                                          fontWeight: FontWeight.w500))),
                              SizedBox(
                                height: Gparam.heightPadding / 2,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("For Fitness",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w800))),
                              Divider(
                                color: Theme.of(context)
                                    .highlightColor
                                    .withAlpha(50),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Fitness consultant",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Gym trainer",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Yoga specialist",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("General physicist",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Physiotheripist",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("For Mental Health",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w800))),
                              Divider(
                                color: Theme.of(context)
                                    .highlightColor
                                    .withAlpha(50),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Stress counsellor",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Couple counsellor",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Life counsellor",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("For Nutrition",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w800))),
                              Divider(
                                color: Theme.of(context)
                                    .highlightColor
                                    .withAlpha(50),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Dietician",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Ayurveda specialist",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Pregnency food\nspecialist",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("For Productivity",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w800))),
                              Divider(
                                color: Theme.of(context)
                                    .highlightColor
                                    .withAlpha(50),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Work therapist",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Study therapist",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Engineering\nfield experts",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Medical\nfield experts",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Commerce\nfield experts",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Law\nfield experts",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Performing Arts\nfield experts",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Literature Arts\nfield experts",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Visual Arts\nfield experts",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  child: Text("Music Arts\nfield experts",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500))),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
            child: SlideContainer(
                slideDirection: SlideDirection.left,
                onSlide: onSlide,
                drawerSize: Gparam.width / 2,
                child: Stack(
                  children: [
                    CustomPaint(
                        child: NestedScrollView(
                      controller: nestedScrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverSafeArea(
                          top: false,
                          sliver: SliverAppBar(
                            elevation: 5,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            shadowColor: Colors.black26,
                            leading: IconButton(
                              icon: Icon(
                                OMIcons.flashOn,
                                color: Theme.of(context).highlightColor,
                              ),
                              tooltip: 'Settings',
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(
                                  OMIcons.chat,
                                  color: Theme.of(context).highlightColor,
                                ),
                                tooltip: 'Settings',
                                onPressed: () {},
                              ),
                            ],
                            expandedHeight: 190,
                            pinned: true,
                            primary: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(0.0)),
                            ),
                            flexibleSpace: LayoutBuilder(builder:
                                (BuildContext context,
                                    BoxConstraints constraints) {
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
                              Transform.translate(
                                offset: Offset(tabAnimation.value, 0.0),
                                child: AnimatedContainer(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  width: Gparam.width,
                                  duration: Duration(milliseconds: 700),
                                  child: ListView(children: <Widget>[
                                    Container(
                                      height: 100,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Gparam.widthPadding),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .highlightColor
                                            .withOpacity(.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      height: 200,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Gparam.widthPadding),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .highlightColor
                                            .withOpacity(.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                    )
                                  ]),
                                ),
                              )
                            ],
                          )),
                    )),
                    //
                    //! Side bar

                    //! bottom tab

                   
                  ],
                )),
          );
        })));
  }

  void _changeFilterState() {}

  void onSideTabSelected(int toIndex) {
    print(toIndex);

    if (toIndex == 1) {
      print("plan");
      Router.navigator.pushNamed(Router.planHome);
    } else if (toIndex == 2) {
      print("record");
      Router.navigator.pushNamed(Router.recordTab);
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

  void onSlide(double value) {}
}
