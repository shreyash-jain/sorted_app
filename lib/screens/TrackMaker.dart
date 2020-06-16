import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/data/custom_slider_thumb_circle.dart';
import 'package:notes/data/question.dart';

import 'package:notes/data/theme.dart';

import 'package:notes/services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class trackMaker extends StatefulWidget {
  Function() triggerRefetch;
  int fromPath;
  Function(Brightness brightness) changeTheme;

  trackMaker(
      {Key key,
      Function() triggerRefetch,
      int fromPath,
      Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.fromPath = fromPath;
    this.triggerRefetch = triggerRefetch;
  }

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<trackMaker> {
  PageController _pageController = PageController(initialPage: 0);
  ThemeData theme = appThemeLight;

  int _currentPage = 0;

  List<String> text_name = [
    "",
    "Name of Skill",
    "Name of Skill",
    "Name of Event",
    "Title of this Write up",
    "Title of Event"
  ];

  List<String> namesList = [
    "guitar",
    "dancing",
    "coding",
    "photoshop",
    "geometry",
    "cycling",
    "political Science",
    "modern History",
    "java"
  ];
  List<String> choiceList = ["Yes", "No"];
  List<String> writeList = [
    "Life Experiences",
    "My Health",
    "Positivities of my life",
    "My journey to success",
    "Low moments of my life",
    "Today's learnings",
    "Today's study revision",
    "plans for tomorrow",
    "Meditation Experience"
  ];
  List<String> rateList = [
    "my work",
    "my Gym workout",
    "my studies",
    "my Anger",
    "my cooking",
    "my meditation",
    "my happiness",
    "my vibes",
    "my relationship"
  ];
  List<String> optionList = [
    "meditate ?",
    "pray ?",
    "wake up early ?",
    "read my book ?",
    "My dinner ?",
    "Healthy diet ?",
  ];

  List<String> levels = [
    "Newbie",
    "Beginner",
    "Skilled",
    "Intermediate",
    "Seasoned",
    "Proficient",
    "Experienced",
    "Advanced",
    "Expert",
    "Perfect"
  ];
  List<String> l_int = [
    "0 to 9",
    "10 to 19",
    "20 to 24",
    "25 to 39",
    "40 to 49",
    "50 to 69",
    "70 to 79",
    "80 to 89",
    "90 to 99",
    "100"
  ];
  List<int> l_start = [0, 10, 20, 25, 40, 50, 70, 80, 90, 100];
  List<String> intervals = ["Day", "Week", "Month"];
  FocusNode nameFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  FocusNode sheetFocus = FocusNode();
  TextEditingController sheetController = TextEditingController();
  List<double> hours = [.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 8];
  List<int> maxs = [5, 10, 50, 100];
  String desTrack = "";
  String titleTrack = "";

  int selected_hr = -1;
  double slider_value = .6;

  String rate_side = "Hours";
  String rate_below1 = "Hours";
  String rate_below2 = "Hours";

  String secondHeading = "";

  String secondSub = "";
  String thirdHeading = "Want to fill this every";

  String thirdSub = "Choose an interval";
  String forthHeading = "Priority of this\nevent in my life";

  String forthSub = "slide to adjust";

  String selected_aim = "";

  int selected_interval = -1;

  double slider_priority = .5;

  int submit = 0;

  int selected_level = -1;

  int selected_max = -1;

  int selected_option = -1;

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    if (widget.fromPath == 1) {
      secondHeading = "How Many hours/day\nyou aim for ?";
      secondSub = "Select any one";
      rate_below1 = "Less then ";
      rate_below2 = "More ";
    } else if (widget.fromPath == 2) {
      secondHeading = "What is my current level ?";
      secondSub = "Out of 100 : 0 -> Newbie and 100 -> Expert";
    } else if (widget.fromPath == 3) {
      namesList = rateList;
      rate_side = "Rate";
      secondHeading = "I want to rate\nthis out of ?";
      secondSub = "set a maximun value of rating";
    } else if (widget.fromPath == 4) {
      namesList = writeList;

      secondHeading = "";
      secondSub = "";
    } else if (widget.fromPath == 5) {
      namesList = optionList;

      secondHeading = "Choices to this event";
      secondSub = "add option if needed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    actions: <Widget>[],
                    leading: IconButton(
                      icon: const Icon(
                        OMIcons.arrowBack,
                        color: Colors.grey,
                      ),
                      tooltip: 'Add new entry',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    expandedHeight: 80,
                    pinned: true,
                    primary: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(45.0),
                          bottomLeft: Radius.circular(45.0)),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          "Track Maker",
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.grey),
                          overflow: TextOverflow.clip,
                          softWrap: false,
                        ),
                        background: Container(
                          padding: EdgeInsets.only(top: 120, left: 73),
                          child: FadeAnimation(
                              1.6,
                              Container(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "",
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black26),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ))),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(45.0),
                                bottomRight: Radius.circular(45.0)),
                            gradient: new LinearGradient(
                                colors: [
                                  Colors.grey.withOpacity(.1),
                                  Colors.grey.withOpacity(.2),
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ],
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                tileMode: TileMode.clamp),
                          ),
                        )),
                  ),
                ),
              ],
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0)),
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.all(0),
                    height: 250,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular((30))),
                      gradient: new LinearGradient(
                          colors: [
                            Colors.blueGrey.withOpacity(.7),
                            Colors.blueGrey.withOpacity(.5),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 10,
                          left: 10,
                          width: MediaQuery.of(context).size.width - 50,
                          height: 230,
                          // Note: without ClipRect, the blur region will be expanded to full
                          // size of the Image instead of custom size
                          child: ClipRRect(
                            borderRadius:
                                new BorderRadius.all(Radius.circular((30))),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                color: Colors.black.withOpacity(.1),
                              ),
                            ),
                          ),
                        ),
                        PageView(
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          margin: EdgeInsets.all(0),
                                          padding: EdgeInsets.all(5),
                                          height: 230,
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular((30))),
                                            gradient: new LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                ],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 1.00),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    text: TextSpan(
                                                      text: text_name[
                                                          widget.fromPath],
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'ZillaSlab',
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                '\n in one or two words',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white54)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              FadeAnimation(
                                                  .8,
                                                  Container(
                                                    child: TextField(
                                                      focusNode: nameFocus,
                                                      controller:
                                                          nameController,
                                                      maxLength: 20,
                                                      autofocus: true,
                                                      buildCounter: (BuildContext
                                                                  context,
                                                              {int
                                                                  currentLength,
                                                              int maxLength,
                                                              bool
                                                                  isFocused}) =>
                                                          null,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      maxLines: 1,
                                                      onChanged: (text) {
                                                        setState(() {
                                                          titleTrack =
                                                              nameController
                                                                  .text;
                                                        });
                                                      },
                                                      onSubmitted: (text) {
                                                        nameFocus.unfocus();
                                                        if (widget.fromPath == 5) {
                                                          _settingModalBottomSheet(context, 1);
                                                        }
                                                      },
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'ZillaSlab',
                                                          fontSize: 22,
                                                          color: Colors.white60,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      decoration:
                                                          InputDecoration
                                                              .collapsed(
                                                        hintText: 'Enter name',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.white10,
                                                            fontSize: 22,
                                                            fontFamily:
                                                                'ZillaSlab',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                height: 45,
                                                child: FadeAnimation(
                                                    1.2,
                                                    Container(
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              namesList.length +
                                                                  1,
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            if (index == 0) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5,
                                                                        horizontal:
                                                                            3.0),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            0),
                                                                decoration: new BoxDecoration(
                                                                    borderRadius: new BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            (8))),
                                                                    color: Colors
                                                                        .transparent),
                                                                height: 40,
                                                                child: Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "Like :",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white60,
                                                                          fontFamily:
                                                                              'ZillaSlab',
                                                                          fontSize:
                                                                              22,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                            return _buildCategoryCard2(
                                                                index - 1,
                                                                namesList[
                                                                    index - 1]);
                                                          }),
                                                    )),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  InkWell(
                                                      onTap: () {
                                                        if (widget.fromPath !=
                                                            4)
                                                          _pageController
                                                              .animateToPage(
                                                            1,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    600),
                                                            curve: Curves
                                                                .easeInOut,
                                                          );
                                                        else
                                                          _pageController
                                                              .animateToPage(
                                                            2,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    600),
                                                            curve: Curves
                                                                .easeInOut,
                                                          );
                                                        if (widget.fromPath == 5 && desTrack=="") {
                                                          _settingModalBottomSheet(context, 1);
                                                        }
                                                        if (widget.fromPath ==
                                                            1)
                                                          setState(() {
                                                            desTrack =
                                                                "How many hours I spent in ${nameController.text} ?";
                                                          });
                                                        else if (widget
                                                                .fromPath ==
                                                            2)
                                                          setState(() {
                                                            desTrack =
                                                                "To what level I reached in ${nameController.text} ?";
                                                          });
                                                        else if (widget
                                                                .fromPath ==
                                                            3)
                                                          setState(() {
                                                            desTrack =
                                                                "Rating for ${nameController.text} ?";
                                                          });

                                                        // scaleController.forward();
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          height: 45,
                                                          decoration:
                                                              new BoxDecoration(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .all(
                                                                    Radius.circular(
                                                                        (30))),
                                                            gradient:
                                                                new LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .blue[
                                                                              100]
                                                                          .withOpacity(
                                                                              .8),
                                                                      Colors
                                                                          .blue[
                                                                              100]
                                                                          .withOpacity(
                                                                              .6),
                                                                    ],
                                                                    begin:
                                                                        const FractionalOffset(
                                                                            0.0,
                                                                            0.0),
                                                                    end: const FractionalOffset(
                                                                        1.0,
                                                                        1.00),
                                                                    stops: [
                                                                      0.0,
                                                                      1.0
                                                                    ],
                                                                    tileMode:
                                                                        TileMode
                                                                            .clamp),
                                                          ),
                                                          child: Icon(Icons
                                                              .arrow_forward_ios))),
                                                ],
                                              )
                                            ],
                                          )))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          margin: EdgeInsets.all(0),
                                          padding: EdgeInsets.all(5),
                                          height: 200,
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular((30))),
                                            gradient: new LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                ],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 1.00),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    text: TextSpan(
                                                      text: secondHeading,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'ZillaSlab',
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                '\n$secondSub',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white24)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (widget.fromPath == 1)
                                                Container(
                                                  height: 45,
                                                  child: FadeAnimation(
                                                      1.2,
                                                      Container(
                                                        child: ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                hours.length,
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return _buildCategoryCard2page(
                                                                  index,
                                                                  hours[index]
                                                                      .toString());
                                                            }),
                                                      )),
                                                ),
                                              if (widget.fromPath == 2)
                                                Container(
                                                  height: 75,
                                                  child: FadeAnimation(
                                                      1.2,
                                                      Container(
                                                        child: ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                levels.length,
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return _buildCategoryCard2page2(
                                                                  index,
                                                                  levels[
                                                                      index]);
                                                            }),
                                                      )),
                                                ),
                                              if (widget.fromPath == 3)
                                                Container(
                                                  height: 45,
                                                  child: FadeAnimation(
                                                      1.2,
                                                      Container(
                                                        child: ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                maxs.length,
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return _buildCategoryCard2page3(
                                                                  index,
                                                                  maxs[index]
                                                                      .toString());
                                                            }),
                                                      )),
                                                ),
                                              if (widget.fromPath == 5)
                                                Container(
                                                  height: 45,
                                                  child: FadeAnimation(
                                                      1.2,
                                                      Container(
                                                        child: ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                choiceList
                                                                    .length,
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return _buildCategoryCard2page5(
                                                                  index,
                                                                  choiceList[
                                                                      index]);
                                                            }),
                                                      )),
                                                ),
                                              if (widget.fromPath == 5 &&
                                                  choiceList.length <= 2)
                                                Container(
                                                  height: 45,
                                                  child: FadeAnimation(
                                                      1.2,
                                                      Container(
                                                          child:
                                                              GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            /*  titleTrack=name;
          nameController.text=name;*/
                                                            selected_option =
                                                                -1;
                                                            _settingModalBottomSheet(
                                                                context, 3);
                                                          });
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      3.0),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 0,
                                                                  horizontal:
                                                                      8.0),
                                                          decoration: new BoxDecoration(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (8))),
                                                              color:
                                                                  Colors.blue),
                                                          height: 40,
                                                          child: Stack(
                                                            children: <Widget>[
                                                              Text(
                                                                "Add option",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontFamily:
                                                                        'ZillaSlab',
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ))),
                                                ),
                                              if (widget.fromPath != 4)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                        onTap: () {
                                                          _pageController
                                                              .animateToPage(
                                                            2,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    600),
                                                            curve: Curves
                                                                .easeInOut,
                                                          );
                                                        },
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 5),
                                                            padding: EdgeInsets
                                                                .all(12),
                                                            height: 45,
                                                            decoration:
                                                                new BoxDecoration(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (30))),
                                                              gradient:
                                                                  new LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .blue[100]
                                                                            .withOpacity(.8),
                                                                        Colors
                                                                            .blue[100]
                                                                            .withOpacity(.6),
                                                                      ],
                                                                      begin:
                                                                          const FractionalOffset(
                                                                              0.0,
                                                                              0.0),
                                                                      end: const FractionalOffset(
                                                                          1.0,
                                                                          1.00),
                                                                      stops: [
                                                                        0.0,
                                                                        1.0
                                                                      ],
                                                                      tileMode:
                                                                          TileMode
                                                                              .clamp),
                                                            ),
                                                            child: Icon(Icons
                                                                .arrow_forward_ios))),
                                                  ],
                                                )
                                            ],
                                          )))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          margin: EdgeInsets.all(0),
                                          padding: EdgeInsets.all(5),
                                          height: 200,
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular((30))),
                                            gradient: new LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                ],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 1.00),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    text: TextSpan(
                                                      text: thirdHeading,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'ZillaSlab',
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: '\n$thirdSub',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white38)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 45,
                                                child: FadeAnimation(
                                                    1.2,
                                                    Container(
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              intervals.length,
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return _buildCategoryCard3page(
                                                                index,
                                                                intervals[
                                                                    index]);
                                                          }),
                                                    )),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  GestureDetector(
                                                      onTap: () {
                                                        _pageController
                                                            .animateToPage(
                                                          3,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  600),
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          height: 45,
                                                          decoration:
                                                              new BoxDecoration(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .all(
                                                                    Radius.circular(
                                                                        (30))),
                                                            gradient:
                                                                new LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .blue[
                                                                              100]
                                                                          .withOpacity(
                                                                              .8),
                                                                      Colors
                                                                          .blue[
                                                                              100]
                                                                          .withOpacity(
                                                                              .6),
                                                                    ],
                                                                    begin:
                                                                        const FractionalOffset(
                                                                            0.0,
                                                                            0.0),
                                                                    end: const FractionalOffset(
                                                                        1.0,
                                                                        1.00),
                                                                    stops: [
                                                                      0.0,
                                                                      1.0
                                                                    ],
                                                                    tileMode:
                                                                        TileMode
                                                                            .clamp),
                                                          ),
                                                          child: Icon(Icons
                                                              .arrow_forward_ios))),
                                                ],
                                              )
                                            ],
                                          )))
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          margin: EdgeInsets.all(0),
                                          padding: EdgeInsets.all(5),
                                          height: 200,
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular((30))),
                                            gradient: new LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                ],
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 1.00),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    text: TextSpan(
                                                      text: forthHeading,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'ZillaSlab',
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: '\n$forthSub',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white38)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      activeTrackColor:
                                                          Colors.white24,
                                                      inactiveTrackColor: Colors
                                                          .blue
                                                          .withOpacity(.5),
                                                      thumbColor:
                                                          Colors.white24,
                                                      valueIndicatorColor:
                                                          Colors.white38,

                                                      trackHeight: 4.0,
                                                      thumbShape:
                                                          CustomSliderThumbCircle(
                                                        thumbRadius: 48 * .4,
                                                        min: 1,
                                                        max: 4,
                                                      ),
                                                      overlayColor: Colors.white
                                                          .withOpacity(.8),
                                                      //valueIndicatorColor: Colors.white,
                                                      activeTickMarkColor:
                                                          Colors.blueGrey,
                                                      inactiveTickMarkColor:
                                                          Colors.red
                                                              .withOpacity(.7),
                                                    ),
                                                    child: Slider(
                                                        value: slider_priority,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            slider_priority =
                                                                value;
                                                            submit = 1;
                                                          });
                                                        }),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.only(
                                                    left: 0, right: 10),
                                                decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius.all(
                                                      Radius.circular((6)),
                                                    ),
                                                    color: Colors.white24),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 0,
                                                      left: 20,
                                                      right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        'unimportant',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Text(
                                                        'top priority',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  if (submit == 1)
                    Container(
                        width: 20,
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: new ButtonTheme(
                            minWidth: 10,
                            height: 50,
                            buttonColor: Colors.transparent,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                  side: BorderSide(
                                      width: 8,
                                      color: Colors.blueGrey.withOpacity(.5))),
                              onPressed: () {
                                handleSave();
                              },
                              child: Text("Create track",
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ))),
                  SizedBox(height: 10),
                  if (submit == 0)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.decelerate,
                      margin: EdgeInsets.only(left: 0),
                      padding: EdgeInsets.all(0),
                      decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular((30))),
                        gradient: new LinearGradient(
                            colors: [
                              Colors.blueAccent.withOpacity(.7),
                              Colors.blueAccent.withOpacity(.5),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.00),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 69,
                            left: 20,
                            width: MediaQuery.of(context).size.width - 40,
                            height: 205,
                            // Note: without ClipRect, the blur region will be expanded to full
                            // size of the Image instead of custom size
                            child: ClipRRect(
                              borderRadius:
                                  new BorderRadius.all(Radius.circular((20))),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 10),
                                child: Container(
                                  color: Colors.black.withOpacity(.3),
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.decelerate,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(20),
                                  alignment: Alignment.topCenter,
                                  height:
                                      MediaQuery.of(context).size.height - 300,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular((30))),
                                    gradient: new LinearGradient(
                                        colors: [
                                          Colors.blueAccent.withOpacity(.8),
                                          Colors.blueAccent.withOpacity(.6),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 1.00),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 00),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 8.0),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular((8))),
                                              color: Colors.white38),
                                          height: 30,
                                          child: Text(
                                            "Preview",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontFamily: 'ZillaSlab',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          )),
                                      if (titleTrack != "")
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 0.0),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 8.0),
                                            decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular((8))),
                                                color: Colors.black54),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    if (titleTrack != "")
                                                      Text(
                                                        titleTrack,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white38,
                                                            fontFamily:
                                                                'ZillaSlab',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    if (selected_interval >= 0)
                                                      Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      00),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 0,
                                                                  horizontal:
                                                                      8.0),
                                                          decoration: new BoxDecoration(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          (8))),
                                                              color: Colors
                                                                  .white38),
                                                          height: 30,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                  Icons.refresh,
                                                                  size: 16),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                "${intervals[selected_interval]}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontFamily:
                                                                        'ZillaSlab',
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              )
                                                            ],
                                                          )),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                if (desTrack != "")
                                                  Text(
                                                    desTrack,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: Colors.white60,
                                                        fontFamily: 'ZillaSlab',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                SizedBox(height: 8),
                                              ],
                                            )),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      if (_currentPage > 0 &&
                                          (widget.fromPath == 4))
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              left: 0, right: 10),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                Radius.circular((6)),
                                              ),
                                              color: Colors.white24),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, left: 10, right: 10),
                                            child: Text(
                                              'This where you will write whatever you want to write.',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'ZillaSlab',
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (_currentPage > 0 &&
                                          (widget.fromPath == 5))
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              left: 0, right: 10),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                Radius.circular((6)),
                                              ),
                                              color: Colors.white24),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0, left: 10, right: 10),
                                              child: Column(
                                                children: <Widget>[

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      if (choiceList.length>0 && choiceList[0]!="")new Radio(
                                                        value: 0,
                                                        groupValue: 0,
                                                        onChanged: null,
                                                      ),
                                                      if (choiceList.length>0&& choiceList[0]!="")new Text(
                                                        choiceList[0],
                                                        style: new TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'ZillaSlab',
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      if (choiceList.length>1 && choiceList[1]!="")new Radio(
                                                        value: 1,
                                                        groupValue: 0,
                                                        onChanged: null,
                                                      ),
                                                      if (choiceList.length>1 && choiceList[1]!="")new Text(
                                                        choiceList[1],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'ZillaSlab',
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.black,
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  if (choiceList.length>2 && choiceList[2]!="")Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[

                                                      new Radio(
                                                        value: 2,
                                                        groupValue: 0,
                                                        onChanged: null,
                                                      ),
                                                      new Text(
                                                        choiceList[2],
                                                        style: new TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: 'ZillaSlab',
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                      if (_currentPage > 0 &&
                                          (widget.fromPath == 1 ||
                                              widget.fromPath == 3))
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              left: 0, right: 10),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                Radius.circular((10)),
                                              ),
                                              color: Colors.white70),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, left: 20),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  '${rate_side}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
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
                                                      data: SliderTheme.of(
                                                              context)
                                                          .copyWith(
                                                        activeTrackColor: Colors
                                                            .black
                                                            .withOpacity(1),
                                                        inactiveTrackColor:
                                                            Colors.blue
                                                                .withOpacity(
                                                                    .5),

                                                        trackHeight: 4.0,
                                                        thumbShape:
                                                            CustomSliderThumbCircle(
                                                          thumbRadius: 48 * .4,
                                                          min: 1,
                                                          max: 4,
                                                        ),
                                                        overlayColor: Colors
                                                            .black
                                                            .withOpacity(.4),
                                                        //valueIndicatorColor: Colors.white,
                                                        activeTickMarkColor:
                                                            Colors.black54,
                                                        inactiveTickMarkColor:
                                                            Colors.red
                                                                .withOpacity(
                                                                    .7),
                                                      ),
                                                      child: Slider(
                                                          value: slider_value,
                                                          onChanged: (value) {
                                                            setState(() {});
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
                                      if (_currentPage > 0 &&
                                          (widget.fromPath == 1 ||
                                              widget.fromPath == 3))
                                        SizedBox(
                                          height: 6,
                                        ),
                                      if (_currentPage > 0 &&
                                          (widget.fromPath == 1 ||
                                              widget.fromPath == 3))
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              left: 0, right: 10),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                Radius.circular((6)),
                                              ),
                                              color: Colors.white24),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, left: 0, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 0,
                                                ),
                                                Text(
                                                  '${rate_below1}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  '     ${selected_aim}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '${rate_below2}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if (_currentPage > 0 &&
                                          (widget.fromPath == 2) &&
                                          selected_level > -1)
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 10),
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                    Radius.circular((6)),
                                                  ),
                                                  color: Colors.white24),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 6,
                                                    left: 00,
                                                    right: 00,
                                                    bottom: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 10),
                                                    Text(
                                                      '${levels[selected_level]}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 10),
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                    Radius.circular((6)),
                                                  ),
                                                  color: Colors.black54),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 6,
                                                    left: 00,
                                                    right: 00,
                                                    bottom: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 10),
                                                    Text(
                                                      '${l_start[selected_level]}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white60,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      if (_currentPage > 0 &&
                                          (widget.fromPath == 2) &&
                                          selected_level > -1)
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 4),
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                    Radius.circular((6)),
                                                  ),
                                                  color: Colors.orange),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 6,
                                                    left: 00,
                                                    right: 00,
                                                    bottom: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Level up',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      Icons.plus_one,
                                                      size: 16,
                                                    ),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 4),
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                    Radius.circular((6)),
                                                  ),
                                                  color: Colors.black54),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 6,
                                                    left: 00,
                                                    right: 00,
                                                    bottom: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'No Change',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white60,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 10),
                                              decoration: new BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                    Radius.circular((6)),
                                                  ),
                                                  color: Colors.black54),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 6,
                                                    left: 00,
                                                    right: 00,
                                                    bottom: 6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Level down',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white60,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )

                                      /*Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  Container(
                                      margin: EdgeInsets.only( top:10),
                                      padding: EdgeInsets.all(12),
                                      height: 45,
                                      decoration: new BoxDecoration(

                                        borderRadius: new BorderRadius.all(
                                            Radius.circular((30))),
                                        gradient: new LinearGradient(
                                            colors: [
                                              Colors.blue[100].withOpacity(.8),
                                              Colors.blue[100].withOpacity(.6),
                                            ],
                                            begin: const FractionalOffset(0.0, 0.0),
                                            end: const FractionalOffset(1.0, 1.00),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                      ),
                                      child:Icon(Icons.arrow_forward_ios)),



                                ],)*/
                                    ],
                                  ))),
                        ],
                      ),
                    )
                ],
              ),
              margin: EdgeInsets.only(top: 2),
              padding: EdgeInsets.only(left: 0, right: 0),
            ),
          )),
    );
  }

  void _settingModalBottomSheet(context, int path) {
    //1:for description of fromPath 5//2

    String firstOption = "";
    String hint = "";

    if (path == 1) {
      hint = "Enter a question like did you .. today ?";
      firstOption = "Set question";
    }
    if (path == 2) {
      hint = "";
      sheetController.text = choiceList[selected_option];
      firstOption = "Edit option";
    }
    if (path == 3) {
      sheetController.clear();
      hint = "Add choice";
      firstOption = "add option";
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular((20)),
                topRight: Radius.circular((20)),
              ),
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFF00c6ff),
                    Theme.of(context).primaryColor,
                  ],
                  begin: const FractionalOffset(1.0, 1.0),
                  end: const FractionalOffset(0.0, 0.00),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: new Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 20,
                      top: 20),
                  child: TextField(
                    focusNode: sheetFocus,
                    autofocus: true,
                    controller: sheetController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSubmitted: (text) {
                      sheetFocus.unfocus();

                      if (path == 1) {
                        desTrack = sheetController.text;
                        sheetController.clear();
                        Navigator.pop(context);
                      }
                      if (path == 2) {
                        setState(() {
                          choiceList[selected_option] = sheetController.text;
                        });

                        sheetController.clear();
                        Navigator.pop(context);
                      }
                      if (path == 3) {
                        setState(() {
                          choiceList.add(sheetController.text);
                        });

                        sheetController.clear();
                        Navigator.pop(context);
                      }
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: hint,
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
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
                      child: new Text(firstOption),
                      onPressed: () async {},
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
          );
        });
  }

  Widget _buildCategoryCard2(int index, String name) {
    String count = "";

    return GestureDetector(
      onTap: () {
        setState(() {
          titleTrack = name;
          nameController.text = name;
          nameFocus.unfocus();
        });

        if (widget.fromPath == 5) {
          _settingModalBottomSheet(context, 1);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular((8))),
            color: Colors.white60),
        height: 40,
        child: Stack(
          children: <Widget>[
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: 'ZillaSlab',
                  fontSize: 22,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard2page(int index, String name) {
    String count = "";

    return GestureDetector(
      onTap: () {
        setState(() {
          /*  titleTrack=name;
          nameController.text=name;*/
          selected_aim = name + " hr";
          selected_hr = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular((8))),
            color: (selected_hr == index)
                ? Colors.lightBlueAccent
                : Colors.white60),
        height: 40,
        child: Stack(
          children: <Widget>[
            Text(
              name + " hr",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: 'ZillaSlab',
                  fontSize: 22,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard2page5(int index, String name) {
    String count = "";
    int color = index % 5;

    return GestureDetector(
      onTap: () {
        setState(() {
          /*  titleTrack=name;
          nameController.text=name;*/
          selected_option = index;
          _settingModalBottomSheet(context, 2);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular((8))),
            color: (selected_option == index)
                ? Colors.blueGrey
                : Colors.blue[(color + 1) * 100]),
        height: 40,
        child: Stack(
          children: <Widget>[
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: (selected_option == index)
                      ? Colors.white
                      : Colors.black87,
                  fontFamily: 'ZillaSlab',
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard2page3(int index, String name) {
    String count = "";
    int color = index % 5;

    return GestureDetector(
      onTap: () {
        setState(() {
          /*  titleTrack=name;
          nameController.text=name;*/
          selected_max = index;
          rate_below1 = "Zero";
          rate_below2 = "$name";
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular((8))),
            color: (selected_max == index)
                ? Colors.blueGrey
                : Colors.blue[(color + 1) * 100]),
        height: 40,
        child: Stack(
          children: <Widget>[
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color:
                      (selected_max == index) ? Colors.white : Colors.black87,
                  fontFamily: 'ZillaSlab',
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard2page2(int index, String name) {
    String count = "";
    int color = index % 9;

    return GestureDetector(
      onTap: () {
        setState(() {
          /*  titleTrack=name;
          nameController.text=name;*/
          selected_level = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular((8))),
            color: (selected_level == index)
                ? Colors.blueGrey
                : Colors.blue[(color + 1) * 100]),
        height: 40,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular((8))),
                      color: Colors.white.withOpacity(.6)),
                  height: 22,
                  child: Text(
                    "Level : " + l_int[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: (selected_level == index)
                            ? Colors.white
                            : Colors.black87,
                        fontFamily: 'ZillaSlab',
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                )),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color:
                      (selected_level == index) ? Colors.white : Colors.black87,
                  fontFamily: 'ZillaSlab',
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard3page(int index, String name) {
    String count = "";

    return GestureDetector(
      onTap: () {
        setState(() {
          /*  titleTrack=name;
          nameController.text=name;*/

          selected_interval = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular((8))),
            color: (selected_interval == index)
                ? Colors.lightBlueAccent
                : Colors.white60),
        height: 40,
        child: Stack(
          children: <Widget>[
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: 'ZillaSlab',
                  fontSize: 22,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
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

  Future<void> handleSave() async {

    QuestionModel this_question=new QuestionModel(title:titleTrack,content: desTrack,weight:slider_priority,last_date: DateTime.now(),showDashboard: 0,archive: 0,);

    if (selected_interval==0)this_question.interval=1;
    else if (selected_interval==1)this_question.interval=2;
    else if (selected_interval==2)this_question.interval=3;
    if (widget.fromPath==1){

      this_question.correct_ans=(hours[selected_hr]*60).floor();
      this_question.type=2;
      this_question.min=0;
      this_question.max=this_question.correct_ans+60;
    }

    else if (widget.fromPath==2){

      this_question.correct_ans=l_start[selected_level];
      this_question.type=3;
      this_question.ans1=levels[selected_level];
      this_question.min=0;
      this_question.max=0;
    }
    else if (widget.fromPath==3){


      this_question.min=0;
      this_question.type=4;
      this_question.max=maxs[selected_max];
    }

    else if (widget.fromPath==4){



      this_question.type=0;

    }
    else if (widget.fromPath==5){


      this_question.min=0;
      this_question.type=1;
      this_question.num_ans=choiceList.length;
      if (choiceList.length>0)  this_question.ans1=choiceList[0];
      if (choiceList.length>1)  this_question.ans2=choiceList[1];
      if (choiceList.length>2)  this_question.ans3=choiceList[2];

    }

    await NotesDatabaseService.db.addQuestionInDB(this_question);
    Navigator.pop(context);

  }
}
