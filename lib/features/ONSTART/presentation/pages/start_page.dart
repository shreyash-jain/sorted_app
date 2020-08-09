import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/ONSTART/data/datasources/onstart_cloud_data_source.dart';
import 'package:sorted/features/ONSTART/presentation/bloc/onstart_bloc.dart';
import 'package:sorted/features/ONSTART/presentation/widgets/background.dart';
import 'package:sorted/features/ONSTART/presentation/widgets/loading_widget.dart';
import 'package:sorted/features/ONSTART/presentation/widgets/message_display.dart';
import 'package:sorted/features/ONSTART/presentation/widgets/re_authenticate.dart';

class MyStartPage extends StatefulWidget {
 

  MyStartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyStartPage> {
  OnstartBloc onStartBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    onStartBloc = sl<OnstartBloc>();
    onStartBloc.add(GetLocalAuthDone());
    print("Start Page");
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
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  BlocProvider<OnstartBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => onStartBloc,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocConsumer<OnstartBloc, OnstartState>(
                builder: (context, state) {
                  if (state is InitState) {
                    return MessageDisplay(
                      message: 'Init State !',
                    );
                  } else if (state is Loading) {
                    return Background();
                  } else if (state is AccessDenied) {
                    return ReAuthenticate();
                  } else if (state is Error) {
                     BlocProvider.of<OnstartBloc>(context).add(GetLocalAuthDone());
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                },
                listener: (BuildContext context, OnstartState state) {
                  if (state is AccessGranted) {
                    _scaffoldKey.currentState.showSnackBar(
                        new SnackBar(content: new Text("Go to next page ...")));
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
}
