import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/data/datasources/diet_preferences_db.dart';
import 'package:sorted/features/CONNECT/data/datasources/fitness_goals_db.dart';
import 'package:sorted/features/CONNECT/data/datasources/health_conditions_db.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_profile.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/widgets/client_general_info.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/widgets/client_preview.dart';
import 'package:sorted/features/CONNECT/presentation/consultation_summary_bloc/consultation_summary_bloc.dart';

class ConsultationSummary extends StatefulWidget {
  final ClientConsultationModel consultation;
  ConsultationSummary({Key key, this.consultation}) : super(key: key);

  @override
  _ConsultationSummaryState createState() => _ConsultationSummaryState();
}

class _ConsultationSummaryState extends State<ConsultationSummary> {
  ConsultationSummaryBloc consultationSummaryBloc;

  @override
  void initState() {
    consultationSummaryBloc = ConsultationSummaryBloc()
      ..add(LoadClientSummary(widget.consultation));
    super.initState();
  }

  onClickInvite() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => consultationSummaryBloc,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 6,
              ),
              BlocBuilder<ConsultationSummaryBloc, ConsultationSummaryState>(
                builder: (context, state) {
                  if (state is ConsultationSummaryLoaded)
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            child: ClientPreview(
                              consultation: state.consultation,
                            ),
                          ),
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
                                  Gtheme.stext("Fee",
                                      size: GFontSize.S,
                                      weight: GFontWeight.B1),
                                  Spacer(),
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(Gparam.widthPadding / 2),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.all(10),
                                child: Gtheme.stext("Request Payment"),
                              )
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
                                  Gtheme.stext("Health Conditions",
                                      size: GFontSize.S,
                                      weight: GFontWeight.B1),
                                  Spacer(),
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            children: <Widget>[
                              if (widget.consultation.healthConditions.length >
                                  0)
                                Container(
                                    height: 36,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          SizedBox(
                                            width: Gparam.widthPadding,
                                          ),
                                          ...getConditionStringsFromKey((widget
                                                  .consultation.healthConditions
                                                  .split(',')
                                                  .map((e) => int.parse(e))
                                                  .toList()))
                                              .asMap()
                                              .entries
                                              .map((e) => buttonTile(e.value))
                                        ])),
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
                                  Gtheme.stext("Fitness Goal",
                                      size: GFontSize.S,
                                      weight: GFontWeight.B1),
                                  Spacer(),
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            children: <Widget>[
                              if (widget.consultation.fitnessGoals.length > 0)
                                Container(
                                    height: 36,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          SizedBox(
                                            width: Gparam.widthPadding,
                                          ),
                                          ...getFitnessStringsFromKey((widget
                                                  .consultation.fitnessGoals
                                                  .split(',')
                                                  .map((e) => int.parse(e))
                                                  .toList()))
                                              .asMap()
                                              .entries
                                              .map((e) => buttonTile(e.value))
                                        ])),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                        ExpansionTile(
                            iconColor: Theme.of(context).primaryColor,
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding / 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Gtheme.stext("Diet Preference",
                                      size: GFontSize.S,
                                      weight: GFontWeight.B1),
                                  Spacer(),
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            children: <Widget>[
                              if (widget.consultation.dietPreference.length > 0)
                                Container(
                                    height: 36,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          SizedBox(
                                            width: Gparam.widthPadding,
                                          ),
                                          ...getPreferencesStringsFromKey(
                                                  (widget.consultation
                                                      .dietPreference
                                                      .split(',')
                                                      .map((e) => int.parse(e))
                                                      .toList()))
                                              .asMap()
                                              .entries
                                              .map((e) => buttonTile(e.value))
                                        ])),
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
                                    widget.consultation.id,
                                    state.consultation,
                                  );
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
                                    Gtheme.stext("Connect with client",
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
                  if (state is ConsultationSummaryInitial)
                    return Container(height: 0);
                  else
                    return Container(
                      height: 0,
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _joinMeeting(String meetingid, ClientConsultationModel consultation) async {
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
        ..userDisplayName = consultation.name
        ..featureFlags = featureMap
        ..subject = consultation.packageName;

      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceJoined: (message) {
          debugPrint("${options.room} joined with message: $message");
        }),
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  Widget buttonTile(
    String s,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black.withOpacity(.06), width: 1),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: Colors.black.withAlpha(2),
                blurRadius: 2)
          ],
          borderRadius: new BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Text(
          s,
          style: TextStyle(
              fontFamily: 'Milliard',
              fontSize: Gparam.textSmaller,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.8)),
        ),
      ),
    );
  }
}
