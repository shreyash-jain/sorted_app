import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/question.dart';
import 'package:notes/services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class EditQuestionPage extends StatefulWidget {
  Function() triggerRefetch;
  QuestionModel existingQues;

  EditQuestionPage(
      {Key key, Function() triggerRefetch, QuestionModel existingQues})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingQues = existingQues;
  }

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  bool isDirty = true;
  bool isNewQues = true;
  FocusNode titleFocus = FocusNode();
  FocusNode ans1Focus = FocusNode();
  FocusNode ans2Focus = FocusNode();
  FocusNode ans3Focus = FocusNode();
  int type = 0;
  QuestionModel currentQues;
  TextEditingController titleController = TextEditingController();
  TextEditingController ans1Controller = TextEditingController();
  TextEditingController ans2Controller = TextEditingController();
  TextEditingController ans3Controller = TextEditingController();
  int my_id;
  String _selectedLocation;
  List<String> _locations = ['Daily', 'Weekly', 'Monthly'];
  String _selectedType;
  int selected_type;
  List<String> _types = ['Write', 'Choice', 'Count'];


  @override
  void initState() {
    super.initState();
    if (widget.existingQues == null) {
      currentQues = QuestionModel(
          ans1: '',
          ans2: '',
          ans3: '',
          title: '',
          weight: 0,
          correct_ans: 0,
          priority: 5,
          archive: 0,
          interval: 0,
          type: 0,
          num_ans: 0);
      isNewQues = true;
    } else {
      currentQues = widget.existingQues;
      isNewQues = false;
    }
    titleController.text = currentQues.title;
    ans1Controller.text = currentQues.ans1;
    ans2Controller.text = currentQues.ans2;
    ans3Controller.text = currentQues.ans3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: titleFocus,
                autofocus: true,
                controller: titleController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onSubmitted: (text) {
                  titleFocus.unfocus();
                },
                onChanged: (value) {
                  null;
                },
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontSize: 32,
                    fontWeight: FontWeight.w700),
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter a title',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 32,
                      fontFamily: 'ZillaSlab',
                      fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    width: 200,
                    child: Text(
                      'Type',
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                          color: Theme.of(context).primaryColor),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                  ),
                  Spacer(),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 160),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, right: 8, left: 8),
                    height: 50,
                    width: 150,
                    curve: Curves.slowMiddle,
                    child: Row(
                      children: <Widget>[
                        new DropdownButton(
                          hint: Text(
                            'Select',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: Colors.white),
                          ),
                          value: _selectedType,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedType = newValue;
                              if (_selectedType == "Write") {
                                setState(() {
                                  type = 0;

                                });
                              } else if (_selectedType == "Choice") {
                                setState(() {
                                  type = 1;

                                });
                              } else if (_selectedType == "Count") {
                                setState(() {

                                  type = 2;
                                });
                              }
                            });
                          },
                          items: _types.map((location) {
                            return DropdownMenuItem(
                              child: new Text(
                                location,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                   ),
                              ),
                              value: location,
                            );
                          }).toList(),
                        ),


                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          width: 1,
                          color: Colors.blue.shade700,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                ])),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: <Widget>[
                  AnimatedContainer(

                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    width: 200,
                    child: Text(
                      'Repeat',
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                          color: Theme.of(context).primaryColor),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                  ),
                  Spacer(),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 160),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, right: 8, left: 8),
                    height: 50,
                    width: 150,
                    curve: Curves.slowMiddle,
                    child: Row(
                      children: <Widget>[
                        new DropdownButton(
                          hint: Text(
                            'Select',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: Theme.of(context).primaryColor),
                          ),
                          value: _selectedLocation,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLocation = newValue;
                            });
                          },
                          items: _locations.map((location) {
                            return DropdownMenuItem(
                              child: new Text(
                                location,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                    color: Theme.of(context).primaryColor),
                              ),
                              value: location,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          width: 2,
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                ])),
            buildImportantIndicatorText(type),
          ],
        ),
        ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                margin: EdgeInsets.only(top:6),
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: handleBack,
                      ),
                      Spacer(),

                      AnimatedContainer(
                        margin: EdgeInsets.only(left: 10),
                        duration: Duration(milliseconds: 200),
                        width: isDirty ? 120 : 0,
                        height: 42,
                        curve: Curves.decelerate,
                        child: RaisedButton.icon(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  bottomLeft: Radius.circular(100))),
                          icon: Icon(Icons.done),
                          label: Text(
                            'SAVE',
                            style: TextStyle(letterSpacing: 1),
                          ),
                          onPressed: handleSave,
                        ),
                      )
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }

  Widget buildImportantIndicatorText(int type) {
    Widget child;
    if (type == 1)
      child = Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'With Answer as a choice ',
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(left:16,right: 16),

              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [

                  ]
              ),

              child:
                    Padding(
                      padding: const EdgeInsets.only(left:20,right:20),
                      child: TextField(
                        focusNode: ans1Focus,
                        autofocus: true,
                        controller: ans1Controller,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        onSubmitted: (text) {
                          titleFocus.unfocus();
                          FocusScope.of(context).requestFocus(ans2Focus);
                        },
                        onChanged: (value) {},
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enter your 1st choice like  "Yes"',
                          hintStyle: TextStyle(

                              fontSize: 18,
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w700),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

      ),
          Container(
              margin: EdgeInsets.only(left:16,right: 16,top: 8),

              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [

                  ]
              ),

              child:Padding(
                padding: const EdgeInsets.only(left:20,right:20),
                child: TextField(
                  focusNode: ans2Focus,
                  autofocus: true,
                  controller: ans2Controller,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  onSubmitted: (text) {
                    titleFocus.unfocus();
                    FocusScope.of(context).requestFocus(ans3Focus);
                  },
                  onChanged: (value) {},
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                      fontFamily: 'ZillaSlab',
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Enter your 2nd choice like  "No"',
                    hintStyle: TextStyle(

                        fontSize: 18,
                        fontFamily: 'ZillaSlab',
                        fontWeight: FontWeight.w700),
                    border: InputBorder.none,
                  ),
                ),
              ),
          ),
          Container(
              margin: EdgeInsets.only(left:16,right: 16,top: 8),

              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [

                  ]
              ),
          child: Padding(
            padding: const EdgeInsets.only(left:20,right:20),
            child: TextField(
              focusNode: ans3Focus,
              autofocus: true,
              controller: ans3Controller,
              keyboardType: TextInputType.text,
              maxLines: 1,
              onSubmitted: (text) {
                titleFocus.unfocus();
              },
              onChanged: (value) {},
              textInputAction: TextInputAction.done,
              style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
              decoration: InputDecoration.collapsed(
                hintText: 'Enter your 3rd choice like  "maybe"',
                hintStyle: TextStyle(

                    fontSize: 18,
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700),
                border: InputBorder.none,
              ),
            ),
          ),)

          ]));
    else if (type == 0)
      child = Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'With Answer as a\nshort Discription',
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ),
          ]));
    else if (type == 2)
      child = Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'With Answer as a\nCount or a Number',
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ),
          ]));
    else if (type == 3)
      child = Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'With Answer as a Time',
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor),
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ),
          ]));
    return new Container(child: child);
  }

  void handleSave() async {
    int interval = 0;
    setState(() {
      currentQues.ans1 = "";
      currentQues.ans2 = "";
      currentQues.ans3 = "";
      currentQues.num_ans = 0;
      currentQues.title = titleController.text;
      if (_selectedLocation == "Daily")
        interval = 1;
      else if (_selectedLocation == "Weekly")
        interval = 2;
      else if (_selectedLocation == "Monthly")
        interval = 3;
      else
        interval = 1;
      currentQues.interval = interval;
    });
    if (type == 0) {
      setState(() {
        currentQues.num_ans = 0;
        currentQues.type = 0;
      });
    } else if (type == 1) {
      setState(() {
        currentQues.num_ans = 3;
        currentQues.type = 1;
        if (ans1Controller.text != "") currentQues.ans1 = ans1Controller.text;
        if (ans2Controller.text != "") currentQues.ans2 = ans2Controller.text;
        if (ans3Controller.text != "") currentQues.ans3 = ans3Controller.text;
      });
    } else if (type == 2) {
      currentQues.type = 2;
      currentQues.num_ans = 0;
    } else {
      currentQues.type = 2;
      currentQues.num_ans = 0;
    }
    await NotesDatabaseService.db.addQuestionInDB(currentQues);
    widget.triggerRefetch();
    titleFocus.unfocus();
    ans1Focus.unfocus();
    ans2Focus.unfocus();
    ans3Focus.unfocus();
    Navigator.pop(context);
  }

  void handleDelete() async {
    /*     if (isNoteNew) {       Navigator.pop(context);     } else {       showDialog(           context: context,           builder: (BuildContext context) {             return AlertDialog(               shape: RoundedRectangleBorder(                   borderRadius: BorderRadius.circular(8)),               title: Text('Delete Note'),               content: Text('This note will be deleted permanently'),               actions: <Widget>[                 FlatButton(                   child: Text('DELETE',                       style: prefix0.TextStyle(                           color: Colors.red.shade300,                           fontWeight: FontWeight.w500,                           letterSpacing: 1)),                   onPressed: () async {                     await NotesDatabaseService.db.deleteNoteInDB(currentNote);                     await NotesDatabaseService.db.decreaseNotebookInDB(currentNote.book_id);                     widget.triggerRefetch();                     Navigator.pop(context);                     Navigator.pop(context);                   },                 ),                 FlatButton(                   child: Text('CANCEL',                       style: TextStyle(                           color: Theme.of(context).primaryColor,                           fontWeight: FontWeight.w500,                           letterSpacing: 1)),                   onPressed: () {                     Navigator.pop(context);                   },                 )               ],             );           });     }*/
  }

  void handleBack() {
    Navigator.pop(context);
  }
}
