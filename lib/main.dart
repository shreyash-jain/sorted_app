

import 'package:notes/components/faderoute.dart';
import 'package:notes/data/activity.dart';
import 'package:notes/data/eCat.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/user_activity.dart';
import 'package:notes/screens/onboard.dart';
import 'package:notes/screens/introduction.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/todo_screen.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/auth.dart';
import 'package:notes/services/database.dart';
import 'package:notes/services/service_locator.dart';
import 'package:notes/services/sharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'data/theme.dart';
import 'services/local_notications_helper.dart';
SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  bool biometric = prefs.getBool('biometric');
  if (biometric==null) biometric=false;
  setupLocator();
  runApp(new MyApp(biometric));
}

class MyApp extends StatefulWidget {
  final bool check_biometric;
  // This widget is the root of your application.
  MyApp(this.check_biometric);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = appThemeLight;
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  int inlet=0;

  bool isLoading=true;
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
    _getAvailableBiometrics();
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  /*void _cancelAuthentication() {
    auth.stopAuthentication();
  }*/
  bool firstTime;
  int prefSignIn;


  @override
  void initState() {
    super.initState();
    updateThemeFromSharedPref();
    startTime();
    getStarted();



  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stay Sorted',
      theme: theme,
      home:_getStartupScreen(),
    );
  }
  Widget _getStartupScreen() {



    if((!widget.check_biometric && (firstTime != null && !firstTime))||(widget.check_biometric && _authorized=='Authorized' && (firstTime != null && !firstTime))) {
     print("streamed");
     inlet=1;


      return
      StreamBuilder(
          stream: authService.user,
          builder: (context, snapshot) {
            print("streamed 0.0 $inlet");
            getStarted();
            if (snapshot.hasData) {


              print("streamed 1.0");

              final Firestore _db = Firestore.instance;
              DocumentReference ref = _db.collection('users').document(snapshot.data.uid).collection("user_data").document("data");

              ref.updateData({'lastSeen':DateTime.now()});




              inlet=0;
              isLoading=false;
              return MyHomePage(title: 'Home',changeTheme: setTheme);
            }
            else if (firstTime==null ) {
              print("streamed 2.0");
              return Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body:Stack(children: <Widget>[

                  Align(
                      alignment: Alignment.topCenter,
                      child:Padding(
                        padding: EdgeInsets.all(80),
                        child:Text("Stay Sorted",style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 36.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,


                        )),
                      )
                  ),

                  Align(
                      alignment: Alignment.bottomCenter,
                      child:Padding(
                        padding: EdgeInsets.all(80),
                        child:RaisedButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  OnboardingScreen()),

                            );
                          },
                          child: const Text('Get Started', style: TextStyle(fontSize: 20)),
                        ),
                      )
                  ),

                ],)


              );



             }

            else {
              print("streamed 3.0");
              return Scaffold(
                backgroundColor: Color.fromRGBO(0,153,204, 1),
                body: Container(
                  child: Center(

                  ),
                )
              );
            }
          });
    }

    else if (firstTime==null) return OnboardingScreen();
    else {
      print("streamed 4.0");
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading...",
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: 'ZillaSlab',
                        fontWeight: FontWeight.w700))
              ],
            ),
          ),
        )
      );
    }
  }
  setTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
    } else {
      setState(() {
        theme = appThemeLight;
      });
    }
  }
  startTime() async {

    if (widget.check_biometric==true){
      _checkBiometrics();
    }
    bool firstmain = prefs.getBool('first_main');




    if ((firstmain != null )) {


    }
    //
    else {
      prefs.setBool('biometric',false);
      prefs.setBool('first_main', false);



    }
  }
  getStarted() async {

    prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool('onboard');
    prefSignIn=prefs.getInt('signInId');




    }



  void updateThemeFromSharedPref() async {
    String themeText = await getThemeFromSharedPref();
    if (themeText == 'light') {
      setTheme(Brightness.light);
    } else {
      setTheme(Brightness.dark);
    }
  }
}
/*
class HomeScreen extends StatelessWidget {
  final bool firstTime;
  final String _authorized;

  HomeScreen(this.firstTime, this._authorized );
  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                RaisedButton(
                  child: const Text('Check biometrics'),
                  onPressed:() async {

                  if (_authorized=='Authorized' && (firstTime != null && !firstTime)){

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                         ),





                  }

                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                         ),

                    );

                  }

                  },
                ),


              ])),
    )
 ; }

}*/
