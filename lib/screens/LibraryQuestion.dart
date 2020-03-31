import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes/components/LibraryCards.dart';
import 'package:notes/components/bookcards.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/edit.dart';
import 'package:notes/screens/home.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'QuestionForm.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/bookcards.dart';

class LibraryQuestion extends StatefulWidget {
  Function() triggerRefetch;
  Function(Brightness brightness) changeTheme;

  LibraryQuestion(
      {Key key,
        Function() triggerRefetch,
        this.title,
        Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.triggerRefetch = triggerRefetch;
  }

  final String title;

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<LibraryQuestion> {
  PageController _pageController;
  ThemeData theme = appThemeLight;
  bool isFlagOn = false;
  int _selectedIndex;
  List<QuestionModel> quesList = [];
  TextEditingController searchController = TextEditingController();
  QuestionModel currentQues;
  bool isSearchEmpty = true;
  bool headerShouldHide = false;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setQuesFromDB();
  }

  setQuesFromDB() async {
    print("Entered setQues");
    var fetchedQues = await NotesDatabaseService.db.getLibraryQuestionsFromDB();
    print("questions" + fetchedQues.length.toString());
    setState(() {
      quesList = fetchedQues;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                SettingsPage(changeTheme: widget.changeTheme)));
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      OMIcons.settings,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade600
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
            ),
            buildHeaderWidget(context),
            Container(height: 32),
            ...buildNoteComponentsList(),
          ],
        ),
        margin: EdgeInsets.only(top: 2),
        padding: EdgeInsets.only(left: 15, right: 15),
      ),
    );
  }


  List<Widget> buildNoteComponentsList() {
    List<Widget> noteComponentsList = [];

    quesList.forEach((note) {
      noteComponentsList.add(QuestionCardComponent(
        QuestionData: note,
        onTapAction: editQuestion,
      ));
    });
    return noteComponentsList;
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 32, left: 10),
          width: headerShouldHide ? 0 : null,
          child: Text(
            'Library Questions',
            style: TextStyle(
                fontFamily: 'ZillaSlab',
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: Theme.of(context).primaryColor),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }

  editQuestion(QuestionModel quesData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Add Question'),
            content: Text('This question will be added to your list'),
            actions: <Widget>[
              FlatButton(
                child: Text('ADD',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  quesData.archive=1;

                  await NotesDatabaseService.db.updateLibraryQuestionInDB(quesData);
                  quesData.archive=0;
                  await NotesDatabaseService.db.addQuestionInDB(quesData);
                  refetchNotebookFromDB();
                  widget.triggerRefetch();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
    await Future.delayed(Duration(milliseconds: 300), () {});
    setState(() {
      headerShouldHide = false;
    });
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

  void refetchNotebookFromDB() async {
    await setQuesFromDB();
    print("Refetched notes");
  }
}
