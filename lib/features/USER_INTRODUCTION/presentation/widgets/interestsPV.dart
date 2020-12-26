import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/ONBOARDING/presentation/bloc/onboarding_bloc.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/interest_bloc/interest_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/activityItem.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/userActivityItem.dart';

class InterestsPV extends StatefulWidget {
  final LoginPage loginWidget;
  const InterestsPV({
    Key key,
    this.loginWidget,
  }) : super(key: key);

  @override
  _InterestsPVState createState() => _InterestsPVState();
}

class _InterestsPVState extends State<InterestsPV> {
  final controller = TextEditingController();
  String inputStr;

  FocusNode ageFocus = FocusNode();

  ScrollController _scrollController;
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );

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
          Padding(
            padding: EdgeInsets.only(
                top: Gparam.topPadding,
                left: Gparam.widthPadding,
                right: Gparam.widthPadding),
            child: FadeAnimationTB(
              1.6,
              Container(
                child: Text(
                  'What are your Hobbies ?',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(.8)),
                ),
              ),
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
                    SizedBox(
                      height: Gparam.heightPadding,
                    ),
                    BlocProvider(
                      create: (_) => UserInterestBloc(
                          repository: sl(),
                          flowBloc:
                              BlocProvider.of<UserIntroductionBloc>(context)),
                      child: BlocListener<UserInterestBloc, UserInterestState>(
                        listener: (context, state) {},
                        child: BlocBuilder<UserInterestBloc, UserInterestState>(
                          builder: (context, state) {
                            if (state is LoadedState) {
                              return Column(
                                children: [
                                  Container(
                                    height: Gparam.height / 4,
                                    margin: EdgeInsets.only(
                                        left: Gparam.widthPadding),
                                    padding: EdgeInsets.only(
                                        left: 2,
                                        top: Gparam.heightPadding / 2,
                                        bottom: Gparam.heightPadding / 2),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Colors.black.withOpacity(.03),
                                          width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(1, 1),
                                            color: Colors.black.withAlpha(10),
                                            blurRadius: 2)
                                      ],
                                      borderRadius: new BorderRadius.only(
                                          topRight: Radius.circular(0.0),
                                          topLeft: Radius.circular(30.0),
                                          bottomLeft: Radius.circular(30.0),
                                          bottomRight: Radius.circular(0.0)),
                                    ),
                                    child: FadeAnimationTB(
                                        1.6,
                                        Container(
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: widget.loginWidget
                                                      .allActivities.length +
                                                  1,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (index == 0) {
                                                  return SizedBox(
                                                    width:
                                                        Gparam.widthPadding / 4,
                                                  );
                                                }
                                                return ActivityItem(
                                                    index: index - 1,
                                                    onTapAction: selectActivity,
                                                    userActivities:
                                                        state.activities,
                                                    activity: widget.loginWidget
                                                            .allActivities[
                                                        index - 1]);
                                              }),
                                        )),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 2,
                                        top: Gparam.heightPadding / 2,
                                        bottom: Gparam.heightPadding / 2),
                                    child: FadeAnimationTB(
                                        1.6,
                                        Container(
                                          margin: EdgeInsets.all(
                                              Gparam.widthPadding),
                                          height: Gparam.height / 6,
                                          child: GridView.builder(
                                            shrinkWrap: false,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: state.activities.length,
                                            controller: _scrollController,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: (2),
                                              childAspectRatio: .7,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              //if (index < 50)
                                              return Container(
                                                  child: UserActivityItem(
                                                      index: index,
                                                      activity: state
                                                          .activities[index]));
                                            },
                                          ),
                                        )),
                                  ),
                                ],
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

  selectActivity(ActivityModel activity, UserInterestBloc interestBloc) {
    if ((interestBloc.state as LoadedState)
            .activities
            .where((element) => element.aId == activity.id)
            .length ==
        0) {
      UserAModel newUserActivity = new UserAModel(
          name: activity.name, aId: activity.id, image: activity.image);
      interestBloc.add(Add(newUserActivity));
      
      _toEnd();
    } else {
      UserAModel toRemove = (interestBloc.state as LoadedState)
          .activities
          .firstWhere((element) => element.aId == activity.id);
      interestBloc.add(Remove(toRemove));
    }
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
