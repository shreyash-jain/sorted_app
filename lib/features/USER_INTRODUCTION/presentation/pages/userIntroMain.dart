import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/blocs/deeplink_bloc/deeplink_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/on_success.dart';
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/interest_bloc/interest_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/interactionPage.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';
import 'package:auto_route/auto_route.dart';

class UserIntroPage extends StatefulWidget {
  UserIntroPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UserIntroState createState() => _UserIntroState();
}

class _UserIntroState extends State<UserIntroPage>
    with TickerProviderStateMixin {
  UserInterestBloc interestBloc;
  UserIntroductionBloc onboardBloc;
  int professionIndex = -1;
  UserDetail detail = new UserDetail(
      userName: "Shreyash",
      email: "shreyashjain1996@gmail.com",
      imageUrl:
          "https://lh4.googleusercontent.com/-LwsxVl5VUyU/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucnaf5j6cnUTRptD_5a8otpyHMaJKg/s96-c/photo.jpg");

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    onboardBloc = sl<UserIntroductionBloc>();

    print("UserIntroPage");
  }

  BlocProvider<UserIntroductionBloc> buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => onboardBloc..add(GetUserHistoryStatus()),
        child: BlocConsumer<UserIntroductionBloc, UserIntroductionState>(
          buildWhen: (previous, current) => previous.props != current.props,
          // ignore: missing_return

          builder: (context, state) {
            print(state);
            if (state is UserIntroductionInitial)
              return Center(child: LoadingWidget());
            else if (state is UserInteractionState) {
              print("main " + state.progress.toString());
              return InteractionPage(
                oldState: state.oldState,
                userDetail: state.userDetail,
                progress: state.progress,
              );
            } else if (state is LoginState) {
              return LoginPage(
                  userDetail: state.userDetail,
                  allActivities: state.allActivities,
                  userActivities: state.userActivities,
                  valid: state.valid,
                  message: state.message);
            } else if (state is SuccessState) {
              return OnSuccessWidget();
            }
          },
          listener: (BuildContext context, UserIntroductionState state) {
            if (state is SuccessState) {
              context.router.pop();
              context.router.push(
                RootHome(),
              );
              if (sl<DeeplinkBloc>().state is DeeplinkLoaded) {
                context.router.push(ClassListRoute(
                    classId: (sl<DeeplinkBloc>().state as DeeplinkLoaded)
                        .classEnrollData
                        .classId));

                sl<DeeplinkBloc>().add(ResetData());
              }
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,

      body: SingleChildScrollView(
        child: buildBody(context),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
