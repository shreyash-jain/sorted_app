import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/LibraryCards.dart';
import 'package:notes/data/activity.dart';
import 'package:notes/data/answer.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/eCat.dart';
import 'package:notes/data/expense.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:faker/faker.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/data/user_activity.dart';

import 'package:notes/services/database.dart';


class manager extends StatefulWidget {
  Function() triggerRefetch;
  Function(Brightness brightness) changeTheme;


  manager(
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

class _AddQuestionState extends State<manager> {
  PageController _pageController;
  ThemeData theme = appThemeLight;

  FocusNode titleFocus = FocusNode();
  FocusNode catFocus = FocusNode();
  FocusNode typeFocus = FocusNode();

  FocusNode id1focus = FocusNode();
  FocusNode id2Focus = FocusNode();
  FocusNode a_titleFocus = FocusNode();
  FocusNode a_imageFocus = FocusNode();
  FocusNode a_weightFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController catController = TextEditingController();
  TextEditingController QidController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  TextEditingController a_titleController = TextEditingController();
  TextEditingController a_imageController = TextEditingController();
  TextEditingController a_weightController = TextEditingController();
  TextEditingController id1Controller = TextEditingController();
  TextEditingController id2Controller = TextEditingController();
  final _random = new Random();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  int path=0;
  int fun=-1;

  int  n_exp=0;
  int n_ans=0;

  int type=0;

  var isSwitched=false;

  bool isuser=false;



  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    getUser();

  }

getUser() async {

   user = await _auth.currentUser();
}

  int next(int min, int max) => min + _random.nextInt(max - min);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,

        body:Container(
          height: MediaQuery.of(context).size.height ,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,

          ),

          child:AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[

                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {

                    setState(() {
                      fun=1;
                    });
                  },
                  color: (path==0)?Colors.red:Colors.blue,
                  textColor: Colors.white,
                  child: Text("Set path".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
                if (fun==1)Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {

                        setState(() {
                          path=1;
                        });
                      },
                      color: (path==1)?Colors.blue:Colors.blueGrey,
                      textColor: Colors.white,
                      child: Text("User".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {

                        setState(() {
                          path=2;
                        });
                      },
                      color: (path==2)?Colors.blue:Colors.blueGrey,
                      textColor: Colors.white,
                      child: Text("App".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ],),
                if(path==1)RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {

                    setState(() {
                      fun=2;
                    });
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Add Expenses".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),

                if (path==2) Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    focusNode: id1focus,
                    autofocus: true,
                    controller: id1Controller,
                    keyboardType: TextInputType.number,
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
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter ID',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 20,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (path==2) Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    focusNode: id2Focus,
                    autofocus: true,
                    controller: id2Controller,
                    keyboardType: TextInputType.number,
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
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enter ID',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 20,
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {

                    setState(() {
                      fun=3;
                    });
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Add Question".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
                if(path==1)RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {

                    setState(() {
                      fun=4;
                    });
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Add Answers".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
                if(path==2)RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {

                    setState(() {
                      fun=5;
                    });
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Add Categories".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
                if(path==2)RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {

                    setState(() {
                      fun=6;
                    });
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Add Activities".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
                if(path==2)RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {

                    setState(() {
                      fun=7;
                    });
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Add Notebooks".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),

                if (fun==2)Column(
                  children: <Widget>[
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: <Widget>[
                     Text(
                       n_exp.toString(),
                       style: TextStyle(
                         fontFamily: 'ZillaSlab',
                         color: Theme.of(context).textSelectionColor,
                         fontSize: 14.0,
                         fontWeight: FontWeight.bold,
                       ),
                     ),

                     GestureDetector(
                         onTap: (){

                           setState(() {
                             n_exp=n_exp+5;
                           });
                         },

                         child:Icon(Icons.add_circle)
                     )

                   ],),

                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () async {


                        await AddRandomExpenses();



                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("Add Random Expenses".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ],


                ),
                if (fun==3)Column(
                  children: <Widget>[
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
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enter a title',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 20,
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w700),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "Select Type 0 : Write | 1 : Choice | 2 : Count",
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          type.toString(),
                          style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        GestureDetector(
                            onTap: (){

                              setState(() {
                                type++;
                              });
                              if (type==3)
                                {

                                  setState(() {
                                    type=0;
                                  });
                                }
                            },

                            child:Icon(Icons.add_circle,size:30)
                        )

                      ],),
                    Text(
                      "enable to make archive",
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                         
                          
                        });
                      },
                      activeColor:
                      Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        focusNode: catFocus,
                        autofocus: true,
                        controller: catController,
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
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Enter category',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 20,
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w700),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {


                        makeQuestion();


                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("Add Question".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ],


                ),
                if (fun==4)Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          n_ans.toString(),
                          style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        GestureDetector(
                            onTap: (){

                              setState(() {
                                n_ans=n_ans+5;
                              });
                            },

                            child:Icon(Icons.add_circle)
                        )

                      ],),


                    if (path==1)StreamBuilder(
                      stream: Firestore.instance
                          .collection('users').document(user.uid).collection("Questions").orderBy('_id').snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting :
                            return Center(
                              child:   CircularProgressIndicator(),
                            );
                          default:
                            return ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                List rev = snapshot.data.documents.reversed.toList();
                                QuestionModel message = QuestionModel.fromSnapshot(rev[index]);
                                return QuestionCardComponent(QuestionData: message,onTapAction: null,);
                              },
                            );
                        }
                      },
                    ),
                    if (path==2)StreamBuilder(
                      stream: Firestore.instance
                          .collection('StartData').document('data').collection("Questions").snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child:   CircularProgressIndicator(),
                            );
                          default:
                            return ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                List rev = snapshot.data.documents.reversed.toList();
                                QuestionModel message = QuestionModel.fromSnapshot (rev[index]);
                                return QuestionCardComponent(QuestionData: message,onTapAction: null,);
                              },
                            );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        focusNode: titleFocus,
                        autofocus: true,
                        controller: QidController,
                        keyboardType: TextInputType.number,
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
                          hintText: 'Enter ID',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 20,
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w700),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        focusNode: typeFocus,
                        autofocus: true,
                        controller: typeController,
                        keyboardType: TextInputType.number,
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
                          hintText: 'Enter type',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 20,
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w700),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {


                        addRandomAnswers();


                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("Add Random Answers".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ],


                ),
                if (fun==6)Column(children: <Widget>[


                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      focusNode: a_titleFocus,
                      autofocus: true,
                      controller:  a_titleController,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter name',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.w700),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      focusNode: a_imageFocus,
                      autofocus: true,
                      controller: a_imageController,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter image',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.w700),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      focusNode: a_weightFocus,
                      autofocus: true,
                      controller:a_weightController,
                      keyboardType: TextInputType.number,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter weight',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.w700),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Switch(
                    value: isuser,
                    onChanged: (value) {
                      setState(() {
                        isuser = value;


                      });
                    },
                    activeColor:
                    Theme.of(context).primaryColor,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () {

                      AddActivity();



                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text("Add Activity".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),
                ],),
                if (fun==5)Column(children: <Widget>[


                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      focusNode: a_titleFocus,
                      autofocus: true,
                      controller:  a_titleController,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter name',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.w700),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      focusNode: a_imageFocus,
                      autofocus: true,
                      controller: a_imageController,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter image',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.w700),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  Switch(
                    value: isuser,
                    onChanged: (value) {
                      setState(() {
                        isuser = value;


                      });
                    },
                    activeColor:
                    Theme.of(context).primaryColor,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () {



                      AddCat();

                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text("Add Category".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),
                ],),
                if (fun==7)Column(children: <Widget>[


                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      focusNode: a_titleFocus,
                      autofocus: true,
                      controller:  a_titleController,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter name',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.w700),
                        border: InputBorder.none,
                      ),
                    ),
                  ),



                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () {

                      AddNotebook();


                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Text("Add Notebook".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),
                ],)


              ],
            ),
            margin: EdgeInsets.only(top: 2),
            padding: EdgeInsets.only(left: 15, right: 15),
          ),)
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

  Future<void> AddRandomExpenses() async {

    ExpenseModel expense;
    for (int i=0;i<n_exp;i++) {

      int back=next(1, 200);
      DateModel this_date;
      DateTime e_date=DateTime.now().subtract(Duration(days:back));
      expense=new ExpenseModel(
        title: faker.food.restaurant(),
        money: next(1, 10000)+0.0,
        cat_id: next(1, 11),
        type:1,
        content: faker.lorem.sentence(),
        date: e_date



      );
      var formatter = new DateFormat('dd-MM-yyyy');
      String formatted_date = formatter.format(e_date);
      print("formatted date: " + formatted_date);
      var fetchedDate = await NotesDatabaseService.db
          .getDateByDateFromDB(formatted_date);
      setState(() {
        this_date = fetchedDate;
      });

      if (this_date == null) {
        DateModel newDate = DateModel(
            date: DateTime.now(),
            time_start: DateTime.now(),
            time_end: DateTime.now(),
            survey: 0);
        var added_date = await NotesDatabaseService.db
            .addDateInDB(newDate);
        setState(() {
          this_date = added_date;
          expense.date_id = this_date.id;
        });
        print("here 2  ");
      } else {
        expense.date_id = this_date.id;
      }
      await NotesDatabaseService.db
          .addExpense(expense);

    }

  }

  Future<void> makeQuestion() async {
    QuestionModel ques;
    int id=0;
    if (id1Controller!="") id=int.parse(id1Controller.text);
    ques = QuestionModel(
      id:id,
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
    ques.title=titleController.text;
    ques.type=type;
    if (isSwitched)ques.archive=1;
    ques.c_name=catController.text;
    if (type==1)
    {
      ques.ans1 = "Yes";
      ques.ans2 = "No";
      ques.ans3 = "May be";
    }
    if (path==1){
      await NotesDatabaseService.db.addQuestionInDB(ques);

    }
    else if(path==2){
       NotesDatabaseService.db.addQuestionInInitailCloud(ques);

    }











  }

  Future<void> addRandomAnswers() async {

    AnswerModel ans;
    for (int i=0;i<n_ans;i++) {

      int back=next(1, 200);
      DateModel this_date;
      DateTime a_date=DateTime.now().subtract(Duration(days:back));
      type=int.parse(typeController.text);
      ans=new AnswerModel(
          q_id: int.parse(QidController.text),
        date: a_date,
      );
      var formatter = new DateFormat('dd-MM-yyyy');
      String formatted_date = formatter.format(a_date);
      print("formatted date: " + formatted_date);
      var fetchedDate = await NotesDatabaseService.db
          .getDateByDateFromDB(formatted_date);
      setState(() {
        this_date = fetchedDate;
      });

      if (this_date == null) {
        DateModel newDate = DateModel(
            date: DateTime.now(),
            time_start: DateTime.now(),
            time_end: DateTime.now(),
            survey: 0);
        var added_date = await NotesDatabaseService.db
            .addDateInDB(newDate);
        setState(() {
          this_date = added_date;
          ans.date_id = this_date.id;
        });
        print("here 2  ");
      } else {
        ans.date_id = this_date.id;
      }

      if (type==0){

        ans.content=faker.lorem.sentence();
        ans.a_rating=next(1, 4).roundToDouble();
      }

      else if (type==1)  {

        int choice=next(1,4);
        print("? choice "+choice.toString());
        if (choice==1){

          ans.res1=1;
          ans.res2=0;
          ans.res3=0;
        }

        else if (choice==2){
          ans.res1=0;
          ans.res2=1;
          ans.res3=0;
        }
        else {
          ans.res1=0;
          ans.res2=0;
          ans.res3=1;

        }



      }

      else if (type==2) {
        ans.res1=next(1,600);

      }
      else if (type==4){
        ans.res1=next(1,600);
      }
      await NotesDatabaseService.db
          .addAnswerInDB(ans);

    }

  }

  Future<void> AddActivity() async {
    ActivityModel basic_act= new ActivityModel(id:int.parse(id1Controller.text),name:a_titleController.text,image:a_imageController.text,weight:int.parse(a_weightController.text));
    UserAModel basic_user_act;
    if (isuser){
     basic_user_act= new UserAModel(id:int.parse(id2Controller.text),name:a_titleController.text,image:a_imageController.text,a_id:int.parse(id1Controller.text));


    }
    NotesDatabaseService.db.addActivityToInitialCloud(basic_act);
   NotesDatabaseService.db.addUserActivityToInitialCloud(basic_user_act);
  }
  Future<void> AddNotebook() async {
    NoteBookModel quicknote = new NoteBookModel(title: a_titleController.text,
        notes_num: 0,
        id: int.parse(id1Controller.text),
        isImportant: true,
        date: DateTime.now());
     NotesDatabaseService.db.addNotebookToInitailCloud(quicknote);

  }

  void AddCat() {

    CatModel newcat= new CatModel(id:int.parse(id1Controller.text),name: a_titleController.text,image:a_imageController.text,total: 0);
    NotesDatabaseService.db.addCatToInitialCloud(newcat);

  }


}
