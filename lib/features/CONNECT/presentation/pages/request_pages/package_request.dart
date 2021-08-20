import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';

import 'package:sorted/features/CONNECT/presentation/package_enroll_bloc/package_enroll_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/package_tile.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/trainer_widget.dart';
import 'package:auto_route/auto_route.dart';

class ExpertPackageRequestPage extends StatefulWidget {
  final String packageId;
  ExpertPackageRequestPage({Key key, this.packageId}) : super(key: key);

  @override
  _ExpertPackageRequestPageState createState() =>
      _ExpertPackageRequestPageState();
}

class _ExpertPackageRequestPageState extends State<ExpertPackageRequestPage> {
  PackageEnrollBloc packageEnrollBloc;

  @override
  void initState() {
    super.initState();
    packageEnrollBloc = PackageEnrollBloc(sl())
      ..add(GetExpertDetails(widget.packageId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => packageEnrollBloc,
        child: BlocBuilder<PackageEnrollBloc, PackageEnrollState>(
          builder: (context, state) {
            if (state is PackageEnrollLoaded)
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
                        Row(
                          children: [
                            SizedBox(width: Gparam.widthPadding),
                            PackageTileWidget(
                                package: state.package,
                                isLoading: state.isLoading,
                                onEnrollClick: (p) {
                                  context.router.push(ClientRequestForm(
                                      calendarModel: state.calendarModel,
                                      packageType: state.package.type,
                                      onPressEnroll: (fitnessGoals,
                                          dietPreferences,
                                          healthConditions,
                                          startDate,
                                          details,
                                          preferedSlot) {
                                        ClientConsultationModel
                                            newConsultation =
                                            ClientConsultationModel(
                                                fitnessGoals:
                                                    fitnessGoals.join(','),
                                                dietPreference:
                                                    dietPreferences.join(','),
                                                     prefferedSlot: preferedSlot,
                                                healthConditions:
                                                    healthConditions.join(','),
                                                initialClientMessage: details);
                                        print(
                                            "shreyash $fitnessGoals $dietPreferences $healthConditions $startDate $preferedSlot $details");
                                        packageEnrollBloc.add(
                                            EnrollRequestEvent(
                                                p, newConsultation, startDate));
                                      }));
                                },
                                state: state.userEnrollState),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                     
                      ],
                    ),
                  ),
                ),
              );
            else if (state is PackageEnrollInitial) {
              return Center(child: Container(child: LoadingWidget()));
            } else if (state is PackageEnrollError) {
              return Center(
                  child: Container(child: Gtheme.stext(state.message)));
            } else
              return Container(height: 0);
          },
        ),
      ),
    );
  }
}
