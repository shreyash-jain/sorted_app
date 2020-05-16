

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
      return
      StreamBuilder(
          stream: authService.user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final Firestore _db = Firestore.instance;
              DocumentReference ref = _db.collection('users').document(snapshot.data.uid).collection("user_data").document("data");


               ref.setData({

                'lastSeen': DateTime.now()
              }, merge: true);
              return MyHomePage(title: 'Home',changeTheme: setTheme);
            }else if (firstTime==null || snapshot.hasData==false) return OnboardingScreen();
            else {
              return Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: Align(
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
              );
            }
          });
    }

    else if (firstTime==null) return OnboardingScreen();
    else {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Align(
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
      firstmain = prefs.getBool('first_main');
      var notebooks=await NotesDatabaseService.db.getNotebookFromDB();
      List<NoteBookModel> check=notebooks;

      if (!firstmain && check.length==0){


        prefs.setBool('first_main', true);
        NoteBookModel quicknote = new NoteBookModel(title: "Quick Notes",
            notes_num: 0,
            isImportant: true,
            date: DateTime.now());
        await NotesDatabaseService.db.addNoteBookInDB(quicknote);

        CatModel newcat= new CatModel(name: "Food/Drink",image:"Icons.restaurant",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Bills",image:"Icons.receipt",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Entertainment",image:"Icons.movie_filter",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Health",image:"Icons.healing",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Transport",image:"Icons.directions_bus",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Fuel",image:"Icons.ev_station",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "ATM",image:"Icons.local_atm",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Investment",image:"Icons.trending_up",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Rent",image:"Icons.home",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Education",image:"Icons.library_books",total: 0);
        await NotesDatabaseService.db.addCat(newcat);
        newcat= new CatModel(name: "Other",image:"Icons.scatter_plot",total: 0);
        await NotesDatabaseService.db.addCat(newcat);

        QuestionModel newQuestion = new QuestionModel(title: "How was my day ?",
            type: 0,
            interval: 1,
            priority: 5,
            archive: 0,
            weight: .5,
            correct_ans: 0,
            num_ans: 0,
            ans1: "",
            ans2: "",
            last_date: DateTime.now(),
            ans3: "");

        newQuestion.archive=0;
        newQuestion.priority=5;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);

        newQuestion.priority=4;
        newQuestion.title = "How was my work ?";

        newQuestion.weight=.2;
        newQuestion.archive=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Something Interesting happended today ?";
        newQuestion.weight=0.3;
        newQuestion.archive=0;
        newQuestion.priority=5;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Any Plans for tomorrow ?";
        newQuestion.priority=4;
        newQuestion.weight=0.3;
        newQuestion.archive=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "How about today's finances ?";
        newQuestion.archive=0;
        newQuestion.weight=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Today's Activities";
        newQuestion.archive=0;
        newQuestion.priority=3;
        newQuestion.weight=.4;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "How was my school/college ?";
        newQuestion.weight=.2;
        newQuestion.archive=1;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Anything I learned today ?";
        newQuestion.weight=0;
        newQuestion.archive=1;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Describe your meditation experience ?";
        newQuestion.archive=1;
        newQuestion.weight=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Did I buy something new today ?";
        newQuestion.weight=0;
        newQuestion.archive=1;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);


        newQuestion.title = "How many hours I studied ?";
        newQuestion.type = 2;
        newQuestion.weight=.2;
        newQuestion.archive=1;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "How many hours I wasted ?";
        newQuestion.type = 2;
        newQuestion.weight=-0.2;
        newQuestion.archive=1;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "How many hours I used social media ?";
        newQuestion.type = 2;
        newQuestion.archive=0;
        newQuestion.priority=2;

        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "How many hours I slept today ?";
        newQuestion.type = 2;
        newQuestion.archive=0;
        newQuestion.weight=-0.1;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "How many Liters of water I drink ?";
        newQuestion.type = 2;
        newQuestion.archive=1;
        newQuestion.weight=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "How much time did I spend in meditating ?";
        newQuestion.type = 2;
        newQuestion.archive=1;
        newQuestion.weight=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Did I had some Helath issues last week ?";
        newQuestion.type = 2;
        newQuestion.archive=1;
        newQuestion.weight=0;
        newQuestion.priority=1;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Satisfied by my today's work ?";
        newQuestion.type = 1;
        newQuestion.num_ans = 3;
        newQuestion.weight=.2;
        newQuestion.ans1 = "Yes";
        newQuestion.ans2 = "No";
        newQuestion.ans3 = "May be";
        newQuestion.archive=1;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Did i excercised today ?";
        newQuestion.type = 1;
        newQuestion.num_ans = 3;
        newQuestion.ans1 = "Yes";
        newQuestion.ans2 = "No";
        newQuestion.ans3 = "May be";
        newQuestion.archive=1;
        newQuestion.weight=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Did you meditate today ?";
        newQuestion.type = 1;
        newQuestion.num_ans = 3;
        newQuestion.ans1 = "Yes";
        newQuestion.ans2 = "No";
        newQuestion.ans3 = "May be";
        newQuestion.archive=1;
        newQuestion.weight=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Had my meals on time ?";
        newQuestion.type = 1;
        newQuestion.num_ans = 3;
        newQuestion.ans1 = "Yes";
        newQuestion.ans2 = "No";
        newQuestion.ans3 = "May be";
        newQuestion.archive=1;
        newQuestion.weight=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);
        newQuestion.title = "Followed my skin regimen today ?";
        newQuestion.type = 1;
        newQuestion.num_ans = 3;
        newQuestion.ans1 = "Yes";
        newQuestion.ans2 = "No";
        newQuestion.ans3 = "May be";
        newQuestion.archive=1;
        newQuestion.weight=0;
        await NotesDatabaseService.db.addQuestionInDB(newQuestion);

        ActivityModel basic_act= new ActivityModel(name:"Work",image:"work",weight:10);
        var updated= await NotesDatabaseService.db.addActivity(basic_act);
        basic_act=updated;
        UserAModel basic_user_act= new UserAModel(name:"Work",image:"work",a_id:basic_act.id);
        await NotesDatabaseService.db.addUserActivity(basic_user_act);
        basic_act= new ActivityModel(name:"Family",image:"family",weight:10);
        updated= await NotesDatabaseService.db.addActivity(basic_act);
        basic_act=updated;
        basic_user_act= new UserAModel(name:"Family",image:"family",a_id:basic_act.id);
        await NotesDatabaseService.db.addUserActivity(basic_user_act);
        basic_act= new ActivityModel(name:"Relation",image:"relationship",weight:10);
        updated= await NotesDatabaseService.db.addActivity(basic_act);
        basic_act=updated;
        basic_user_act= new UserAModel(name:"Relation",image:"relationship",a_id:basic_act.id);
        await NotesDatabaseService.db.addUserActivity(basic_user_act);
        basic_act= new ActivityModel(name:"Studies",image:"education",weight:10);
        updated= await NotesDatabaseService.db.addActivity(basic_act);
        basic_act=updated;
        basic_user_act= new UserAModel(name:"Studies",image:"education",a_id:basic_act.id);
        await NotesDatabaseService.db.addUserActivity(basic_user_act);
        basic_act= new ActivityModel(name:"Friends",image:"friends",weight:10);
        updated= await NotesDatabaseService.db.addActivity(basic_act);
        basic_act=updated;
        basic_user_act= new UserAModel(name:"Friends",image:"friends",a_id:basic_act.id);
        await NotesDatabaseService.db.addUserActivity(basic_user_act);
        basic_act= new ActivityModel(name:"Exercise",image:"exercise",weight:10);
        updated= await NotesDatabaseService.db.addActivity(basic_act);
        basic_act=updated;
        basic_user_act= new UserAModel(name:"Exercise",image:"exercise",a_id:basic_act.id);
        await NotesDatabaseService.db.addUserActivity(basic_user_act);
        basic_act= new ActivityModel(name:"Music",image:"music",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Sports",image:"sports",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Meditation",image:"meditation",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Arts",image:"arts",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"PC Games",image:"games",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Movies",image:"movies",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Coding",image:"coding",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"TV Series",image:"tv_series",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Reading",image:"reading",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Writing",image:"writing",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Cooking",image:"cooking",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);
        basic_act= new ActivityModel(name:"Travel",image:"travel",weight:2);
        await NotesDatabaseService.db.addActivity(basic_act);


      }


    }
  }
  getStarted() async {

    prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool('onboard');



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
