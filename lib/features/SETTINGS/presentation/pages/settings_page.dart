import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/script/v1.dart';
import 'package:health/health.dart';

import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/shared_pref_helper.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/theme/app_theme_wrapper.dart';
import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/features/SETTINGS/presentation/bloc/settings_bloc.dart';
import 'package:sorted/features/SETTINGS/presentation/widgets/account_settings.dart';
import 'package:sorted/features/SETTINGS/presentation/widgets/expense_settings.dart';
import 'package:sorted/features/SETTINGS/presentation/widgets/general_settings.dart';
import 'package:sorted/features/SETTINGS/presentation/widgets/survey_settings.dart';
import 'package:sorted/main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key})
      : super(key: key) {}
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme;
  SharedPreferences prefs;
  SettingsBloc bloc;
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
  SettingsLoaded currentState;

  String mins = "15 mins";

  bool isGfit = false;

  var googleFitSwitched = false;

  double _valueSurveyTime = 15;

  double _valueBudget = 500;

  initiatePref() async {
    bloc = sl<SettingsBloc>();
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
        body: BlocProvider(
            create: (context) => bloc..add(LoadDetails()),
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                if (state is SettingsLoaded) {
                  currentState = state;
                  return ListView(
                   
                    children: <Widget>[
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(top: Gparam.heightPadding / 2),
                            child: buildHeaderWidget(context),
                          ),
                          GeneralSettings(
                            biometricSwitched: state.biometricState,
                            onTapBiometric: onTapBiometric,
                            onTapThemeChange: onTapThemeChange,
                          ),
                          Accountsettings(
                            g_name: state.userdetails.name,
                            g_email: state.userdetails.email,
                            googleFitSwitched: googleFitSwitched,
                            onTapGoogleFit: onTapGoogleFit,
                          ),
                          SurveySettings(
                            autofill:
                                state.settingsDetails.unfilledSurveyPreference,
                            valueSurveyTime:
                                state.settingsDetails.surveyTime + 0.0,
                            onSliderChange: onSliderChange,
                          ),
                          ExpenseSettings(
                            valueBudget: state.settingsDetails.budget,
                            currency: state.settingsDetails.currency,
                            onCurrencyChange: onCurrencyChange,
                            onSliderChange: onBudgetSliderChange,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: Gparam.widthPadding,
                                    top: Gparam.heightPadding * 2,
                                    bottom: Gparam.heightPadding,
                                    right: Gparam.widthPadding),
                                child: Text('About Sorted',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: Gparam.textSmall,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Image(
                                image: AssetImage(
                                  "assets/images/SortedLogo.png",
                                ),
                                height: 33,
                                width: 33,
                              ),
                            ),
                          ),
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Center(
                                child: Text('Developed by'.toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1)),
                              ),
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 10.0),
                                child: Text(
                                  'Sorted Labs',
                                  style: TextStyle(
                                      fontFamily: 'Eastman', fontSize: 16),
                                ),
                              )),
                            ],
                          )),
                          SizedBox(
                            height: Gparam.heightPadding,
                          ),
                          Container(
                            color: Colors.black12,
                            child: AboutListTile(
                              icon: Icon(Icons.copyright, size: 20),
                              child: Text(
                                'Sorted Labs | Sorted Application v.1.0.0 | 2020',
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
                  );
                }
              },
            )));
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

  void handleThemeSelection(String value) {
    selectedTheme = "";
    print(value);

    if (value == "light") {
      print("helo");
      selectedTheme = "light";
      setState(() {
        ThemeChanger.of(context).appTheme = appThemeLight;
      });
    } else if (value == "dark") {
      print("celo");
      selectedTheme = "dark";
      setState(() {
        ThemeChanger.of(context).appTheme = appThemeDark;
      });
    } else if (value == "dark_blue") {
      selectedTheme = "dark_blue";
      setState(() {
        ThemeChanger.of(context).appTheme = appThemeDarkBlue;
      });
    } else if (value == "light_pink") {
      selectedTheme = "light_pink";
      setState(() {
        ThemeChanger.of(context).appTheme = appThemeLightPink;
      });
    }
    sl<SharedPrefHelper>().setThemeinSharedPref(selectedTheme);
    bloc.add(UpdateDetails(
        currentState.settingsDetails.copyWith(theme: selectedTheme)));
  }

  onTapBiometric(bool biometric) {
    setState(() {
      biometricSwitched = biometric;

      if (biometricSwitched)
        prefs.setBool('biometric', true);

      else
        prefs.setBool('biometric', false);
    });
    bloc.add(UpdateBiometricState(biometric));
    
  }

  onTapThemeChange(String theme) {
    handleThemeSelection(theme);
  }

  Future<void> onTapGoogleFit(bool gFit) async {
    googleFitSwitched = gFit;
    bool isAuthorized = await Health.requestAuthorization();
    if (!isAuthorized) googleFitSwitched = false;
  }

  onSliderChange(double timeValue) {
    setState(() {
      _valueSurveyTime = timeValue;
      bloc.add(UpdateDetails(currentState.settingsDetails.copyWith(surveyTime: timeValue.floor())));
    });
  }

  onCurrencyChange(int currency, String symbol) {
    setState(() {
      selected_currency = currency;
      prefs.setString("currency", symbol);
      bloc.add(UpdateDetails(currentState.settingsDetails.copyWith(currency: symbol)));
    });
  }

  onBudgetSliderChange(double timeValue) {
    setState(() {
      _valueBudget = timeValue;
      bloc.add(UpdateDetails(currentState.settingsDetails.copyWith(budget:timeValue)));

    });
  }
}
