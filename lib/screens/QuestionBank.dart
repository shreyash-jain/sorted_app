import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:notes/data/theme.dart';

import 'package:notes/services/database.dart';


class questionBank extends StatefulWidget {
  Function() triggerRefetch;
  Function(Brightness brightness) changeTheme;


  questionBank(
      {Key key,
        Function() triggerRefetch,


        Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.triggerRefetch = triggerRefetch;
  }



  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<questionBank> {
  PageController _pageController;
  ThemeData theme = appThemeLight;








  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,

        body:Container(
          height: MediaQuery.of(context).size.height ,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,

          ),

          )
    );

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


}
