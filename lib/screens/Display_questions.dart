import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/data/answer.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/services/database.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DisplayQuestions extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  String payload;
  DisplayQuestions({Key key,String payload, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.payload=payload;
  }

  @override
  _DisplayQuestionsState createState() => _DisplayQuestionsState();
}

class _DisplayQuestionsState extends State<DisplayQuestions> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int _radioValue1 = -1;
  int selected = -1;
  int _currentValue = 1;

  ThemeData theme = appThemeLight;
  List<QuestionModel> quesList = [];
  List<AnswerModel> ansList=[];
  Timer _timer;
  int min;
  int sec;
  int _start = 600;
int started=0;
  QuestionModel currentQues;
  List<bool> visited;
  FocusNode titleFocus = FocusNode();
  List<TextEditingController> titleController = [];
  Decoration _decoration = new BoxDecoration(
    color: Colors.transparent,
    border: new Border(
      top: new BorderSide(
        style: BorderStyle.solid,
        color: Colors.white,
      ),
      bottom: new BorderSide(
        style: BorderStyle.solid,
        color: Colors.white,
      ),
    ),
  );
  final controller =
      PageController(viewportFraction: 1.0, initialPage: 0, keepPage: false);

  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setQuesFromDB();
  }

  setQuesFromDB() async {
    print("Entered setQues");
    var fetchedQues = await NotesDatabaseService.db.getQuestionsFromDB();
    print("questions" + fetchedQues.toString());
    setState(() {
      quesList = fetchedQues;
      AnswerModel temp = AnswerModel(content: "",res1: 0,res2: 0,res3: 0,streak: 0);

      TextEditingController temp_text = TextEditingController();
      for (var i = 0; i < quesList.length; i++) {
        titleController.add(TextEditingController());
        AnswerModel temp =new AnswerModel(content: "hbh",res1: 0,res2: 0,res3: 0,streak: 0);
        ansList.add(temp);
      }
    });
    print("questions title " + quesList[0].interval.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,

      appBar:

      AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,

        title: Hero(
          child: Material(
            color: Colors.transparent,
            child: /*Text(
              "Your Questions",
              style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
            ),*/
            RaisedButton(
              onPressed: () {
                startTimer();
              },
              child: Text((started==1)?"$min : $sec":"Click to Start Survey",style: TextStyle(
                  fontFamily: 'ZillaSlab',

                  fontSize: 24,
                  fontWeight: FontWeight.w600),),
            ),

          ),
          tag: "title1",
          transitionOnUserGestures: true,
        ),
      ),
      body: PageView.builder(
        controller: controller,
        allowImplicitScrolling: false,
        itemBuilder: (context, position) {
          print("grey.shade900 : " + position.toString());
          int type = quesList[position].type;
          ansList[position].q_id = 0;
          ansList[position].streak = 0;
          ansList[position].date = DateTime.now();
          ansList[position].content="bla";
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal:16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 4.0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(

                            quesList[position].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',

                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: buildImportantIndicatorText(
                            position,
                            type,
                            quesList[position].ans1,
                            quesList[position].ans2,
                            quesList[position].ans3),
                      ),
                    ),
                    if (position + 1 < quesList.length)
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: quesList.length,
                            effect: SlideEffect(
                                spacing: 6.0,
                                radius: 10.0,
                                dotWidth: 22.0,
                                dotHeight: 16.0,
                                paintStyle: PaintingStyle.fill,
                                strokeWidth: 1.5,
                                dotColor: Colors.grey,
                                activeDotColor: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    if (position + 1 < quesList.length)
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () {
                                controller.animateToPage(
                                    (position + 1 < quesList.length)
                                        ? position + 1
                                        : position,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                                print("this is answer "+titleController[position].text);
                                if (titleController[position].text != "")
                                  ansList[position].content =
                                      titleController[position].text;
                                print(position);
                                print("this is answer "+ansList[position].content.toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down,

                                  size: 36,
                                ),
                              ),
                            )),
                      ),
                    if (position + 1 == quesList.length)
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RaisedButton(
                            onPressed: () {
                              handleSave();
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                ),
              ),
            ],
          );
        },
        scrollDirection: Axis.vertical,
        itemCount: quesList.length,
      ),
    );
  }

  void _handleRadioValueChange1(int value, int position) {
    setState(() {
      _radioValue1 = value;
      print(position);
      switch (_radioValue1) {
        case 0:
          selected = 0;
          ansList[position].res1 = 1;
          ansList[position].res2 = 0;
          ansList[position].res3 = 0;
          print("ye kia " + selected.toString());
          break;
        case 1:
          selected = 1;
          ansList[position].res1 = 0;
          ansList[position].res2 = 1;
          ansList[position].res3 = 0;
          print("ye kia " + selected.toString());
          break;
        case 2:
          selected = 2;
          ansList[position].res1 = 0;
          ansList[position].res2 = 0;
          ansList[position].res3 = 1;
          print("ye kia " + selected.toString());
          break;
      }
    });
  }

  Widget buildImportantIndicatorText(
      int position, int type, String opt1, String opt2, String opt3) {
    print(position.toString()+" "+type.toString()+" hhhd");

    Widget child;
    if (type == 1 && quesList[position].type==1) {
      child = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                new Radio(
                  value: 0,
                  groupValue: _radioValue1,
                  onChanged: (int) => _handleRadioValueChange1(0, position),
                ),
                new Text(
                  opt1,
                  style: new TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                new Radio(
                  value: 1,
                  groupValue: _radioValue1,
                  onChanged: (int) => _handleRadioValueChange1(1, position),
                ),
                new Text(
                  opt2,
                  style: new TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                new Radio(
                  value: 2,
                  groupValue: _radioValue1,
                  onChanged: (int) => _handleRadioValueChange1(2, position),
                ),
                new Text(
                  opt3,
                  style: new TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ]);
    } else if (type == 0 && quesList[position].type==0) {
      child = Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child:TextField(
                      textAlign: TextAlign.center,
                    focusNode: titleFocus,
                    autofocus: true,
                    controller: titleController[position],
                    keyboardType: TextInputType.multiline,

                    maxLines:6,
                    onSubmitted: (text) {
                      titleFocus.unfocus();
                      ansList[position].content =
                          titleController[position].toString();
                    },
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 20,

                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter your answer...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 22,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w600),
                      border: InputBorder.none,
                    ),
                  ),
                ),),
              ]));
    } else if (type == 2 && quesList[position].type==2) {
      child = Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: new NumberPicker.integer(
              initialValue: _currentValue,
              minValue: 0,
              maxValue: 100,
              highlightSelectedValue: true,
              decoration: _decoration,
              onChanged: (newValue) =>
                  setState(() => _currentValue = newValue)));
    }
    return new Container(child: child);
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  void startTimer() {
    started=1;
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {

            timer.cancel();
          } else {
            _start = _start - 1;
            Duration d=Duration(seconds: _start);
            min=d.inMinutes;
            sec=d.inSeconds.remainder(60);
          }
        },
      ),
    );
  }

  void handleSave() async {
    for (var i = 0; i < quesList.length; i++) {
      print(ansList[i].content);
      print(titleController[i].text);
      ansList[i].q_id=quesList[i].id;
      ansList[i].discription=quesList[i].title;
      ansList[i].content=titleController[i].text;
      await NotesDatabaseService.db.addAnswerInDB(ansList[i]);
      print("fianlly "+ ansList[i].content);
    }
    Navigator.pop(context);
  }
}
