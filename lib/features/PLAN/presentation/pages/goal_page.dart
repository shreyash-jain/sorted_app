import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/circular_progress.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/presentation/bloc/goal_page_bloc/goal_page_bloc.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_attachment.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_event.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_link.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_task.dart';

class GoalPage extends StatefulWidget {
  final GoalModel thisGoal;
  final PlanBloc planBloc;
  const GoalPage({Key key, this.thisGoal, this.planBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GoalPageState();
}

class GoalPageState extends State<GoalPage> {
  Emoji emojiProfile = Emoji(name: "Heavy Plus Sign", emoji: "➕");
  bool isShowSticker = false;
  bool showVision = false;
  bool showMotivation = false;
  GoalPageBloc bloc;

  var _newMediaLinkAddressController = TextEditingController();

  var deadlineDouble = 0.0;
  @override
  void initState() {
    bloc = GoalPageBloc(sl(), sl(), widget.planBloc)
      ..add(LoadGoalPage(widget.thisGoal));
    super.initState();
    print(widget.thisGoal.coverImageId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return BlocProvider(
          create: (_) => bloc,
          child: Center(child: BlocBuilder<GoalPageBloc, GoalPageBlocState>(
              builder: (context, state) {
            if (state is Error) {
              return MessageDisplay(
                message: 'Start searching!',
              );
            } else if (state is GoalPageLoading) {
              return Center(child: LoadingWidget());
            } else if (state is GoalPageLoaded) {
              return SingleChildScrollView(
                child: Stack(children: [
                  Column(
                    children: [
                      Stack(children: [
                        if (state.thisGoal.coverImageId != "0")
                          Hero(
                            tag: state.thisGoal.id.toString(),
                            child: Container(
                              width: Gparam.width,
                              height: 200,
                              margin: EdgeInsets.only(
                                  right: Gparam.widthPadding / 4,
                                  left: Gparam.widthPadding / 4,
                                  bottom: Gparam.heightPadding),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0)),
                              ),
                              child: ClipRRect(
                                  borderRadius: new BorderRadius.only(
                                      bottomLeft: Radius.circular(16.0),
                                      bottomRight: Radius.circular(16.0)),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.grey,
                                    ),
                                    imageUrl: state.thisGoal.coverImageId,
                                    fit: BoxFit.cover,
                                    width: 200,
                                  )),
                            ),
                          ),
                        Hero(
                          tag: "null",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding / 2,
                                  ),
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(16.0)),
                                    gradient: new LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .scaffoldBackgroundColor
                                              .withAlpha(130),
                                          Theme.of(context)
                                              .scaffoldBackgroundColor
                                              .withAlpha(130),
                                        ],
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        stops: [1.0, 0.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(OMIcons.arrowBackIos,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              if (state.thisGoal.coverImageId == "0")
                                Container(
                                  padding: EdgeInsets.all(0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Goal',
                                      style: TextStyle(
                                          fontFamily: 'Milliard',
                                          fontSize: Gparam.textMedium,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Theme.of(context).highlightColor),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' Planner',
                                            style: TextStyle(
                                              fontFamily: "Milliard",
                                              color: Theme.of(context)
                                                  .highlightColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: Gparam.textMedium,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              IconButton(
                                icon: Icon(OMIcons.search,
                                    color: Theme.of(context).primaryColor),
                                tooltip: 'reminders',
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        if (state.thisGoal.coverImageId != "0")
                          Container(
                            width: Gparam.width,
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(6),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 6),
                                        alignment: Alignment.bottomCenter,
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(12.0)),
                                          gradient: new LinearGradient(
                                              colors: [
                                                Theme.of(context).primaryColor,
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(.8)
                                              ],
                                              begin: FractionalOffset.topCenter,
                                              end:
                                                  FractionalOffset.bottomCenter,
                                              stops: [.2, .8],
                                              tileMode: TileMode.repeated),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            context.router.push(
                                              SelectCover(goalBloc: bloc),
                                            );
                                          },
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.picture_in_picture,
                                                    size: 14,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                RichText(
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  text: TextSpan(
                                                    text: "Change ",
                                                    style: TextStyle(
                                                      fontFamily: 'Milliard',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: "cover",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Milliard",
                                                              height: 1.2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 14)),
                                                    ],
                                                  ),
                                                )
                                              ]),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                          )
                      ]),

                      Container(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isShowSticker = !isShowSticker;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Text(
                                                (state.thisGoal.goalImageId !=
                                                        "0")
                                                    ? state.thisGoal.goalImageId
                                                    : emojiProfile.emoji,
                                                style: TextStyle(
                                                    fontSize: 36,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              CircleProgress(
                                                ringColor: Theme.of(context)
                                                    .backgroundColor
                                                    .withOpacity(.2),
                                                radius: 30.0,
                                                dotColor: Theme.of(context)
                                                    .primaryColor,
                                                dotRadius: 3.0,
                                                shadowWidth: 1.0,
                                                shadowColor: Colors.transparent,
                                                dotEdgeColor: Theme.of(context)
                                                    .primaryColorLight,
                                                progress:
                                                    state.thisGoal.progress,
                                                progressChanged: (value) {},
                                              )
                                            ]),
                                        SizedBox(
                                          width: Gparam.widthPadding,
                                        ),
                                        Container(
                                            child: Flexible(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            text: TextSpan(
                                              text: state.thisGoal.title,
                                              style: TextStyle(
                                                  fontFamily: 'Milliard',
                                                  fontSize: Gparam.textSmall,
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      if (state.thisGoal.coverImageId == "0")
                        Container(
                          width: Gparam.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Gparam.widthPadding,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(6),
                                      margin: EdgeInsets.symmetric(vertical: 0),
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          context.router.push(
                                            SelectCover(goalBloc: bloc),
                                          );
                                        },
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.add_a_photo,
                                                  size: 14,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(
                                                  text: "Add ",
                                                  style: TextStyle(
                                                    fontFamily: 'Milliard',
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: "cover",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Milliard",
                                                            height: 1.2,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              )
                                            ]),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      Container(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: Gparam.widthPadding,
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 6),
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(16.0)),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.2),
                                        width: 1),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.timelapse,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        RichText(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            text: "Working since" + "\n",
                                            style: TextStyle(
                                              fontFamily: 'Milliard',
                                              fontSize: Gparam.textVerySmall,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: countdownDays(
                                                      state.thisGoal.savedTs),
                                                  style: TextStyle(
                                                    fontFamily: "Milliard",
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Gparam.textSmall,
                                                  )),
                                              TextSpan(
                                                  text: countdownDaysUnit(
                                                      state.thisGoal.savedTs),
                                                  style: TextStyle(
                                                    fontFamily: "Milliard",
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize:
                                                        Gparam.textVerySmall,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ])),
                              SizedBox(
                                width: 6,
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.all(6),
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(16.0)),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.2),
                                        width: 1),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.access_time,
                                            color:
                                                Theme.of(context).primaryColor),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        RichText(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            text: pastDeadline(
                                                    state.thisGoal.deadLine) +
                                                "\n",
                                            style: TextStyle(
                                              fontFamily: 'Milliard',
                                              fontSize: Gparam.textVerySmall,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: countdownDays(
                                                      widget.thisGoal.deadLine),
                                                  style: TextStyle(
                                                    fontFamily: "Milliard",
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Gparam.textSmall,
                                                  )),
                                              TextSpan(
                                                  text: countdownDaysUnit(
                                                      state.thisGoal.deadLine),
                                                  style: TextStyle(
                                                    fontFamily: "Milliard",
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize:
                                                        Gparam.textSmaller,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ])),
                              SizedBox(
                                width: 6,
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.symmetric(vertical: 6),
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(16.0)),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.2),
                                        width: 1),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.done_all,
                                            color:
                                                Theme.of(context).primaryColor),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        RichText(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            text: "Tasks done" + "\n",
                                            style: TextStyle(
                                              fontFamily: 'Milliard',
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: Gparam.textVerySmall,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "12",
                                                  style: TextStyle(
                                                    fontFamily: "Milliard",
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Gparam.textSmall,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ])),
                            ],
                          )),
                      Container(
                          height: 44,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: Gparam.widthPadding,
                              ),
                              InkWell(
                                onTap: () {
                                  _NewTaskBottomSheet(context);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(16.0)),
                                      gradient: new LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.8)
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          stops: [.2, .8],
                                          tileMode: TileMode.repeated),
                                    ),
                                    child: Row(children: [
                                      Icon(Icons.view_list,
                                          size: Gparam.textMedium,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          text: "Add ",
                                          style: TextStyle(
                                            fontFamily: 'Milliard',
                                            fontSize: Gparam.textVerySmall,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "Task",
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: Gparam.textSmaller,
                                                )),
                                          ],
                                        ),
                                      )
                                    ])),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  _NewEventBottomSheet(context);
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(16.0)),
                                      gradient: new LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.8)
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          stops: [.2, .8],
                                          tileMode: TileMode.repeated),
                                    ),
                                    child: Row(children: [
                                      Icon(Icons.trip_origin,
                                          size: Gparam.textMedium,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          text: "Add ",
                                          style: TextStyle(
                                            fontFamily: 'Milliard',
                                            fontSize: Gparam.textVerySmall,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "Event",
                                                style: TextStyle(
                                                  fontFamily: "Milliard",
                                                  height: 1.2,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: Gparam.textSmaller,
                                                )),
                                          ],
                                        ),
                                      )
                                    ])),
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(16.0)),
                                    gradient: new LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.8)
                                        ],
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        stops: [.2, .8],
                                        tileMode: TileMode.repeated),
                                  ),
                                  child: Row(children: [
                                    Icon(Icons.event_available,
                                        size: Gparam.textMedium,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                        text: "Add ",
                                        style: TextStyle(
                                          fontFamily: 'Milliard',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Milestone",
                                              style: TextStyle(
                                                fontFamily: "Milliard",
                                                height: 1.2,
                                                fontWeight: FontWeight.w300,
                                                fontSize: Gparam.textSmaller,
                                              )),
                                        ],
                                      ),
                                    )
                                  ])),
                            ],
                          )),
                      Container(
                          height: 44,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: Gparam.widthPadding,
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(
                                      right: 6, top: 4, bottom: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(16.0)),
                                    gradient: new LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.8)
                                        ],
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        stops: [.2, .8],
                                        tileMode: TileMode.repeated),
                                  ),
                                  child: Row(children: [
                                    Icon(Icons.track_changes,
                                        size: Gparam.textMedium,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                        text: "Link ",
                                        style: TextStyle(
                                          fontFamily: 'Milliard',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Track",
                                              style: TextStyle(
                                                fontFamily: "Milliard",
                                                height: 1.2,
                                                fontWeight: FontWeight.w300,
                                                fontSize: Gparam.textSmaller,
                                              )),
                                        ],
                                      ),
                                    )
                                  ])),
                              SizedBox(
                                width: 6,
                              ),
                              InkWell(
                                  onTap: () {
                                    _NewAttachmentBottomSheet(context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(16.0)),
                                        gradient: new LinearGradient(
                                            colors: [
                                              Theme.of(context).primaryColor,
                                              Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(.8)
                                            ],
                                            begin: FractionalOffset.topCenter,
                                            end: FractionalOffset.bottomCenter,
                                            stops: [.2, .8],
                                            tileMode: TileMode.repeated),
                                      ),
                                      child: Row(children: [
                                        Icon(Icons.attachment,
                                            size: Gparam.textMedium,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        RichText(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            text: "Add ",
                                            style: TextStyle(
                                              fontFamily: 'Milliard',
                                              fontSize: Gparam.textVerySmall,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Attachment",
                                                  style: TextStyle(
                                                    fontFamily: "Milliard",
                                                    height: 1.2,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize:
                                                        Gparam.textSmaller,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ]))),
                              SizedBox(
                                width: 6,
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(16.0)),
                                    gradient: new LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.8)
                                        ],
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        stops: [.2, .8],
                                        tileMode: TileMode.repeated),
                                  ),
                                  child: Row(children: [
                                    Icon(Icons.short_text,
                                        size: Gparam.textMedium,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                        text: "Add ",
                                        style: TextStyle(
                                          fontFamily: 'Milliard',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Note",
                                              style: TextStyle(
                                                fontFamily: "Milliard",
                                                height: 1.2,
                                                fontWeight: FontWeight.w300,
                                                fontSize: Gparam.textSmaller,
                                              )),
                                        ],
                                      ),
                                    )
                                  ])),
                            ],
                          )),

                      // Container(
                      //     height: 44,
                      //     child: ListView(
                      //       scrollDirection: Axis.horizontal,
                      //       children: [
                      //         SizedBox(
                      //           width: Gparam.widthPadding,
                      //         ),
                      //         Container(
                      //           padding: EdgeInsets.all(8),
                      //           margin: EdgeInsets.all(6),
                      //           decoration: BoxDecoration(
                      //             borderRadius:
                      //                 new BorderRadius.all(Radius.circular(16.0)),
                      //             gradient: new LinearGradient(
                      //                 colors: [
                      //                   Colors.greenAccent,
                      //                   Colors.greenAccent.withOpacity(.9)
                      //                 ],
                      //                 begin: FractionalOffset.topCenter,
                      //                 end: FractionalOffset.bottomCenter,
                      //                 stops: [.2, .8],
                      //                 tileMode: TileMode.repeated),
                      //           ),
                      //           child: Text('school',
                      //               style: TextStyle(
                      //                 fontFamily: 'Milliard',
                      //                 fontWeight: FontWeight.w800,
                      //                 color: Colors.white,
                      //                 fontSize: Gparam.textVerySmall,
                      //               )),
                      //         ),
                      //         Container(
                      //           padding: EdgeInsets.all(8),
                      //           margin: EdgeInsets.all(6),
                      //           decoration: BoxDecoration(
                      //             borderRadius:
                      //                 new BorderRadius.all(Radius.circular(16.0)),
                      //             gradient: new LinearGradient(
                      //                 colors: [
                      //                   Colors.blueAccent,
                      //                   Colors.blueAccent.withOpacity(.9)
                      //                 ],
                      //                 begin: FractionalOffset.topCenter,
                      //                 end: FractionalOffset.bottomCenter,
                      //                 stops: [.2, .8],
                      //                 tileMode: TileMode.repeated),
                      //           ),
                      //           child: Text('work',
                      //               style: TextStyle(
                      //                 fontFamily: 'Milliard',
                      //                 fontWeight: FontWeight.w800,
                      //                 color: Colors.white,
                      //                 fontSize: Gparam.textVerySmall,
                      //               )),
                      //         ),
                      //         Container(
                      //           padding: EdgeInsets.all(8),
                      //           margin: EdgeInsets.all(6),
                      //           decoration: BoxDecoration(
                      //             borderRadius:
                      //                 new BorderRadius.all(Radius.circular(16.0)),
                      //             gradient: new LinearGradient(
                      //                 colors: [
                      //                   Colors.deepPurpleAccent,
                      //                   Colors.deepPurpleAccent.withOpacity(.9)
                      //                 ],
                      //                 begin: FractionalOffset.topCenter,
                      //                 end: FractionalOffset.bottomCenter,
                      //                 stops: [.2, .8],
                      //                 tileMode: TileMode.repeated),
                      //           ),
                      //           child: Text('cloud',
                      //               style: TextStyle(
                      //                 fontFamily: 'Milliard',
                      //                 fontWeight: FontWeight.w800,
                      //                 color: Colors.white,
                      //                 fontSize: Gparam.textVerySmall,
                      //               )),
                      //         ),
                      //         Container(
                      //           padding: EdgeInsets.all(8),
                      //           margin: EdgeInsets.all(6),
                      //           decoration: BoxDecoration(
                      //             borderRadius:
                      //                 new BorderRadius.all(Radius.circular(16.0)),
                      //             gradient: new LinearGradient(
                      //                 colors: [
                      //                   Colors.redAccent,
                      //                   Colors.redAccent.withOpacity(.9)
                      //                 ],
                      //                 begin: FractionalOffset.topCenter,
                      //                 end: FractionalOffset.bottomCenter,
                      //                 stops: [.2, .8],
                      //                 tileMode: TileMode.repeated),
                      //           ),
                      //           child: Text('boss',
                      //               style: TextStyle(
                      //                 fontFamily: 'Milliard',
                      //                 fontWeight: FontWeight.w800,
                      //                 color: Colors.white,
                      //                 fontSize: Gparam.textVerySmall,
                      //               )),
                      //         ),
                      //         Container(
                      //           padding: EdgeInsets.all(8),
                      //           margin: EdgeInsets.all(6),
                      //           decoration: BoxDecoration(
                      //             borderRadius:
                      //                 new BorderRadius.all(Radius.circular(16.0)),
                      //             gradient: new LinearGradient(
                      //                 colors: [
                      //                   Colors.pinkAccent,
                      //                   Colors.pinkAccent.withOpacity(.9)
                      //                 ],
                      //                 begin: FractionalOffset.topCenter,
                      //                 end: FractionalOffset.bottomCenter,
                      //                 stops: [.2, .8],
                      //                 tileMode: TileMode.repeated),
                      //           ),
                      //           child: Text('documentation',
                      //               style: TextStyle(
                      //                   fontFamily: 'Milliard',
                      //                   fontSize: Gparam.textVerySmall,
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.w800)),
                      //         ),
                      //         Container(
                      //           padding: EdgeInsets.all(8),
                      //           margin: EdgeInsets.all(6),
                      //           decoration: BoxDecoration(
                      //             borderRadius:
                      //                 new BorderRadius.all(Radius.circular(16.0)),
                      //             gradient: new LinearGradient(
                      //                 colors: [
                      //                   Colors.yellowAccent,
                      //                   Colors.yellowAccent.withOpacity(.9)
                      //                 ],
                      //                 begin: FractionalOffset.topCenter,
                      //                 end: FractionalOffset.bottomCenter,
                      //                 stops: [.2, .8],
                      //                 tileMode: TileMode.repeated),
                      //           ),
                      //           child: Text('database',
                      //               style: TextStyle(
                      //                   fontFamily: 'Milliard',
                      //                   fontSize: Gparam.textVerySmall,
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.w800)),
                      //         ),
                      //       ],
                      //     )),
                      SizedBox(
                        height: Gparam.heightPadding,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showVision = !showVision;
                          });
                          print("vision" + showVision.toString());
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            child: RichText(
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: (showVision) ? 10 : 2,
                                text: TextSpan(
                                    text: "Vision\n",
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        fontSize: Gparam.textVerySmall,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: state.thisGoal.description,
                                        style: TextStyle(
                                          fontFamily: "Milliard",
                                          height: 1.2,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w300,
                                          fontSize: Gparam.textVerySmall,
                                        ),
                                      )
                                    ]))),
                      ),
                      SizedBox(
                        height: Gparam.heightPadding / 2,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showMotivation = !showMotivation;
                          });
                          print("showMotivation " + showMotivation.toString());
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: (showMotivation) ? 10 : 2,
                              text: TextSpan(
                                text: "Motivation\n",
                                style: TextStyle(
                                    fontFamily: 'Milliard',
                                    fontSize: Gparam.textVerySmall,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: state.thisGoal.vision,
                                      style: TextStyle(
                                        fontFamily: "Milliard",
                                        height: 1.2,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: Gparam.textVerySmall,
                                      )),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                        height: Gparam.heightPadding,
                      ),
                    ],
                  ),
                  Container(
                    height: Gparam.height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          WillPopScope(
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    // your list goes here

                                    // Input content

                                    // Sticker
                                    (isShowSticker
                                        ? buildSticker(state.thisGoal.title)
                                        : Container()),
                                  ],
                                ),
                              ],
                            ),
                            onWillPop: onBackPress,
                          ),
                        ]),
                  )
                ]),
              );
            } else if (state is ImageUploadingState) {
              print("coming ....");
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Gparam.heightPadding,
                    ),
                    Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(Gparam.widthPadding),
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(
                                width: 6,
                              ),
                              RichText(
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(
                                  text: state.image.caption,
                                  style: TextStyle(
                                    fontFamily: 'Milliard',
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Gparam.textVerySmall,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: " Uploading ...",
                                        style: TextStyle(
                                          fontFamily: "Milliard",
                                          height: 1.2,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Gparam.textSmaller,
                                        )),
                                  ],
                                ),
                              )
                            ])),
                    SizedBox(
                      height: Gparam.heightPadding * 2,
                    ),
                    Container(
                        margin: EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: FileImage(File(state.file.path)),
                            height: Gparam.height / 2,
                          ),
                        )),
                    SizedBox(
                      height: Gparam.heightPadding * 2,
                    ),
                    LinearProgressIndicator(
                      minHeight: 10,
                      backgroundColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              );
            }
          })));
    })));
  }

  Widget buildSticker(String goalTitle) {
    return EmojiPicker(
      rows: (Gparam.isHeightBig) ? 6 : 4,
      bgColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(210),
      indicatorColor: Theme.of(context).primaryColor,
      columns: 5,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: [
        "work",
        "book",
        "goal",
        ...goalTitle.toLowerCase().split(" "),
        "laptop",
        "pen"
      ],
      numRecommended: 30,
      onEmojiSelected: (emoji, category) {
        print(emoji);
        setState(() {
          emojiProfile = emoji;
        });
        bloc.add(UpdateGoalEmoji(emoji.emoji));
        onBackPress();
      },
    );
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
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

  void _NewTaskBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddTask(
              newMediaLinkAddressController: _newMediaLinkAddressController,
              deadlineDouble: deadlineToDouble(
                  (bloc.state as GoalPageLoaded).newTask.deadLine),
              onDeadlineChanged: (double value) {
                setState(() {
                  onDeadlineChanged(value);
                });
              },
              onPriorityChanged: (double value) {
                setState(() {
                  onPriorityChanged(value);
                });
              },
              priorityDouble: (bloc.state as GoalPageLoaded).newTask.priority,
              onTitleChanged: (String title) {
                setState(() {
                  bloc.add(UpdateTaskName(title));
                });
              },
              saveTask: () {
                print("save");

                setState(() {
                  //print("save");
                  if ((bloc.state as GoalPageLoaded).newTask.deadLine != null &&
                      (bloc.state as GoalPageLoaded).newTask.title != null &&
                      (bloc.state as GoalPageLoaded).newTask.title != "") {
                    Navigator.pop(context);
                    bloc.add(
                        AddNewTask((bloc.state as GoalPageLoaded).newTask));
                  } else {
                    //Todo: add snack bar to show error in saving
                  }
                });
              },
              valid: validator((bloc.state as GoalPageLoaded).newTask),
              validString:
                  validatorString((bloc.state as GoalPageLoaded).newTask),
              tags: (bloc.state as GoalPageLoaded).tagsToAdd,
              onTagsUpdated: (List<String> tags) {
                bloc.add(UpdateTagsToAdd(tags));
              },
            );
          });
        });
  }

  void _NewAttachmentBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddAttachment(
              newMediaLinkAddressController: _newMediaLinkAddressController,
              deadlineDouble: deadlineToDouble(
                  (bloc.state as GoalPageLoaded).newTask.deadLine),
              priorityDouble: (bloc.state as GoalPageLoaded).newTask.priority,
              onDocumentAdd: () {},
              onImageAdd: () {
                setState(() {
                  print("image add 2");
                  Navigator.pop(context);
                  bloc.add(
                      AddImageAttachment(_newMediaLinkAddressController.text));
                  _newMediaLinkAddressController.clear();
                });
              },
              onLinkAdd: () {
                print("image add 2");
                Navigator.pop(context);
                _NewLinkBottomSheet(context);
              },
            );
          });
        });
  }

  void _NewEventBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddEvent(
                newMediaLinkAddressController: _newMediaLinkAddressController,
                deadlineDouble: deadlineToDouble(
                    (bloc.state as GoalPageLoaded).newEvent.deadLine),
                onDeadlineChanged: (double value) {
                  setState(() {
                    onDeadlineChanged(value);
                  });
                },
                onPriorityChanged: (double value) {
                  setState(() {
                    onPriorityChanged(value);
                  });
                },
                priorityDouble:
                    (bloc.state as GoalPageLoaded).newEvent.priority);
          });
        });
  }

  void _NewLinkBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return AddLink(
              newMediaLinkAddressController: _newMediaLinkAddressController,
            );
          });
        });
  }

  isDeadlineClose(DateTime deadLine) {
    if (deadLine.difference(DateTime.now()).inDays < 5)
      return true;
    else
      return false;
  }

  onDeadlineChanged(double value) {
    DateTime newDt = DateTime.now();
    if (value < .3) {
      int hrs = (value * 24 / 0.3).floor();
      newDt = newDt.add(Duration(hours: hrs));
      bloc.add(UpdateTaskDeadline(newDt));
    } else if (value < .6) {
      int days = ((value - 0.3) * 30 / .3).floor();
      newDt = newDt.add(Duration(days: days));
      bloc.add(UpdateTaskDeadline(newDt));
    } else {
      int days = ((value - 0.6) * 360 / 0.4).floor();
      print(days);
      newDt = newDt.add(Duration(days: days));
      bloc.add(UpdateTaskDeadline(newDt));
    }
  }

  double deadlineToDouble(DateTime deadLine) {
    print("deadlineToDouble");
    if (deadLine == null) deadLine = DateTime.now();
    print(deadLine);
    if (deadLine.difference(DateTime.now()).inHours < 24) {
      return ((deadLine.difference(DateTime.now()).inHours) / 24) * 0.3;
    } else if (deadLine.difference(DateTime.now()).inDays < 30) {
      return 0.3 + ((deadLine.difference(DateTime.now()).inDays) / 30) * 0.3;
    } else {
      return 0.6 + ((deadLine.difference(DateTime.now()).inDays) / 360) * 0.4;
    }
  }

  void onPriorityChanged(double value) {
    bloc.add(UpdateTaskPriority(value));
  }

  int validator(TaskModel newTask) {
    if (newTask.title == null || newTask.title == "") {
      return 1;
    } else if (newTask.deadLine == null) {
      return 2;
    } else
      return 0;
  }

  String validatorString(TaskModel newTask) {
    if (newTask.title == null || newTask.title == "") {
      return "Start by adding a name to your task";
    } else if (newTask.deadLine == null) {
      return "Then add a deadline";
    } else
      return "Mention priority then all done";
  }
}
