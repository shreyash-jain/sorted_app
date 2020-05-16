import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/services/auth.dart';
import 'package:notes/services/sharedPref.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  SettingsPage({Key key, Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme;
  SharedPreferences prefs;
  FocusNode BudgetFocus = FocusNode();
  TextEditingController BudgetTitle = TextEditingController();
  int selected_currency=1;
  int edit=0;
  String g_name="Shreyash",g_email="shreyash.jain.eee15@itbhu.ac.in";
  String budget="10000";
  var isSwitched=false;

  var _budgetController;
  int min=15;

  String mins="15 mins";

  initiatePref() async {
    prefs = await SharedPreferences.getInstance();
    bool biometric = prefs.getBool('biometric');
    if (prefs.getString('google_name')!=null)
    g_name=prefs.getString('google_name');
    if (prefs.getString('google_email')!=null)
    g_email=prefs.getString('google_email');
    if (biometric==null || biometric==false)
      setState(() {
        isSwitched=false;
      });

    else  setState(() {
      isSwitched=true;
    });

  }

  @override
  void initState() {
    initiatePref();
    super.initState();


  }
  @override
  Widget build(BuildContext context) {

    setState(() {
      if (Theme.of(context).brightness == Brightness.dark) {
        selectedTheme = 'dark';
      } else {
        selectedTheme = 'light';
      }
    });

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding:
                        const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Icon(OMIcons.arrowBack)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                child: buildHeaderWidget(context),
              ),
              buildCardWidget(

                  Stack(children: <Widget>[
                    Padding(padding: EdgeInsets.only(top:30,left: 170),child:Icon(Icons.lock_open,color: Colors.grey.withOpacity(.05),size: 300,),
                    ),
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('General Settings',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 30,
                              fontWeight:FontWeight.bold
                          )),
                      Container(
                        height: 20,
                      ),
                      Text('Theme',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 'light',
                            groupValue: selectedTheme,
                            onChanged: handleThemeSelection,
                          ),
                          Text(
                            'Light theme',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 'dark',
                            groupValue: selectedTheme,
                            onChanged: handleThemeSelection,
                          ),
                          Text(
                            'Dark theme',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Text('Biometric Lock',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 20,
                      ),
                      Row (children: <Widget>[

                        Container(
                          width: 60,
                          child:   Switch(

                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;

                                if (isSwitched)
                                  prefs.setBool('biometric',true);

                                else prefs.setBool('biometric',false);

                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],)
                    ],
                  )],)),
              buildCardWidget(

                Stack(children: <Widget>[
                Padding(padding: EdgeInsets.only(top:30,left: 170),child:Icon(OMIcons.accountBox,color: Colors.grey.withOpacity(.05),size: 300,),
              ), Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Account Settings',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 30,
                              fontWeight:FontWeight.bold
                          )),
                      Container(
                        height: 20,
                      ),
                      Text('User',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 24,
                              color: Theme.of(context).primaryColor)),
                      Container(
                        height: 12,
                      ),

                      Container(
                          margin: EdgeInsets.only(top:0,left:00),
                          padding: EdgeInsets.only(left:0,top:0),



                          decoration:
                          new BoxDecoration(
                            borderRadius: new BorderRadius.only( topRight:Radius.circular(0.0),topLeft: Radius.circular(20.0), bottomLeft:Radius.circular(0.0),bottomRight:Radius.circular(20.0)),



                          ),


                          child:Text(g_name, textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize:22.0,


                            color: Colors.grey.withOpacity(.8),
                          ),)


                      ),
                      Container(
                          margin: EdgeInsets.only(top:0,left:00),
                          padding: EdgeInsets.only(left:0,top:0),



                          decoration:
                          new BoxDecoration(
                            borderRadius: new BorderRadius.only( topRight:Radius.circular(0.0),topLeft: Radius.circular(20.0), bottomLeft:Radius.circular(0.0),bottomRight:Radius.circular(20.0)),



                          ),


                          child:Text(g_email, textAlign:TextAlign.center,style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize:16.0,
                            fontWeight: FontWeight.bold,


                            color: Colors.grey.withOpacity(.6),
                          ),)



                      ),
                      Container(
                        height:10,
                      ),
                MaterialButton(
                  onPressed: () => authService.signOut(),
                  color: Colors.red.withOpacity(.8),
                  shape: RoundedRectangleBorder(

                      borderRadius: new BorderRadius.circular(18.0),


                     ),
                  textColor: Colors.white,
                  child: Text('Signout',style: TextStyle(
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
                      Row (children: <Widget>[

                        Container(
                          width: 60,
                          child:   Switch(

                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;

                                if (isSwitched)
                                  prefs.setBool('biometric',true);

                                else prefs.setBool('biometric',false);

                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],)
                    ],
                  )]),),
              buildCardWidget(
                Stack(children: <Widget>[
                  Padding(padding: EdgeInsets.only(top:30,left: 170),child:Icon(OMIcons.questionAnswer,color: Colors.grey.withOpacity(.05),size:350,),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Survey Settings',
                          style: TextStyle(
                              fontFamily: 'ZillaSlab',
                              fontSize: 30,
                              fontWeight:FontWeight.bold
                          )),
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
                      Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[


                            new ButtonTheme(
                              minWidth: 10,
                              height: 50,
                              buttonColor: Colors.transparent,




                              child:RaisedButton(



                                shape: RoundedRectangleBorder(

                                    borderRadius: new BorderRadius.circular(18.0),


                                    side: BorderSide(color:(selected_currency==1)?Theme.of(context).primaryColor:Colors.transparent)),
                                // color: Theme.of(context).primaryColor,

                                color: Theme.of(context).scaffoldBackgroundColor,




                                child: new Text("Fill AI Generated Answer", textAlign:TextAlign.center,style: TextStyle(
                                    fontFamily: 'ZillaSlab',


                                    fontSize:16)),
                                onPressed: (){

                                  setState(() {
                                    selected_currency=1;
                                  });

                                },
                              ),),
                            SizedBox(height: 8,),
                            new ButtonTheme(
                              minWidth: 10,
                              height: 50,
                              buttonColor: Colors.transparent,




                              child:RaisedButton(



                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(18.0),


                                    side: BorderSide(color:(selected_currency==2)?Theme.of(context).primaryColor:Colors.transparent)),

                                color: Theme.of(context).scaffoldBackgroundColor,




                                child: new Text("Skip those days from analysis", textAlign:TextAlign.center,style: TextStyle(
                                    fontFamily: 'ZillaSlab',

                                    fontSize:16)),
                                onPressed: (){
                                  setState(() {
                                    selected_currency=2;
                                  });

                                },
                              ),),

                      ],),

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

                      Row (children: <Widget>[

                        ButtonBar(
                          mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                          children: <Widget>[
                            new ButtonTheme(
                              minWidth: 10,
                              height: 40,
                              buttonColor: Colors.transparent,




                              child:RaisedButton(



                                shape: RoundedRectangleBorder(

                                    borderRadius: new BorderRadius.circular(18.0),


                                    side: BorderSide(color:Colors.transparent)),
                                // color: Theme.of(context).primaryColor,

                                color: Theme.of(context).scaffoldBackgroundColor,




                                child: new Text("+", textAlign:TextAlign.center,style: TextStyle(
                                    fontFamily: 'ZillaSlab',

                                    fontWeight: FontWeight.bold,
                                    fontSize:32)),
                                onPressed: (){

                                  setState(() {
                                   if (min<30) min++;
                                    mins=min.toString()+" mins";
                                    if (min==30){
                                      mins="30+ mins";
                                    }

                                  });

                                },
                              ),),

                            Padding(
                              padding: const EdgeInsets.only(top: 0.0, bottom:00,left: 20,right: 20),
                              child: Text(
                                mins,
                                style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 20),
                              ),
                            ),
                            new ButtonTheme(
                              minWidth: 10,
                              height: 40,
                              buttonColor: Colors.transparent,




                              child:RaisedButton(



                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(18.0),


                                    side: BorderSide(color:Colors.transparent)),

                                color: Theme.of(context).scaffoldBackgroundColor,




                                child: new Text("-", textAlign:TextAlign.center,style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.bold,
                                    fontSize:32)),
                                onPressed: (){
                                  setState(() {
                                    if (min>10) min--;
                                    mins=min.toString()+" mins";
                                    if (min==10){
                                      mins="10- mins";
                                    }

                                  });

                                },
                              ),),

                          ],
                        ),

                      ],),


                    ],
                  )]),),
              buildCardWidget(
                Stack(children: <Widget>[
                Padding(padding: EdgeInsets.only(top:30,left: 170),child:Icon(OMIcons.money,color: Colors.grey.withOpacity(.05),size: 300,),
              ),
                  Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Expense Settings',
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 30,
                          fontWeight:FontWeight.bold
                      )),
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
                  Row (children: <Widget>[

                    ButtonBar(
                      mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        new ButtonTheme(
                          minWidth: 10,
                          height: 50,
                          buttonColor: Colors.transparent,




                          child:RaisedButton(



                            shape: RoundedRectangleBorder(

                                borderRadius: new BorderRadius.circular(18.0),


                                side: BorderSide(color:(selected_currency==1)?Theme.of(context).primaryColor:Colors.transparent)),
                           // color: Theme.of(context).primaryColor,

                            color: Theme.of(context).scaffoldBackgroundColor,




                            child: new Text("₹", textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'ZillaSlab',

                                fontWeight: FontWeight.bold,
                                fontSize:32)),
                            onPressed: (){

                              setState(() {
                                selected_currency=1;
                              });

                            },
                          ),),
                        new ButtonTheme(
                          minWidth: 10,
                          height: 50,
                          buttonColor: Colors.transparent,




                          child:RaisedButton(



                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),


                                side: BorderSide(color:(selected_currency==2)?Theme.of(context).primaryColor:Colors.transparent)),

                            color: Theme.of(context).scaffoldBackgroundColor,




                            child: new Text("\$", textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontWeight: FontWeight.bold,
                                fontSize:32)),
                            onPressed: (){
                              setState(() {
                                selected_currency=2;
                              });

                            },
                          ),),
                        new ButtonTheme(
                          minWidth: 10,
                          height: 50,
                          buttonColor: Colors.transparent,




                          child:RaisedButton(



                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),


                                side: BorderSide(color:(selected_currency==3)?Theme.of(context).primaryColor:Colors.transparent)),
                            color: Theme.of(context).scaffoldBackgroundColor,




                            child: new Text("€", textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'ZillaSlab',

                                fontWeight: FontWeight.bold,
                                fontSize:32)),
                            onPressed: (){

                              setState(() {
                                selected_currency=3;
                              });
                            },
                          ),),
                        new ButtonTheme(
                          minWidth: 10,
                          height: 50,
                          buttonColor: Colors.transparent,




                          child:RaisedButton(



                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),


                                side: BorderSide(color:(selected_currency==4)?Theme.of(context).primaryColor:Colors.transparent)),
                            color: Theme.of(context).scaffoldBackgroundColor,




                            child: new Text("£", textAlign:TextAlign.center,style: TextStyle(
                                fontFamily: 'ZillaSlab',

                                fontWeight: FontWeight.bold,
                                fontSize:32)),
                            onPressed: (){
                              setState(() {
                                selected_currency=4;
                              });


                            },
                          ),),
                      ],
                    ),
                  ],),

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

                  Row (children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0,left: 20),
                      child: Text(
                        budget,
                        style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                      ),
                    ),
                    if(edit==0)
                      GestureDetector(
                          onTap: (){setState(() {
                            edit=1;
                          });},
                          child:Padding(
                            padding: const EdgeInsets.only(top: 4.0, bottom:4.0,left: 20),
                            child: Icon(Icons.edit),
                          )),

                  ],),

                  if (edit==1)Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0,left: 20),
                    child: TextField(

                      focusNode: BudgetFocus,

                      controller: BudgetTitle,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      maxLines: 1,

                      onSubmitted: (text) {
                    setState(() {
                      edit=0;
                      budget=BudgetTitle.text;
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
                        hoverColor:Colors.black ,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                            fontFamily: 'ZillaSlab',
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    )
                  )
                ],
              )]),),
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
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'Shreyash Jain\n\nSuchit Sahoo',
                          style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                        ),
                      )),

                  Container(
                    height: 30,
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
          color: (Theme.of(context).brightness == Brightness.dark)?Theme.of(context).dialogBackgroundColor.withOpacity(.5):Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: Colors.black.withAlpha(30),
                blurRadius: 16)
          ]),
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(16),
      child: child,
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 16, left: 8),
      child: Text(
        'Settings',
        style: TextStyle(
            fontFamily: 'ZillaSlab',
            fontWeight: FontWeight.w700,
            fontSize: 36,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  void handleThemeSelection(String value) {
    setState(() {
      selectedTheme = value;
    });
    if (value == 'light') {
      widget.changeTheme(Brightness.light);
    } else {
      widget.changeTheme(Brightness.dark);
    }
    setThemeinSharedPref(value);
  }


}
