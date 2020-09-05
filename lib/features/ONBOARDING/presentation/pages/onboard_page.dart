import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/core/global/widgets/on_success.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/ONBOARDING/presentation/bloc/onboarding_bloc.dart';
import 'package:sorted/features/ONBOARDING/presentation/widgets/body.dart';
import 'package:sorted/features/ONBOARDING/presentation/widgets/bottom_sheet.dart';


class OnboardPage extends StatefulWidget {
  OnboardPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<OnboardPage> with TickerProviderStateMixin {
  OnboardingBloc onboardBloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    onboardBloc = sl<OnboardingBloc>();

    print("Onboard Page");
  }

  BlocProvider<OnboardingBloc> buildBottomSheet(BuildContext context) {
    return BlocProvider(
      create: (_) => onboardBloc,
      child:
              BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  if (state is BottomSheetState) {
                    return ButtomSheet();
                  } else if (state is Error) {
                    print("error");

                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return SizedBox(height: 0);
                  }
                },
              ),
              
            
        
      
    );
  }

  BlocProvider<OnboardingBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => onboardBloc,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              
              // Top half
              BlocConsumer<OnboardingBloc, OnboardingState>(
                // ignore: missing_return
                builder: (context, state) {
                  if (state is StartState || state is BottomSheetState) {
                    return OnboardBody();
                  } else if (state is Error) {
                    print("error restart");

                    return MessageDisplay(
                      message: state.message,
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is SignInCompleted) {
                    return OnSuccessWidget();
                  }
                },
                listener: (BuildContext context, OnboardingState state) {
                  if (state is SignInCompleted) {
                    print("listener ran");
                    
                    Router.navigator.pop();
                    Router.navigator.pushNamed(Router.userIntroPage,
                        arguments: UserIntroPageArguments(title: "User Intro Page"));
                  }
                },
              ),
              SizedBox(height: 20),
              // Bottom half
            ],
          ),
        ),
      ),
    );
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
      backgroundColor: Theme.of(context).primaryColor,

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: buildBody(context),
        ),
      ),
      bottomSheet: buildBottomSheet(context),
        
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
