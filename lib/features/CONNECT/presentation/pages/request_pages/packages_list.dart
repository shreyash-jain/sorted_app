import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/presentation/consultation_enroll_bloc/consultation_enroll_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/package_tile.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/trainer_widget.dart';
import 'package:auto_route/auto_route.dart';

class ExpertPackagesCatalogue extends StatefulWidget {
  final String expertId;
  ExpertPackagesCatalogue({Key key, this.expertId}) : super(key: key);

  @override
  _ExpertPackagesCatalogueState createState() =>
      _ExpertPackagesCatalogueState();
}

class _ExpertPackagesCatalogueState extends State<ExpertPackagesCatalogue> {
  ConsultationEnrollBloc consultationEnrollBloc;

  @override
  void initState() {
    super.initState();
    consultationEnrollBloc = ConsultationEnrollBloc(sl())
      ..add(GetExpertDetails(widget.expertId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => consultationEnrollBloc,
        child: BlocBuilder<ConsultationEnrollBloc, ConsultationEnrollState>(
          builder: (context, state) {
            if (state is ConsultationEnrollLoaded)
              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.isLoading) LinearProgressIndicator(),
                        SizedBox(
                          height: Gparam.heightPadding,
                        ),
                        ExpertProfileWidget(profile: state.expertProfile),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Gtheme.stext("Packages",
                                  size: GFontSize.S, weight: GFontWeight.B1),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                            height: 400,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(width: Gparam.widthPadding),
                                ...state.packages.asMap().entries.map(
                                      (e) => PackageTileWidget(
                                          package: e.value,
                                          isLoading: state.isLoading,
                                          onEnrollClick: (p) {
                                            context.router.push(
                                                ClientRequestForm(
                                                    calendarModel:
                                                        state.calendarModel,
                                                    packageType: p.type,
                                                    onPressEnroll:
                                                        (fitnessGoals,
                                                            dietPreferences,
                                                            healthConditions,
                                                            startDate,
                                                            details,
                                                            preferedSlot) {
                                                      ClientConsultationModel
                                                          newConsultation =
                                                          ClientConsultationModel(
                                                              fitnessGoals:
                                                                  fitnessGoals
                                                                      .join(
                                                                          ','),
                                                              dietPreference:
                                                                  dietPreferences
                                                                      .join(
                                                                          ','),
                                                              healthConditions:
                                                                  healthConditions
                                                                      .join(
                                                                          ','),
                                                                          prefferedSlot: preferedSlot,
                                                              initialClientMessage:
                                                                  details);


                                                      consultationEnrollBloc.add(
                                                          EnrollRequestEvent(
                                                              p,
                                                              newConsultation,
                                                              startDate));
                                                      print(
                                                          "shre1 $fitnessGoals $dietPreferences $healthConditions $startDate $preferedSlot $details");
                                                    }));
                                          },
                                          state: state.userEnrollState[e.key]),
                                    ),
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        ExpansionTile(
                          title: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding / 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Gtheme.stext("About Trainer",
                                    size: GFontSize.S, weight: GFontWeight.B1),
                              ],
                            ),
                          ),
                          children: <Widget>[],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            else if (state is ConsultationEnrollInitial) {
              return Center(child: Container(child: LoadingWidget()));
            } else if (state is ConsultationEnrollError) {
              return Center(
                  child: Container(child: Gtheme.stext(state.message)));
            } else
              return Container(height: 0);
          },
        ),
      ),
    );
  }

  String getStringFromPackageType(int type) {
    switch (type) {
      case 0:
        return "1 time";
      case 1:
        return "1 Week";
      case 2:
        return "1 Month";
      case 3:
        return "3 Months";

        break;
      default:
    }
  }
}
