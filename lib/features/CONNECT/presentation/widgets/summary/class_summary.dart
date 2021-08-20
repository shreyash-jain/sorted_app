import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/CONNECT/presentation/class_summary_bloc/class_summary_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/class_timetable_bloc/class_timetable_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/class_content.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/summary/class_fee.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/summary/class_timetable.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/summary/classroom_preview.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/summary/edit_description.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ClassroomSummary extends StatefulWidget {
  final ClassModel classroom;

  ClassroomSummary({Key key, this.classroom}) : super(key: key);

  @override
  _ClassroomSummaryState createState() => _ClassroomSummaryState();
}

class _ClassroomSummaryState extends State<ClassroomSummary>
    with AutomaticKeepAliveClientMixin<ClassroomSummary> {
  ClassSummaryBloc classSummaryBloc;
  ClassModel _classroom;

  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    _classroom = widget.classroom;
    classSummaryBloc = ClassSummaryBloc(sl())
      ..add(LoadClassSummary(widget.classroom));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => classSummaryBloc,
      child: Container(
        child: SingleChildScrollView(
          child: BlocListener<ClassSummaryBloc, ClassSummaryState>(
            listener: (context, state) {
              if (state is ClassSummaryLoaded) {
                setState(() {
                  _classroom = state.classroom;
                });
              }
            },
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                BlocBuilder<ClassSummaryBloc, ClassSummaryState>(
                  builder: (context, state) {
                    if (state is ClassSummaryLoaded)
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Gtheme.stext("Classroom Preview",
                                      size: GFontSize.S,
                                      weight: GFontWeight.B1),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            ClassroomPreview(
                                coverImageUrl: _classroom.coverUrl,
                                topics: state.topics),
                            SizedBox(
                              height: 10,
                            ),
                           ExpansionTile(
                              iconColor: Theme.of(context).primaryColor,
                              title: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding / 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Gtheme.stext("Time Table",
                                        size: GFontSize.S,
                                        weight: GFontWeight.B1),
                                  ],
                                ),
                              ),
                              children: <Widget>[
                                BlocProvider(
                                  create: (context) =>
                                      ClassTimetableBloc(classSummaryBloc, sl())
                                        ..add(GetTimetable(_classroom)),
                                  child: BlocBuilder<ClassTimetableBloc,
                                      ClassTimetableState>(
                                    builder: (context, state) {
                                      if (state is TimetableLoaded)
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Gparam.widthPadding / 2),
                                          child: ClassTimeTableWidget(
                                              days: state.days,
                                              classModel: _classroom),
                                        );
                                      else {
                                        return Container(height: 0);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              iconColor: Theme.of(context).primaryColor,
                              title: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding / 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Gtheme.stext("Fee",
                                        size: GFontSize.S,
                                        weight: GFontWeight.B1),
                                  ],
                                ),
                              ),
                              children: <Widget>[],
                            ),
                            ExpansionTile(
                              iconColor: Theme.of(context).primaryColor,
                              title: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding / 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Gtheme.stext("About Classroom",
                                        size: GFontSize.S,
                                        weight: GFontWeight.B1),
                                  ],
                                ),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Gparam.widthPadding / 2),
                                  child: ClassDescription(
                                    classroom: state.classroom,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  height: 50,
                                  elevation: 0,
                                  minWidth: Gparam.width - Gparam.widthPadding,
                                  onPressed: () {
                                    _joinMeeting(
                                        _classroom.id,
                                        state.classroom,
                                        CacheDataClass.cacheData
                                            .getUserDetail());
                                  },
                                  color: Colors.grey.shade200,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.live_tv,
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Gtheme.stext("Join Class",
                                          weight: GFontWeight.B1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      );
                    else if (state is ClassSummaryInitial)
                      return Container(height: 0);
                    else
                      return Container(height: 0);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _joinMeeting(String meetingid, ClassModel classroom, UserDetail user) async {
    // todo: make cloud function for jwt token
    try {
      Map<FeatureFlagEnum, bool> featureMap = {
        FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
        FeatureFlagEnum.CALENDAR_ENABLED: false,
        FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,
        FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: false,
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        FeatureFlagEnum.IOS_RECORDING_ENABLED: false,
        FeatureFlagEnum.INVITE_ENABLED: false,
        FeatureFlagEnum.RECORDING_ENABLED: false,
        FeatureFlagEnum.PIP_ENABLED: true,
        FeatureFlagEnum.MEETING_PASSWORD_ENABLED: false
      };

      var options = JitsiMeetingOptions(room: meetingid)
        ..serverURL = "https://meet.getsortit.com"
        ..userDisplayName = _classroom.coachName
        ..featureFlags = featureMap
        // ..token = JwtGenerator.getTrainerJwt(classroom, user)
        ..subject = _classroom.name;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  @override
  bool get wantKeepAlive => true;
}
