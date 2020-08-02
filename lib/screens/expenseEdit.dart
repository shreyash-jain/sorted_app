import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/data/date.dart';
import 'package:notes/data/eCat.dart';
import 'package:notes/data/expense.dart';
import 'package:notes/data/friend.dart';
import 'package:notes/data/models.dart';
import 'package:notes/services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

  class expenseEdit extends StatefulWidget {
  Function() triggerRefetch;
  ExpenseModel existingExpense;
  expenseEdit({Key key, Function() triggerRefetch, ExpenseModel existingExpense})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingExpense = existingExpense;
  }
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<expenseEdit> {
  bool isDirty = false;
  bool isNoteNew = true;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  List<CatModel> catsList = [];
  List<FriendModel> friendsList = [];

  ExpenseModel currentExpense;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int expense_type=1;

  FocusNode expenseTitleFocus = FocusNode();
  FocusNode expenseContentFocus = FocusNode();
  FocusNode expenseMoneyFocus = FocusNode();
  TextEditingController expenseTitle = TextEditingController();
  TextEditingController expenseContent = TextEditingController();
  TextEditingController expenseMoney = TextEditingController();
  TextEditingController FriendName = TextEditingController();
  FocusNode FriendNameFocus = FocusNode();
  int chosen_expense_cat=11;
  int chosen_friend=0;

  @override
  void initState() {
    super.initState();
    setQuesFromDB();
    if (widget.existingExpense == null) {
      currentExpense = new ExpenseModel(title: "",type: 1,friend_id: 0,cat_id:0,date_id:0,content:"",money: 0,date: DateTime.now() );
      isNoteNew = true;
    } else {
      currentExpense = widget.existingExpense;
      isNoteNew = false;
    }

    expenseTitle.text=currentExpense.title;
    if (currentExpense.money!=0)
    expenseMoney.text=currentExpense.money.toString();
    expenseContent.text=currentExpense.content;

    if (currentExpense.cat_id!=0){
      chosen_friend=currentExpense.cat_id-1;
      expense_type=1;
    }
    else if (currentExpense.friend_id!=0){
      chosen_friend=currentExpense.friend_id-1;
      expense_type=2;
    }


  }
  setQuesFromDB() async {



    var fetchedCats= await NotesDatabaseService.db.getCatsFromDB();
    var fetchedFriends= await NotesDatabaseService.db.getFriendsDB();

    setState(() {
      catsList=fetchedCats;

      friendsList=fetchedFriends;

    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(padding: EdgeInsets.only(top:84),child:AnimatedContainer(
              alignment: Alignment.center,
              duration: Duration(milliseconds: 400),

              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.2), width: 1),
                  borderRadius:  BorderRadius.all( Radius.circular(30.0) ),
                  color: Colors.grey.withOpacity(.2)
              ),
            height:53,

              child:Row(children: <Widget>[

               Container(


                  child:Padding(
                    padding: EdgeInsets.only(left:0,),
                    child: Align(

                      alignment: Alignment.center,
                      child:RaisedButton(
                        onPressed:(){
                          print("hello");

                          setState(() {
                            expense_type=1;

                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),

                        ),


                        color: (expense_type==1)?Theme.of(context).primaryColor:Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.all(12),
                        child: new Text(
                          "For self",style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 20,



                            fontWeight: FontWeight.w600),
                        ),
                      ),),),),
               Container(

                  child:Padding(
                    padding: EdgeInsets.only(right:0,left: 2),
                    child: Align(

                      alignment: Alignment.center,
                      child:RaisedButton(
                        onPressed:(){
                          setState(() {
                            expense_type=2;

                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),

                        ),


                        color: (expense_type==2)?Theme.of(context).primaryColor:Colors.transparent,

                        elevation: 0,
                        padding: const EdgeInsets.all(12),
                        child: new Text(
                          "For Friend",style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 20,



                            fontWeight: FontWeight.w600),
                        ),
                      ),),),)
              ],))),
        ],),


        Padding(padding: EdgeInsets.only(top:120),child:

        ListView(
          children: <Widget>[


            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 0, right: 0, top: 0),

                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                          ]
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 4.0, left: 8, bottom: 4, right: 8),
                        child: TextField(

                          focusNode: expenseTitleFocus,

                          controller: expenseTitle,
                          keyboardType: TextInputType.multiline,
                          maxLength: 20,
                          maxLines: 1,
                          onChanged: markTitleAsDirty,
                          onSubmitted: (text) {
                            expenseTitleFocus.unfocus();

                          },
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 28,



                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration.collapsed(
                            hintText: 'Enter expense title',
                            focusColor: Colors.black,
                            hoverColor:Colors.black ,
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 28,
                                fontFamily: 'ZillaSlab',
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                          ),
                        ),),),


                    SizedBox(height: 10,),
                    Row(children: <Widget>[
                      Container(
                        width: 50,
                          margin: EdgeInsets.only(left: 0, right: 0, top: 8,bottom: 4),

                          decoration: BoxDecoration(

                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                              ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 2, left: 8, bottom: 2, right: 8),
                            child: Text("₹", textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 28,


                                fontWeight: FontWeight.w500)),)),
                      Container(
                        width: MediaQuery.of(context).size.width-110,
                          margin: EdgeInsets.only(left: 20, right: 0, top: 8,bottom: 4),

                          decoration: BoxDecoration(

                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                              ]
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 2, left: 8, bottom: 2, right: 8),
                            child: TextField(

                              focusNode: expenseMoneyFocus,

                              controller:expenseMoney,
                              keyboardType: TextInputType.number,

                              maxLines:1,
                              onChanged: markMoneyAsDirty,
                              onSubmitted: (text) {
                                expenseMoneyFocus.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 22,


                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter amount in Rs',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 22,
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                              ),
                            ),)),

                    ],),
                    SizedBox(height: 10,),
                    if(expense_type==1)Container(
                      height:100,
                      child: FadeAnimation(1.6, Container(

                        child:ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: catsList.length ,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {

                              return _buildCats(
                                  index,
                                  catsList[index]
                              );

                            }
                        ),)),
                    ),
                    if(expense_type==2)Container(
                      height:70,
                      child: FadeAnimation(1.2, Container(

                        child:ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: friendsList.length +1 ,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {

                              if (index==0){
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {


                                      _settingModalBottomSheet(context);
                                    });
                                  },
                                  child: Padding(

                                    padding:EdgeInsets.all(0),child:

                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
                                    height: 50,

                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
                                      borderRadius:  BorderRadius.all( Radius.circular(10.0) ),

                                    ),

                                    child: Stack(

                                      children: <Widget>[


                                        Padding(
                                          padding: EdgeInsets.only(right:8,left:8),

                                          child:Align(

                                            alignment: Alignment.center,
                                            child: Text(
                                              "Add a friend + ",
                                              style: TextStyle(

                                                  fontFamily: 'ZillaSlab',
                                                  fontSize: 20,

                                                  fontWeight: FontWeight.w500),

                                            ),),
                                        ),



                                      ],
                                    ),
                                  ),),
                                );
                              }

                              return _buildFriends(
                                  index - 1,
                                  friendsList[index - 1]
                              );

                            }
                        ),)),
                    ),
                    SizedBox(height: 6,),
                    Container(
                        margin: EdgeInsets.only(left: 0, right: 0, top: 8,bottom: 8),

                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                            ]
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 8, left: 8, bottom: 0, right: 8),
                          child: TextField(

                            focusNode: expenseContentFocus,

                            controller:expenseContent,
                            keyboardType: TextInputType.multiline,

                            maxLines:4,
                            onSubmitted: (text) {
                              expenseContentFocus.unfocus();
                            },
                            textInputAction: TextInputAction.done,
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 22,


                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Enter a discription',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22,
                                  fontFamily: 'ZillaSlab',
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                            ),
                          ),)),

                  ]
              ),),


          ],
        ),),
        ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: handleBack,
                      ),
                      Spacer(),

                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () {
                          handleDelete();
                        },
                      ),
                      AnimatedContainer(
                        margin: EdgeInsets.only(left: 10),
                        duration: Duration(milliseconds: 100),
                        width: (isDirty && expenseTitle.text!="" && expenseMoney.text!="" ) ? 150 : 0,
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
                            style: TextStyle(letterSpacing: 0),
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
  void _settingModalBottomSheet(context) {
    FriendModel new_frd=new FriendModel(name: "",total: 0);
    showModalBottomSheet(

        context: context,

        builder: (BuildContext bc) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: 0,
                  left: 0,
                  top: 0),
              child:Container(

                alignment: Alignment.topCenter,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft:Radius.circular((48 * .3)),
                    topRight: Radius.circular((48 * .3)),
                  ),
                  color:Theme.of(context).primaryColor,
                ),
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 0,
                          left: 20,
                          top: 20),
                      child: TextField(
                        focusNode: FriendNameFocus,

                        controller: FriendName,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onSubmitted: (text) async {
                          FriendNameFocus.unfocus();
                          new_frd.name=FriendName.text;
                          await NotesDatabaseService.db.addFriend(new_frd);
                          friendsList.add(new_frd);
                          chosen_friend=friendsList.length-1;
                          Navigator.pop(context);
                        },
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 28,
                            color: Colors.white60,
                            fontWeight: FontWeight.w700),
                        decoration: InputDecoration.collapsed(
                          hintText: 'type your friend name',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize:28,
                              fontFamily: 'ZillaSlab',
                              fontWeight: FontWeight.w700),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        new RaisedButton(
                          child: new Text('Add'),
                          onPressed: () async {
                            FriendNameFocus.unfocus();
                            new_frd.name=FriendName.text;
                            await NotesDatabaseService.db.addFriend(new_frd);
                            friendsList.add(new_frd);
                            chosen_friend=friendsList.length-1;
                            Navigator.pop(context);
                          },
                        ),
                        new RaisedButton(
                            child: new Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
  void handleSave() async {

    currentExpense.title=expenseTitle.text;
    currentExpense.content=expenseContent.text;
    currentExpense.money=double.parse(expenseMoney.text);
    if (expense_type==1){
      currentExpense.cat_id=chosen_expense_cat+1;
      if (chosen_expense_cat==-1)  currentExpense.cat_id=12;
      currentExpense.friend_id=0;
      currentExpense.type=1;


    }

    else {
      currentExpense.cat_id=0;
      currentExpense.friend_id=chosen_friend+1;
      currentExpense.type=2;
    }




    setState(() {

    });
    if (isNoteNew) {



      DateModel this_date;
      var formatter = new DateFormat('dd-MM-yyyy');
      String formatted_date = formatter.format(DateTime.now());
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
          currentExpense.date_id = this_date.id;
        });
        print("here 2  ");
      } else {
        currentExpense.date_id = this_date.id;
      }

      print(currentExpense.date);
      await NotesDatabaseService.db.addExpense(currentExpense);


    } else {
      await NotesDatabaseService.db.updateExpensesInDB(currentExpense);
    }
    setState(() {
      isNoteNew = false;
      isDirty = false;
      expenseTitle.clear();
      expenseMoney.clear();
      expenseContent.clear();
      expenseContentFocus.unfocus();
      expenseMoneyFocus.unfocus();
      expenseTitleFocus.unfocus();
      expense_type=0;
    });
    Navigator.pop(context);
    if (widget.triggerRefetch!=null)
    widget.triggerRefetch();

  }

  void markTitleAsDirty(String title) {
    setState(() {
      isDirty = true;
    });
  }

  void markMoneyAsDirty(String content) {
    setState(() {
      isDirty = true;
    });
  }
  void markCatAsDirty() {
    setState(() {
      isDirty = true;
    });
  }

  Widget _buildCats(int index,
      CatModel this_cat) {
    String count= "";
    String image=this_cat.image;

    return GestureDetector(
      onTap: () {
        setState(() {
          markCatAsDirty();
          chosen_expense_cat=index;

        });
      },
      child: Padding(

        padding:EdgeInsets.all(0),child:

      Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
        height: 120,

        decoration: BoxDecoration(
          color: (chosen_expense_cat==index)?Colors.grey.withOpacity(0.3):Colors.transparent,
          border: Border.all(color: (chosen_expense_cat==index)?Theme.of(context).primaryColor:Colors.grey.withOpacity(0.3), width: 3),
          borderRadius:  BorderRadius.all( Radius.circular(10.0) ),

        ),

        child: Stack(

          children: <Widget>[

            Container(
              padding: EdgeInsets.only(top:2,right:8,left:8),




              child:Icon(toic(image),size: 50,),
            ),
            Padding(
              padding: EdgeInsets.only(top:14,right:8,left:8),

              child:Align(

                alignment: Alignment.bottomLeft,
                child: Text(
                  this_cat.name,
                  style: TextStyle(

                      fontFamily: 'ZillaSlab',
                      fontSize: 20,

                      fontWeight: FontWeight.w500),

                ),),
            ),



          ],
        ),
      ),),
    );
  }
  Widget _buildFriends(int index,
      FriendModel this_cat) {
    String count= "";


    return GestureDetector(
      onTap: () {
        setState(() {

          markCatAsDirty();
          chosen_friend=index;

        });
      },
      child: Padding(

        padding:EdgeInsets.all(0),child:

      Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
        height: 120,

        decoration: BoxDecoration(
          color: (chosen_friend==index)?Colors.grey.withOpacity(0.3):Colors.transparent,
          border: Border.all(color: (chosen_friend==index)?Theme.of(context).primaryColor:Colors.grey.withOpacity(0.3), width: 3),

          borderRadius:  BorderRadius.all( Radius.circular(10.0) ),

        ),

        child: Stack(

          children: <Widget>[


            Padding(
              padding: EdgeInsets.only(right:8,left:8),

              child:Align(

                alignment: Alignment.center,
                child: Text(
                  this_cat.name,
                  style: TextStyle(

                      fontFamily: 'ZillaSlab',
                      fontSize: 20,

                      fontWeight: FontWeight.w500),

                ),),
            ),



          ],
        ),
      ),),
    );
  }
  IconData toic(String str){


    if (str=="Icons.restaurant") return (Icons.restaurant);
    else  if (str=="Icons.receipt") return (Icons.receipt);
    else if (str=="Icons.movie_filter") return (Icons.movie_filter);
    else  if (str=="Icons.healing") return (Icons.healing);
    else if (str=="Icons.directions_bus") return (Icons.directions_bus);
    else  if (str=="Icons.ev_station") return (Icons.ev_station);
    else  if (str=="Icons.local_atm") return (Icons.local_atm);
    else  if (str=="Icons.trending_up") return (Icons.trending_up);
    else  if (str=="Icons.home") return (Icons.home);
    else  if (str=="Icons.library_books") return (Icons.library_books);
    else  if (str=="Icons.scatter_plot") return (Icons.scatter_plot);

    else return Icons.scatter_plot;
  }

  void handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text('Delete Note'),
              content: Text('This note will be deleted permanently'),
              actions: <Widget>[
                FlatButton(
                  child: Text('DELETE',
                      style: prefix0.TextStyle(
                          color: Colors.red.shade300,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1)),
                  onPressed: () async {
                   // await NotesDatabaseService.db.deleteNoteInDB(currentNote);
                    if( widget.triggerRefetch()!=null)
                    widget.triggerRefetch();
                    Navigator.pop(context);
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
    }
  }

  void handleBack() {
    Navigator.pop(context);
  }
}
