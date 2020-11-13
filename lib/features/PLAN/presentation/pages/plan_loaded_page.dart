import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/plusdomains/v1.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/circular_progress.dart';
import 'package:sorted/core/global/animations/progress_goal.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/UnicornOutlineButton.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/domain/entities/tab_model.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:sorted/features/PLAN/presentation/bloc/tab_widget_bloc/tab_bloc.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_goal.dart';
import 'package:sorted/features/PLAN/presentation/widgets/goal_list.dart';
import 'package:sorted/features/PLAN/presentation/widgets/tag_list.dart';
import 'package:sorted/features/PLAN/presentation/widgets/upcomingTasks.dart';

class PlanLoadedWidget extends StatefulWidget {
  const PlanLoadedWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PlanLoadedWidgetState();
}

class PlanLoadedWidgetState extends State<PlanLoadedWidget>
    with SingleTickerProviderStateMixin {
  double progress = 0.0;
  int currentTab = 0;
  TabBloc tabBloc;

  TabController _tabController;

  TextEditingController TimelineName = TextEditingController();

  var _newMediaLinkAddressController = TextEditingController();

  var _valueBudget = 0.0;
  int tabType = 0;

  double deadlineDouble = 0.0;

  ScrollController _scrollController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    tabBloc = TabBloc(sl<TaskRepository>());
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );

    super.initState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Hero(
        tag: "topRow",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(OMIcons.arrowBackIos,
                  color: Theme.of(context).primaryColor),
              tooltip: 'back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              padding: EdgeInsets.all(0),
              child: RichText(
                text: TextSpan(
                  text: 'Sorted',
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: Gparam.textMedium,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Planner',
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: Gparam.textMedium,
                        )),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(OMIcons.search, color: Theme.of(context).primaryColor),
              tooltip: 'reminders',
              onPressed: () {},
            ),
          ],
        ),
      ),
      Container(
        height: 80,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: Gparam.widthPadding),
            UnicornOutlineButton(
                strokeWidth: 2,
                radius: 100,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorLight,
                    Theme.of(context).accentColor,
                    Theme.of(context).backgroundColor
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                onPressed: null,
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: new LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(.8),
                        ],
                        begin: FractionalOffset.centerLeft,
                        end: FractionalOffset.bottomRight,
                        stops: [0.2, 0.8],
                        tileMode: TileMode.clamp),
                  ),
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.symmetric(vertical: 0),
                  child: Stack(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Plan',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: Gparam.textVerySmall,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(.6)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '\nToday',
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Gparam.textVerySmall,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(width: 8),
            UnicornOutlineButton(
                strokeWidth: 2,
                radius: 100,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorLight,
                    Theme.of(context).accentColor,
                    Theme.of(context).backgroundColor
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                onPressed: null,
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: new LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(.8),
                        ],
                        begin: FractionalOffset.centerLeft,
                        end: FractionalOffset.bottomRight,
                        stops: [0.2, 0.8],
                        tileMode: TileMode.clamp),
                  ),
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.symmetric(vertical: 0),
                  child: Stack(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Task',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: Gparam.textVerySmall,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(.6)),
                          children: <TextSpan>[
                            TextSpan(
                                text: '\nMatrix',
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Gparam.textVerySmall,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Router.navigator.pushNamed(
                  Router.kanbanPage,
                );
              },
              child: UnicornOutlineButton(
                  strokeWidth: 2,
                  radius: 100,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).accentColor,
                      Theme.of(context).backgroundColor
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  onPressed: null,
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: new LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(.8),
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.bottomRight,
                          stops: [0.2, 0.8],
                          tileMode: TileMode.clamp),
                    ),
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(vertical: 0),
                    child: Stack(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Board',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: Gparam.textVerySmall,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(.6)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\nView',
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Gparam.textVerySmall,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Router.navigator.pushNamed(
                  Router.timelineView,
                );
              },
              child: UnicornOutlineButton(
                  strokeWidth: 2,
                  radius: 100,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).accentColor,
                      Theme.of(context).backgroundColor
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  onPressed: null,
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: new LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(.8),
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.bottomRight,
                          stops: [0.2, 0.8],
                          tileMode: TileMode.clamp),
                    ),
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(vertical: 0),
                    child: Stack(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Timeline',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: Gparam.textVerySmall,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(.6)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\nView',
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Gparam.textVerySmall,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Router.navigator.pushNamed(
                  Router.timelineView,
                );
              },
              child: UnicornOutlineButton(
                  strokeWidth: 2,
                  radius: 100,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).accentColor,
                      Theme.of(context).backgroundColor
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  onPressed: null,
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: new LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(.8),
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.bottomRight,
                          stops: [0.2, 0.8],
                          tileMode: TileMode.clamp),
                    ),
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(vertical: 0),
                    child: Stack(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Month',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: Gparam.textVerySmall,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\nPlanner',
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(.6),
                                    fontWeight: FontWeight.w500,
                                    fontSize: Gparam.textVerySmall,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Router.navigator.pushNamed(
                  Router.yearPlanner,
                );
              },
              child: UnicornOutlineButton(
                  strokeWidth: 2,
                  radius: 100,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).accentColor,
                      Theme.of(context).backgroundColor
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  onPressed: null,
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: new LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(.8),
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.bottomRight,
                          stops: [0.2, 0.8],
                          tileMode: TileMode.clamp),
                    ),
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(vertical: 0),
                    child: Stack(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Year',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: Gparam.textVerySmall,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\nPlanner',
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(.6),
                                    fontWeight: FontWeight.w500,
                                    fontSize: Gparam.textVerySmall,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                Router.navigator.pushNamed(
                  Router.longPlanner,
                );
              },
              child: UnicornOutlineButton(
                  strokeWidth: 2,
                  radius: 100,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).accentColor,
                      Theme.of(context).backgroundColor
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  onPressed: null,
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: new LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(.8),
                          ],
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.bottomRight,
                          stops: [0.2, 0.8],
                          tileMode: TileMode.clamp),
                    ),
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(vertical: 0),
                    child: Stack(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Long T',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: Gparam.textVerySmall,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '\nPlanner',
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(.6),
                                    fontWeight: FontWeight.w500,
                                    fontSize: Gparam.textVerySmall,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
      SizedBox(
        height: Gparam.heightPadding / 2,
      ),
      InkWell(
        onTap: () {
          _NewTimelineBottomSheet(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: Gparam.widthPadding),
            Container(
              padding: EdgeInsets.all(0),
              child: RichText(
                text: TextSpan(
                  text: 'My',
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: Gparam.textMedium,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Goals',
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Gparam.textSmall,
                        )),
                  ],
                ),
              ),
            ),
            Spacer(),
            Icon(
              Icons.add,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: Gparam.widthPadding / 4,
            ),
            RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                text: "new",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: Gparam.textSmall,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
                children: <TextSpan>[
                  TextSpan(
                      text: " Goal ",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Gparam.textSmall,
                      )),
                ],
              ),
            ),
            SizedBox(
              width: Gparam.widthPadding / 2,
            ),
          ],
        ),
      ),
      SizedBox(
        height: Gparam.heightPadding / 2,
      ),
      GoalListWidget(),
      SizedBox(height: Gparam.heightPadding / 2),
      if ((BlocProvider.of<PlanBloc>(context).state as PlanLoaded)
              .upComingTasks
              .length >
          0)
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: Gparam.widthPadding),
            Container(
              padding: EdgeInsets.all(0),
              child: RichText(
                text: TextSpan(
                  text: 'Upcoming',
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: Gparam.textMedium,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Tasks',
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Gparam.textSmall,
                        )),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      if ((BlocProvider.of<PlanBloc>(context).state as PlanLoaded)
              .upComingTasks
              .length >
          0)
        SizedBox(
          height: Gparam.heightPadding / 2,
        ),
      if ((BlocProvider.of<PlanBloc>(context).state as PlanLoaded)
              .upComingTasks
              .length >
          0)
        UpcomingTasks(),
      SizedBox(height: Gparam.heightPadding / 2),
      Container(
        height: 56,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (BlocProvider.of<PlanBloc>(context).state as PlanLoaded)
                  .tabs
                  .length +
              1,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return SizedBox(width: Gparam.widthPadding);
            }

            return _buildTabCard(
              index - 1,
              (BlocProvider.of<PlanBloc>(context).state as PlanLoaded)
                  .tabs[index - 1],
            );
          },
        ),
      ),
      SizedBox(height: Gparam.heightPadding / 2),
      if ((BlocProvider.of<PlanBloc>(context).state as PlanLoaded).tabs.length >
          0)
        BlocProvider(
          create: (context) => tabBloc
            ..add(UpdateTasks(
                (BlocProvider.of<PlanBloc>(context).state as PlanLoaded)
                    .tabs[0])),
          child: BlocBuilder<TabBloc, TabState>(
            builder: (context, state) {
              if (state is TabLoaded)
                return ListView.builder(
                    itemCount: state.tasks.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        secondaryBackground: slideRightBackground(state.tab),
                        background: slideLeftBackground(state.tab),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd &&
                              getTabType(state.tab) != -1 &&
                              state.tab.type == 0) {
                            final bool res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    content: Hero(
                                      tag: state.tasks[index].id.toString(),
                                      child: Container(
                                          child: Text(
                                        state.tasks[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: Gparam.textSmall,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          "Move to Completed",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        onPressed: () {
                                          // TODO: Delete the item from DB etc..
                                          setState(() {
                                            // itemsList.removeAt(index);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                            return res;
                          } else if (direction == DismissDirection.endToStart &&
                              getTabType(state.tab) != 1 &&
                              state.tab.type == 0) {
                            final bool res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    content: RichText(
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                      text: TextSpan(
                                        text: "",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: Gparam.textVerySmall,
                                            fontWeight: FontWeight.w300,
                                            color:
                                                Theme.of(context).primaryColor),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "" + state.tasks[index].title,
                                              style: TextStyle(
                                                fontFamily: "Montserrat",
                                                height: 1.4,
                                                fontWeight: FontWeight.w500,
                                                fontSize: Gparam.textSmaller,
                                              )),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          "Move to Backlog",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        onPressed: () {
                                          // TODO: Delete the item from DB etc..
                                          setState(() {
                                            // itemsList.removeAt(index);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                            return res;
                          }
                        },
                        key: Key(state.tasks[index].id.toString()),
                        child: GestureDetector(
                          onTap: () {
                            Router.navigator.pushNamed(Router.taskPage,
                                arguments: TaskPageArguments(
                                    thisGoal: state.tasks[index],
                                    planBloc:
                                        BlocProvider.of<PlanBloc>(context)));
                            print("${index} clicked");
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: Gparam.widthPadding,
                                  right: Gparam.widthPadding,
                                  top: Gparam.heightPadding / 2),
                              padding: EdgeInsets.all(Gparam.widthPadding / 2),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                      color: (isNearDeadline(
                                              state.tasks[index].deadLine))
                                          ? Colors.redAccent.withAlpha(60)
                                          : Theme.of(context)
                                              .dialogBackgroundColor
                                              .withOpacity(.3),
                                      offset: Offset(4.0, 00),
                                      blurRadius: 20.0,
                                      spreadRadius: 3.0),
                                  BoxShadow(
                                      color: (isNearDeadline(
                                              state.tasks[index].deadLine))
                                          ? Colors.redAccent.withAlpha(60)
                                          : Theme.of(context)
                                              .dialogBackgroundColor
                                              .withOpacity(.3),
                                      offset: Offset(-4.0, 0.0),
                                      blurRadius: 20,
                                      spreadRadius: 3.0),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        child: CircleProgress(
                                          ringColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          radius: 10.0,
                                          dotColor:
                                              Theme.of(context).primaryColor,
                                          dotRadius: 2.0,
                                          shadowColor: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(150),
                                          shadowWidth: 1.0,
                                          dotEdgeColor: Theme.of(context)
                                              .primaryColorLight,
                                          progress: state.tasks[index].progress,
                                          progressChanged: (value) {
                                            setState(() {
                                              progress = value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: Gparam.widthPadding / 2,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            state.tasks[index].title,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontFamily: 'Montserrat',
                                                fontSize: Gparam.textSmall,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Gparam.heightPadding / 2,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          text: pastDeadline(
                                                  state.tasks[index].deadLine) +
                                              " ",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textVerySmall,
                                              fontWeight: FontWeight.w300,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: countdownDays(state
                                                    .tasks[index].deadLine),
                                                style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                )),
                                            TextSpan(
                                                text: countdownDaysUnit(state
                                                    .tasks[index].deadLine),
                                                style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        (state.tasks[index].priority > .6)
                                            ? Icons.trending_up
                                            : (state.tasks[index].priority > .3)
                                                ? Icons.trending_flat
                                                : Icons.trending_down,
                                        color: Theme.of(context).primaryColor,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: Gparam.widthPadding / 4,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          text: getPriorityString(
                                              state.tasks[index].priority),
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textVerySmall,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: " priority",
                                                style: TextStyle(
                                                  fontFamily: "Montserrat",
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      );
                    });
              else if (state is TabLoading) {
                return Container(
                  width: 0,
                  height: 0,
                );
              }
            },
          ),
        )
    ]);
  }

  countdownDays(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays > 0) {
      if (rDays > 365)
        return (rDays / 356).floor().toString();
      else
        return rDays.toString();
    } else if (rDays < 0) {
      if (rDays < -365)
        return (rDays / -356).floor().toString();
      else
        return rDays.abs().toString();
    } else {
      return deadLine.difference(DateTime.now()).inHours.abs().toString();
    }
  }

  bool isNearDeadline(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays.abs() < 2) {
      return true;
    }
    return false;
  }

  countdownDaysUnit(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays.abs();
    if (rDays > 0) {
      if (rDays > 365) {
        if (rDays / 365 > 1)
          return " years";
        else
          return " year";
      } else {
        if (rDays > 1)
          return " days";
        else
          return " day";
      }
    } else {
      return " hrs";
    }
  }

  pastDeadline(DateTime deadLine) {
    int rDays = deadLine.difference(DateTime.now()).inDays;
    if (rDays > 0) {
      return "Deadline in";
    } else if (rDays < 0) {
      return "Past deadline";
    } else {
      if (deadLine.isAfter(DateTime.now())) {
        return "Deadline in";
      } else
        return "Past deadline";
    }
  }

  void _NewTimelineBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddGoal(
              newMediaLinkAddressController: _newMediaLinkAddressController,
              deadlineDouble: deadlineDouble,
              onDeadlineChanged: (double value) {
                setState(() {
                  onDeadlineChanged(value);
                });
              },
            );
          });
        });
  }

  int getTabType(PlanTabDetails tab) {
    if (tab.search == "Completed")
      return 1;
    else if (tab.search == "Backlog")
      return -1;
    else
      return 0;
  }

  Widget _buildTabCard(int i, PlanTabDetails tab) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTab = i;
          print(i);
          tabBloc.add(UpdateTasks(tab));
        });
      },
      child: Stack(
        children: [
          // Container(
          //   child: AnimatedContainer(
          //    margin: EdgeInsets.only(left: Gparam.widthPadding / 2),
          //    decoration: new BoxDecoration(
          //      color: Theme.of(context).primaryColor,
          //      borderRadius: new BorderRadius.all(
          //        Radius.circular(8),
          //      ),
          //    ),
          //    height: 2,
          //    width: (currentTab == i) ? 40 : 0,
          //    duration: Duration(milliseconds: 300),
          //    curve: Curves.fastOutSlowIn,
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              child: AnimatedContainer(
                margin: EdgeInsets.only(left: Gparam.widthPadding / 2),
                decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                height: 6,
                width: (currentTab == i) ? 6 : 0,
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              ),
            ),
          ),

          Row(
            children: [
              if (tab.imagePath != null && tab.imagePath != "")
                Container(
                    width: 36,
                    height: 36,
                    padding: EdgeInsets.all(6),
                    decoration: new BoxDecoration(
                        color: (currentTab != i)
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Theme.of(context).primaryColor,
                        borderRadius:
                            new BorderRadius.all(Radius.circular(30.0))),
                    child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          (currentTab != i)
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(context).primaryColor,
                          BlendMode.hue,
                        ),
                        child: Image(
                          image: AssetImage(
                            tab.imagePath,
                          ),
                        ))),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(0),
                margin:
                    EdgeInsets.only(left: 8, right: Gparam.widthPadding / 2),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    children: [
                      AnimatedDefaultTextStyle(
                        style: (currentTab == i)
                            ? TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textSmall,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor)
                            : TextStyle(
                                fontSize: Gparam.textSmaller,
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400),
                        duration: const Duration(milliseconds: 200),
                        child: Text(tab.tabName),
                      ),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        text: TextSpan(
                          text: " tasks",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textSmaller,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                  //RichText(
                  //   overflow: TextOverflow.ellipsis,
                  //   maxLines: 2,
                  //   text: TextSpan(
                  //     text: tab.tabName,
                  //     style: TextStyle(
                  //         fontFamily: 'Montserrat',
                  //         fontSize: Gparam.textSmall,
                  //         fontWeight: FontWeight.w800,
                  //         color: Theme.of(context).primaryColor),
                  //     children: <TextSpan>[
                  //       TextSpan(
                  //           text: " tasks",
                  //           style: TextStyle(
                  //             fontFamily: "Montserrat",
                  //             height: 1.2,
                  //             color: Theme.of(context).primaryColor,
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: Gparam.textSmall,
                  //           )),
                  //     ],
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onDeadlineChanged(double value) {
    setState(() {
      print("ch");
      deadlineDouble = value;
    });
  }

  String getPriorityString(double priority) {
    if (priority < .3)
      return "Low";
    else if (priority < .6)
      return "Medium";
    else
      return "High";
  }

  Widget slideRightBackground(PlanTabDetails tab) {
    return Container(
      margin: EdgeInsets.only(top: Gparam.heightPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (getTabType(tab) != -1 && tab.type == 0)
              Icon(
                Icons.settings_backup_restore,
              ),
            Text(
              (getTabType(tab) != -1 && tab.type == 0) ? " Mark Backlog" : "",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground(PlanTabDetails tab) {
    return Container(
      margin: EdgeInsets.only(top: Gparam.heightPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            if (getTabType(tab) != 1 && tab.type == 0)
              Icon(
                Icons.check_box,
              ),
            Text(
              (getTabType(tab) != 1 && tab.type == 0) ? " Mark Completed" : "",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
