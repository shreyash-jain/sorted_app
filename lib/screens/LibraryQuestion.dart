
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/LibraryCards.dart';
import 'package:notes/components/bookcards.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
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
backgroundColor: Theme.of(context).primaryColor,

      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [

      SliverSafeArea(
        top: false,
        sliver: SliverAppBar(
          backgroundColor:    Color(0xFFAFB4C6).withOpacity(.9),
          actions: <Widget>[

          ],
          leading: IconButton(
            icon: const Icon(OMIcons.arrowBack),
            tooltip: 'Add new entry',
            onPressed: () { Navigator.pop(context);},
          ),
          expandedHeight: 250,
          pinned: true,
          primary:true,
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.only(bottomRight: Radius.circular(45.0)),

          ),
          flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Library Questions",
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),


              background: Container(
                padding: EdgeInsets.only(top:120,left:73),
                child:FadeAnimation(1.6, Container(

                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[



                        Text("",style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 32.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black26
                        ),
                          textAlign: TextAlign.left,),
                      ],)
                )),
                decoration: new BoxDecoration(

                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFF00c6ff),
                        Theme
                            .of(context)
                            .primaryColor,
                      ],
                      stops: [0.0, 1.0],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      tileMode: TileMode.clamp),
                ),
              )
          ),

        ),

      ),

    ],
    body: Container(
    height: MediaQuery.of(context).size.height ,
    decoration: BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
    ),

    child:AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[



            ...buildNoteComponentsList(),
          ],
        ),
        margin: EdgeInsets.only(top: 2),
        padding: EdgeInsets.only(left: 15, right: 15),
      ),)),
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



                  quesData.archive=0;
                  await NotesDatabaseService.db.updateQuestionInDB(quesData);
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
