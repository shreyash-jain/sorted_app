import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/ONBOARDING/presentation/bloc/onboarding_bloc.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/interest_bloc/interest_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/usertagItem.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/progressBar.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/userActivityItem.dart';

class InterestsPV extends StatefulWidget {
  final int currentPage;
  final LoginPage loginWidget;
  const InterestsPV({
    Key key,
    this.loginWidget,
    this.currentPage,
  }) : super(key: key);

  @override
  _InterestsPVState createState() => _InterestsPVState();
}

class _InterestsPVState extends State<InterestsPV> {
  final controller = TextEditingController();
  String inputStr;

  FocusNode ageFocus = FocusNode();

  ScrollController _scrollController;
  UserInterestBloc bloc;
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );
    if (mounted)
      bloc = UserInterestBloc(
          repository: sl(),
          flowBloc: BlocProvider.of<UserIntroductionBloc>(context))
        ..add(LoadInterest());

    print("Login Body");
  }

  void _toEnd() {
    // NEW
    _scrollController.animateTo(
      // NEW
      _scrollController.position.maxScrollExtent, // NEW
      duration: const Duration(milliseconds: 500), // NEW
      curve: Curves.ease, // NEW
    ); // NEW
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ListView(
        children: <Widget>[
          Container(
            height: 80,
            margin: EdgeInsets.only(top: Gparam.heightPadding),
            child: Stack(
              children: [
                Row(children: <Widget>[
                  Container(
                      height: Gparam.height / 10,
                      width: (Gparam.width / 1),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProgressBar(
                                  currentPage: widget.currentPage,
                                  widget: widget.loginWidget)
                            ],
                          ),
                        ],
                      )),
                ]),
              ],
            ),
          ),
          AnimatedOpacity(
              duration: Duration(seconds: 1),
              curve: Curves.easeOutQuint,
              opacity: 1,
              child: FadeAnimationTB(
                .9,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocProvider(
                      create: (_) => bloc,
                      child: BlocListener<UserInterestBloc, UserInterestState>(
                        listener: (context, state) {},
                        child: BlocBuilder<UserInterestBloc, UserInterestState>(
                          builder: (context, state) {
                            if (state is LoadedState) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Gparam.widthPadding,
                                          top: 0,
                                          bottom: Gparam.widthPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF307df0),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(.03),
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    blurRadius: 2)
                                              ],
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Fitness',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: Gparam.widthPadding),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          top: Gparam.heightPadding / 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(.06),
                                            width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.only(
                                            topRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(12.0),
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(0.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ...giveListForTagsView(
                                                    state.fitnessTags,
                                                    state.fitnessChosenTags,
                                                    0)
                                              ],
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(Gparam.widthPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF0ec76a),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(.03),
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    blurRadius: 2)
                                              ],
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Mental Health',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: Gparam.widthPadding),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          top: Gparam.heightPadding / 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(.03),
                                            width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.only(
                                            topRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(12.0),
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(0.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ...giveListForTagsView(
                                                    state.mentalHealthTags,
                                                    state
                                                        .mentalHealthChosenTags,
                                                    1)
                                              ],
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(Gparam.widthPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFffbb29),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(.03),
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    blurRadius: 2)
                                              ],
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Food and Nutrition',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: Gparam.widthPadding),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          top: Gparam.heightPadding / 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(.03),
                                            width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.only(
                                            topRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(12.0),
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(0.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ...giveListForTagsView(
                                                    state.foodTags,
                                                    state.foodChosenTags,
                                                    2)
                                              ],
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(Gparam.widthPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF63056e),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(.03),
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    blurRadius: 2)
                                              ],
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Productivity',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: Gparam.widthPadding),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          top: Gparam.heightPadding / 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(.03),
                                            width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.only(
                                            topRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(12.0),
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(0.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ...giveListForTagsView(
                                                    state.productivityTags,
                                                    state
                                                        .productivityChosenTags,
                                                    3)
                                              ],
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(Gparam.widthPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFe37724),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(.03),
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    blurRadius: 2)
                                              ],
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Family and Relationship',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: Gparam.widthPadding),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          top: Gparam.heightPadding / 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(.03),
                                            width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.only(
                                            topRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(12.0),
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(0.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ...giveListForTagsView(
                                                    state.familyTags,
                                                    state.familyChosenTags,
                                                    4)
                                              ],
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(Gparam.widthPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFed4040),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(.03),
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    blurRadius: 2)
                                              ],
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Career',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: Gparam.widthPadding),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          top: Gparam.heightPadding / 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(.03),
                                            width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.only(
                                            topRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(12.0),
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(0.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ...giveListForTagsView(
                                                    state.careerTags,
                                                    state.careerChosenTags,
                                                    5)
                                              ],
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(Gparam.widthPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF42ede5),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(.03),
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(1, 1),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    blurRadius: 2)
                                              ],
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Finance and Money',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: Gparam.widthPadding),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          top: Gparam.heightPadding / 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(.03),
                                            width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.only(
                                            topRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(12.0),
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(0.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                ...giveListForTagsView(
                                                    state.financeTags,
                                                    state.financeChosenTags,
                                                    6)
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 200,
                                    )
                                  ],
                                ),
                              );
                            } else if (state is LoadingState) {
                              return LoadingWidget();
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  List<Widget> giveListForTagsView(
      List<UserTag> tags, List<UserTag> selectedTags, int type) {
    List<Widget> list = [];
    int tagLength = tags.length;
    int threeType = (tagLength % 3 == 0) ? 0 : (tagLength % 3 == 1) ? 1 : 2;

    int numLists = ((tagLength ~/ 3)).toInt();
    for (int i = 0; i < numLists; i++) {
      Widget thisWidget = Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              UserTagItem(
                type: type,
                  index: 3 * i,
                  onTapAction: selectActivity,
                  userSelectedTags: selectedTags,
                  userTag: tags[3 * i]),
              UserTagItem(
                  index: 3 * i + 1,
                   type: type,
                  onTapAction: selectActivity,
                  userSelectedTags: selectedTags,
                  userTag: tags[3 * i + 1]),
              UserTagItem(
                  index: 3 * i + 2,
                  onTapAction: selectActivity,
                   type: type,
                  userSelectedTags: selectedTags,
                  userTag: tags[3 * i + 2])
            ],
          ));
      list.add(thisWidget);
    }

    if (threeType == 2) {
      list.add(Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              UserTagItem(
                  index: 3 * (numLists),
                  onTapAction: selectActivity,
                   type: type,
                  userSelectedTags: selectedTags,
                  userTag: tags[3 * (numLists)]),
              UserTagItem(
                  index: 3 * (numLists) + 1,
                  onTapAction: selectActivity,
                   type: type,
                  userSelectedTags: selectedTags,
                  userTag: tags[3 * (numLists) + 1])
            ],
          )));
    } else if (threeType == 1) {
      list.add(Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              UserTagItem(
                  index: 3 * (numLists),
                  onTapAction: selectActivity,
                  type: type,
                  userSelectedTags: selectedTags,
                  userTag: tags[3 * (numLists)]),
            ],
          )));
    }
    return list;
  }

  selectActivity(UserTag userTag, UserInterestBloc interestBloc, int type) {
    interestBloc.add(Add(userTag, type));
  }
}

class ProfessionItem extends StatelessWidget {
  final String imagePath;
  final String professionName;
  const ProfessionItem({
    Key key,
    this.imagePath,
    this.professionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeAnimationTB(
      1.6,
      Column(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white30,
              BlendMode.dst,
            ),
            child: Container(
              child: Image(
                image: AssetImage(
                  imagePath,
                ),
                height: Gparam.height / 8,
                width: Gparam.height / 8,
              ),
            ),
          ),
          Text(professionName, style: Gtheme.black20)
        ],
      ),
    );
  }
}
