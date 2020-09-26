import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:health/health.dart';

import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/shared_pref_helper.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/theme/app_theme_wrapper.dart';
import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/main.dart';

class SettingsPage extends StatefulWidget {
  
  SettingsPage({Key key, Function(Brightness brightness) changeTheme})
      : super(key: key) {
   
  }
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme;
  SharedPreferences prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FocusNode BudgetFocus = FocusNode();
  TextEditingController BudgetTitle = TextEditingController();
  int selected_currency = 1;
  int selected_unfilled = 1;
  int edit = 0;
  String g_name = "Shreyash", g_email = "shreyash.jain.eee15@itbhu.ac.in";
  String budget = "10000";
  var biometricSwitched = false;
  var themeSwitched = false; // false for white
  String currency = "₹";
  var _budgetController;
  int min = 15;

  String mins = "15 mins";

  bool isGfit = false;

  initiatePref() async {
    prefs = await SharedPreferences.getInstance();
    if (Theme.of(context).brightness == Brightness.dark) {
      themeSwitched = true;
    } else {
      themeSwitched = false;
    }
    bool biometric = prefs.getBool('biometric');
    if (prefs.getString('google_name') != null)
      g_name = prefs.getString('google_name');
    if (prefs.getString('google_email') != null)
      g_email = prefs.getString('google_email');
    if (biometric == null || biometric == false)
      setState(() {
        biometricSwitched = false;
      });
    else
      setState(() {
        biometricSwitched = true;
      });
    int survey_length = prefs.getInt('survey_length');

    if (survey_length == null || survey_length == false)
      setState(() {
        min = 15;
      });
    selected_unfilled = prefs.getInt('unfilled');

    if (selected_unfilled == null)
      setState(() {
        selected_unfilled = 1;
      });
    else
      setState(() {
        min = survey_length;
        mins = "$survey_length mins";
      });
    currency = prefs.getString('currency');

    if (currency == null || currency == false)
      setState(() {
        currency = "₹";
      });
    else
      setState(() {
        if (currency == "£")
          selected_currency = 4;
        else if (currency == "€")
          selected_currency = 3;
        else if (currency == "\$")
          selected_currency = 2;
        else
          selected_currency = 1;
      });
  }

  @override
  void initState() {
    initiatePref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: Gparam.heightPadding / 2),
                child: buildHeaderWidget(context),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Gparam.widthPadding,
                    top: Gparam.heightPadding*2,
                    bottom: Gparam.heightPadding,
                    right: Gparam.widthPadding),
                child: Text('General Settings',
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              buildCardWidget(Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
                        gradient: new LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              (Theme.of(context).brightness == Brightness.dark)
              ?Theme.of(context).backgroundColor:Theme.of(context).primaryColorLight,
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            stops: [.2, .8],
                            tileMode: TileMode.repeated),
                      ),
                      child: Icon(OMIcons.formatPaint)),
                  SizedBox(
                    width: Gparam.widthPadding / 2,
                  ),
                  Text('Dark Mode',
                      style: TextStyle(
                          fontFamily: 'Eastman',
                          fontSize: 16,
                          color: Theme.of(context).primaryColor)),

                  Spacer(),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 60,
                        child: Switch(
                          value: themeSwitched,
                          onChanged: (value) {
                            setState(() {
                              themeSwitched = value;

                              handleThemeSelection(themeSwitched);
                            });
                          },
                          activeTrackColor: Colors.white38,
                          activeColor: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              buildCardWidget(Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
                        gradient: new LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              (Theme.of(context).brightness == Brightness.dark)
              ?Theme.of(context).backgroundColor:Theme.of(context).primaryColorLight,
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            stops: [.2, .8],
                            tileMode: TileMode.repeated),
                      ),
                      child: Icon((biometricSwitched)?OMIcons.lock:OMIcons.lockOpen)),
                  SizedBox(
                    width: Gparam.widthPadding / 2,
                  ),
                  Text('Biometric Lock',
                      style: TextStyle(
                          fontFamily: 'Eastman',
                          fontSize: 16,
                          color: Theme.of(context).primaryColor)),

                  Spacer(),
                  Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          child: Switch(
                            value: biometricSwitched,
                            onChanged: (value) {
                              setState(() {
                                biometricSwitched = value;

                                if (biometricSwitched)
                                  prefs.setBool('biometric', true);
                                else
                                  prefs.setBool('biometric', false);
                              });
                            },
                            activeColor: Theme.of(context).backgroundColor,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          ),
                        ),
                      ],
                    )

                
                ],
              )),
               Padding(
                padding: EdgeInsets.only(
                    left: Gparam.widthPadding,
                    top: Gparam.heightPadding*2,
                    bottom: Gparam.heightPadding,
                    right: Gparam.widthPadding),
                child: Text('Account Settings',
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              buildCardWidget(
                
                Column(
                  children: [
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30.0)),
                            gradient: new LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  (Theme.of(context).brightness == Brightness.dark)
              ?Theme.of(context).backgroundColor:Theme.of(context).primaryColorLight,
                                ],
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                stops: [.2, .8],
                                tileMode: TileMode.repeated),
                          ),
                          child: Icon(OMIcons.accountCircle)),
                      SizedBox(
                        width: Gparam.widthPadding / 2,
                      ),
                      Text('My Account',
                          style: TextStyle(
                              fontFamily: 'Eastman',
                              fontSize: 16,
                              color: Theme.of(context).primaryColor)),

                      Spacer(),
                      Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                             decoration: BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30.0)),
                            gradient: new LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  (Theme.of(context).brightness == Brightness.dark)
              ?Theme.of(context).backgroundColor:Theme.of(context).primaryColorLight,
                                ],
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                stops: [.2, .8],
                                tileMode: TileMode.repeated),
                          ),
                              width: 60,
                              child: Text('TRAIL',
                          style: TextStyle(
                              fontFamily: 'Eastman',
                              fontSize: 12,
                              )),
                            ),
                          ],
                        )

                    
                    ],
              ),
                    SizedBox(height: Gparam.heightPadding,),

                  
                  ],
                )),
              buildCardWidget(
                
                 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      
                      Text('User',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 12,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 0, left: 00),
                          padding: EdgeInsets.only(left: 0, top: 0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(0.0),
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Text(
                            g_name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 22.0,
                              color: Colors.grey.withOpacity(.8),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 0, left: 00),
                          padding: EdgeInsets.only(left: 0, top: 0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(0.0),
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(20.0)),
                          ),
                          child: Text(
                            g_email,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.withOpacity(.6),
                            ),
                          )),
                      Container(
                        height: 10,
                      ),
                      MaterialButton(
                        onPressed: () async {},
                        color: Colors.red.withOpacity(.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                        textColor: Colors.white,
                        child: Text('Signout',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 18,
                                color: Colors.white70)),
                      ),
                      Container(
                        height: 20,
                      ),
                      Text('Data Backup',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 20,
                      ),
                      Container(
                        height: 20,
                      ),
                      Text('Connect to Google Fit',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 60,
                            child: Switch(
                              value: isGfit,
                              onChanged: (value) async {
                                if (!isGfit) {
                                  bool isAuthorized =
                                      await Health.requestAuthorization();
                                  print(isAuthorized);
                                }
                                setState(() {
                                  isGfit = value;
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                
              ),
              buildCardWidget(
                Stack(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 170),
                    child: Icon(
                      OMIcons.questionAnswer,
                      color: Colors.grey.withOpacity(.05),
                      size: 350,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Survey Settings',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      Container(
                        height: 20,
                      ),
                      Text('Unfilled Survey',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ButtonTheme(
                            minWidth: 10,
                            height: 50,
                            buttonColor: Colors.transparent,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: (selected_unfilled == 1)
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent)),
                              // color: Theme.of(context).primaryColor,

                              color: Theme.of(context).scaffoldBackgroundColor,

                              child: new Text("Fill AI Generated Answer",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab', fontSize: 16)),
                              onPressed: () {
                                setState(() {
                                  selected_unfilled = 1;
                                  prefs.setInt('unfilled', selected_unfilled);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          new ButtonTheme(
                            minWidth: 10,
                            height: 50,
                            buttonColor: Colors.transparent,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: (selected_unfilled == 2)
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent)),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: new Text("Skip those days from analysis",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab', fontSize: 16)),
                              onPressed: () {
                                setState(() {
                                  selected_unfilled = 2;
                                  prefs.setInt('unfilled', selected_unfilled);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Text('Survey Time',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          ButtonBar(
                            mainAxisSize: MainAxisSize
                                .min, // this will take space as minimum as posible(to center)
                            children: <Widget>[
                              new ButtonTheme(
                                minWidth: 10,
                                height: 40,
                                buttonColor: Colors.transparent,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)),
                                  // color: Theme.of(context).primaryColor,

                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,

                                  child: new Text("+",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32)),
                                  onPressed: () {
                                    setState(() {
                                      if (min < 30) min++;
                                      mins = min.toString() + " mins";
                                      prefs.setInt("survey_length", min);
                                      if (min == 30) {
                                        mins = "30+ mins";
                                        prefs.setInt("survey_length", 30);
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, bottom: 00, left: 20, right: 20),
                                child: Text(
                                  mins,
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab', fontSize: 20),
                                ),
                              ),
                              new ButtonTheme(
                                minWidth: 10,
                                height: 40,
                                buttonColor: Colors.transparent,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Colors.transparent)),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: new Text("-",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32)),
                                  onPressed: () {
                                    setState(() {
                                      if (min > 10) min--;
                                      mins = min.toString() + " mins";
                                      prefs.setInt("survey_length", min);
                                      if (min == 10) {
                                        mins = "10- mins";
                                        prefs.setInt("survey_length", 10);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ]),
              ),
              buildCardWidget(
                Stack(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 170),
                    child: Icon(
                      OMIcons.money,
                      color: Colors.grey.withOpacity(.05),
                      size: 300,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Expense Settings',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      Container(
                        height: 20,
                      ),
                      Text('Currency',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          ButtonBar(
                            mainAxisSize: MainAxisSize
                                .min, // this will take space as minimum as posible(to center)
                            children: <Widget>[
                              new ButtonTheme(
                                minWidth: 10,
                                height: 50,
                                buttonColor: Colors.transparent,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: (selected_currency == 1)
                                              ? Theme.of(context).primaryColor
                                              : Colors.transparent)),
                                  // color: Theme.of(context).primaryColor,

                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,

                                  child: new Text("₹",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32)),
                                  onPressed: () {
                                    setState(() {
                                      selected_currency = 1;
                                      prefs.setString("currency", "₹");
                                    });
                                  },
                                ),
                              ),
                              new ButtonTheme(
                                minWidth: 10,
                                height: 50,
                                buttonColor: Colors.transparent,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: (selected_currency == 2)
                                              ? Theme.of(context).primaryColor
                                              : Colors.transparent)),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: new Text("\$",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32)),
                                  onPressed: () {
                                    setState(() {
                                      selected_currency = 2;
                                      prefs.setString("currency", "\$");
                                    });
                                  },
                                ),
                              ),
                              new ButtonTheme(
                                minWidth: 10,
                                height: 50,
                                buttonColor: Colors.transparent,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: (selected_currency == 3)
                                              ? Theme.of(context).primaryColor
                                              : Colors.transparent)),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: new Text("€",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32)),
                                  onPressed: () {
                                    setState(() {
                                      prefs.setString("currency", "€");
                                      selected_currency = 3;
                                    });
                                  },
                                ),
                              ),
                              new ButtonTheme(
                                minWidth: 10,
                                height: 50,
                                buttonColor: Colors.transparent,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: (selected_currency == 4)
                                              ? Theme.of(context).primaryColor
                                              : Colors.transparent)),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: new Text("£",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32)),
                                  onPressed: () {
                                    setState(() {
                                      prefs.setString("currency", "£");
                                      selected_currency = 4;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Text('Monthly Budget',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, bottom: 16.0, left: 20),
                            child: Text(
                              budget,
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab', fontSize: 24),
                            ),
                          ),
                          if (edit == 0)
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 4.0, left: 20),
                                  child: Icon(Icons.edit),
                                )),
                        ],
                      ),
                      if (edit == 1)
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, bottom: 16.0, left: 20),
                            child: TextField(
                              focusNode: BudgetFocus,
                              controller: BudgetTitle,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              maxLines: 1,
                              onSubmitted: (text) {
                                setState(() {
                                  edit = 0;
                                  budget = BudgetTitle.text;
                                  BudgetTitle.clear();
                                });
                              },
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter expense title',
                                focusColor: Colors.black,
                                hoverColor: Colors.black,
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 28,
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                              ),
                            ))
                    ],
                  )
                ]),
              ),
              buildCardWidget(Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('About app',
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 24,
                          color: Theme.of(context).primaryColor)),
                  Container(
                    height: 40,
                  ),
                  Center(
                    child: Text('Developed by'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1)),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 25.0),
                    child: Text(
                      'Shreyash Jain\n\nSuchit Sahoo',
                      style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                    ),
                  )),
                  Center(
                    child: AboutListTile(
                      icon: Icon(Icons.info, size: 20),
                      child: Text(
                        'About app',
                        style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      applicationIcon: new Image.asset(
                        'assets/images/SortedLogo.png',
                        width: 40,
                        height: 40,
                      ),
                      applicationName: 'Sorted',
                      applicationVersion: '1.0.0',
                      applicationLegalese: 'Just an Idea',
                      aboutBoxChildren: [
                        ///Content goes here...
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ))
        ],
      ),
    );
  }

  Widget buildCardWidget(Widget child) {
    return Container(
      decoration: BoxDecoration(
          color: (Theme.of(context).brightness == Brightness.dark)
              ? Theme.of(context).dialogBackgroundColor.withOpacity(.5)
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: Theme.of(context).focusColor.withAlpha(20),
                blurRadius: 16)
          ]),
      margin: EdgeInsets.only(left:Gparam.widthPadding,right:Gparam.widthPadding,top:Gparam.heightPadding/2),
      padding: EdgeInsets.all(Gparam.widthPadding / 2),
      child: child,
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.only(
                      left: Gparam.widthPadding,
                      top: Gparam.heightPadding / 2,
                      right: Gparam.widthPadding / 2),
                  child: Icon(OMIcons.arrowBack)),
            ),
            Text(
              'Settings',
              style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  void handleThemeSelection(bool value) {
    selectedTheme = "";

    if (!value) {
      print("helo");
      selectedTheme = "light";
      setState(() {
        ThemeChanger.of(context).appTheme = appThemeLight;
      });
    } else {
      print("celo");
      selectedTheme = "dark";
      setState(() {
        ThemeChanger.of(context).appTheme = appThemeDark;
      });
    }
    sl<SharedPrefHelper>().setThemeinSharedPref(selectedTheme);
  }
}
