import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/widgets/enrolled_client_tile.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/widgets/requested_client_tile.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
import 'package:sorted/features/HOME/presentation/client_enroll_bloc/enroll_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/planner/home_planner.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/home_classroom_tile.dart';

class ClientEnrollHomeWidget extends StatefulWidget {
  ClientEnrollHomeWidget({Key key}) : super(key: key);

  @override
  _ClientEnrollHomeWidgetState createState() => _ClientEnrollHomeWidgetState();
}

class _ClientEnrollHomeWidgetState extends State<ClientEnrollHomeWidget> {
  ClientEnrollBloc clientEnrollBloc;
  @override
  void initState() {
    super.initState();
    clientEnrollBloc = ClientEnrollBloc(sl());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => clientEnrollBloc..add(GetClientEnrolls()),
      child: BlocBuilder<ClientEnrollBloc, ClientEnrollState>(
        builder: (context, state) {
          if (state is ClientEnrollLoaded)
            return Column(
              children: [
                if (state.requestedClasses.length +
                        state.enrolledClasses.length >
                    0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeDayActivityTile(
                        assetPath: 'assets/images/classroom.png',
                        title: "My Fitness Classes",
                        subTitle: "30-40 min",
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      if (state.requestedClasses.length > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding),
                          child: Gtheme.stext("Requested Class",
                              size: GFontSize.S, weight: GFontWeight.N),
                        ),
                      if (state.requestedClasses.length > 0)
                        SizedBox(
                          height: 8,
                        ),
                      ...state.requestedClasses
                          .asMap()
                          .entries
                          .map((e) => Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Gparam.widthPadding,
                                      vertical: 12),
                                  child: HomeClassRoomTile(
                                    classroom: e.value,
                                  ),
                                ),
                              )),
                      SizedBox(
                        height: 8,
                      ),
                      if (state.enrolledClasses.length > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding),
                          child: Gtheme.stext("Enrolled Class",
                              size: GFontSize.S, weight: GFontWeight.N),
                        ),
                      if (state.enrolledClasses.length > 0)
                        SizedBox(
                          height: 8,
                        ),
                      ...state.enrolledClasses
                          .asMap()
                          .entries
                          .map((e) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding,
                                    vertical: 12),
                                child: InkWell(
                                  onTap: () {
                                    context.router.push(
                                        ClassroomMain(classroom: e.value));
                                  },
                                  child: HomeClassRoomTile(
                                    classroom: e.value,
                                  ),
                                ),
                              ))
                    ],
                  ),
                if (state.enrolledConsultations.length +
                        state.requestedConsultations.length >
                    0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeDayActivityTile(
                        assetPath: 'assets/images/consultation.png',
                        title: "My Fitness Consultations",
                        subTitle: "",
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      if (state.requestedConsultations.length > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding),
                          child: Gtheme.stext("Requested Consultations",
                              size: GFontSize.S, weight: GFontWeight.N),
                        ),
                      if (state.requestedClasses.length > 0)
                        SizedBox(
                          height: 8,
                        ),
                      ...state.requestedConsultations
                          .asMap()
                          .entries
                          .map((e) => Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Gparam.widthPadding,
                                      vertical: 12),
                                  child: ConsultationRequestedClientTile(
                                      consultation: e.value,
                                      onClickClient: (c) {}),
                                ),
                              )),
                      SizedBox(
                        height: 8,
                      ),
                      if (state.enrolledConsultations.length > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding),
                          child: Gtheme.stext("Enrolled Consultations",
                              size: GFontSize.S, weight: GFontWeight.N),
                        ),
                      if (state.enrolledConsultations.length > 0)
                        SizedBox(
                          height: 8,
                        ),
                      ...state.enrolledConsultations
                          .asMap()
                          .entries
                          .map((e) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Gparam.widthPadding,
                                    vertical: 12),
                                child: InkWell(
                                  onTap: () {
                                     context.router.push(
                                    ConsultationMain(consultation: e.value));
                                  },
                                  child: ConsultationEnrolledClientTile(
                                      consultation: e.value,
                                      onClickClient: (c) {
                                        context.router.push(ConsultationMain(
                                        consultation: e.value));
                                      }),
                                ),
                              ))
                    ],
                  ),
              ],
            );
          else if (state is ClientEnrollInitial)
            return ImagePlaceholderWidget();
          else if (state is ClientEnrollError)
            return Container(
              height: 0,
            );
          else
            return Container(
              height: 0,
            );
        },
      ),
    );
  }
}
