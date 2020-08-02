import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/faderoute.dart';

import 'package:notes/data/theme.dart';
import 'package:notes/screens/TrackMaker.dart';

import 'package:notes/services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';


class trackSelector extends StatefulWidget {
  Function() triggerRefetch;
  Function(Brightness brightness) changeTheme;


  trackSelector(
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

class _AddQuestionState extends State<trackSelector> {
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
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [

            SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                backgroundColor:    Theme.of(context).scaffoldBackgroundColor,
                actions: <Widget>[

                ],
                leading: IconButton(
                  icon: const Icon(OMIcons.arrowBack,color: Colors.grey,),
                  tooltip: 'Add new entry',
                  onPressed: () { Navigator.pop(context);},
                ),
                expandedHeight: 150,
                pinned: true,
                primary:true,
                shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.only(bottomRight: Radius.circular(45.0),bottomLeft: Radius.circular(45.0)),

                ),
                flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "Custom Tracker",
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.grey),
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
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45.0),bottomRight:Radius.circular(45.0) ),
                        gradient: new LinearGradient(
                            colors: [
                              Colors.grey.withOpacity(.1),
                              Colors.grey.withOpacity(.2),
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(0.0)),
            ),

            child:AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: ListView(
                  physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 0),
                    padding: EdgeInsets.all(0),
                    height: 400,
                    decoration: new BoxDecoration(

                      borderRadius: new BorderRadius.all(
                         Radius.circular((30))),
                      gradient: new LinearGradient(
                          colors: [
                            Colors.blue[800].withOpacity(.7),
                            Colors.blue[900].withOpacity(.5),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Stack(children: <Widget>[


                      Image.asset(
                        'assets/images/learn.png',
                        width: double.infinity,
                        height:260,
                        fit: BoxFit.contain,
                      ),


                      Positioned(
                        top: 170,
                        left: 10,
                        width: MediaQuery.of(context).size.width-50,
                        height:220,
                        // Note: without ClipRect, the blur region will be expanded to full
                        // size of the Image instead of custom size
                        child: ClipRRect(
                          borderRadius:new BorderRadius.all(
                              Radius.circular((30))),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(.1),
                            ),
                          ),
                        ),
                      ),
                    Align(alignment: Alignment.bottomCenter,child:
                    Container(
                      margin: EdgeInsets.all( 10),
                      padding: EdgeInsets.all(20),
                      height: 220,
                      decoration: new BoxDecoration(

                        borderRadius: new BorderRadius.all(
                            Radius.circular((30))),
                        gradient: new LinearGradient(
                            colors: [
                              Colors.blue[100].withOpacity(.8),
                              Colors.blue[100].withOpacity(.6),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.00),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[



                            RichText(
                              overflow:TextOverflow.ellipsis ,
                              softWrap: true,
                              text: TextSpan(
                                text: 'New Skill to master ?\n',


                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 26,

                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                                children: <TextSpan>[

                                  TextSpan(
                                      text:
                                      'track the skill till you become a\nPRO at that.',

                              style: TextStyle(

                                          fontSize: 16, color: Colors.black54)),

                                ],
                              ),
                            ),
                          ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              margin: EdgeInsets.only( top:10),
                              padding: EdgeInsets.all(10),
                              height: 45,
                              decoration: new BoxDecoration(
                                border: Border.all(
                                    color: Colors.white70,width: 2),

                                borderRadius: new BorderRadius.all(
                                    Radius.circular((20))),
                                gradient: new LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                    Colors.transparent,
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 1.00),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child:InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        FadeRoute(
                                            page: trackMaker(
                                              changeTheme: setTheme,
                                              fromPath: 1,
                                            )));
                                    // scaleController.forward();
                                  },
                                  child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                Text("Track hours you put in ",style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87
                                ),),
                                Icon(Icons.arrow_forward_ios)
                              ],))),
                            Container(
                                margin: EdgeInsets.only( top:10),
                                padding: EdgeInsets.all(12),
                                height: 46,
                                decoration: new BoxDecoration(

                                  borderRadius: new BorderRadius.all(
                                      Radius.circular((20))),
                                  border: Border.all(
                                      color: Colors.white70,width: 2),
                                  gradient: new LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 1.00),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child:InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          FadeRoute(
                                              page: trackMaker(
                                                changeTheme: setTheme,
                                                fromPath: 2,
                                              )));
                                      // scaleController.forward();
                                    },
                                    child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Track the level you reached",style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87
                                    ),),
                                    Icon(Icons.arrow_forward_ios)
                                  ],))),


                          ],)
                      ],))),

                      ],),),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 0),
                    padding: EdgeInsets.all(0),
                    height: 370,
                    decoration: new BoxDecoration(

                      borderRadius: new BorderRadius.all(
                          Radius.circular((30))),
                      gradient: new LinearGradient(
                          colors: [
                            Colors.blue[300].withOpacity(.7),
                            Colors.blue[400].withOpacity(.5),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Stack(children: <Widget>[


                      Image.asset(
                        'assets/images/rating.png',
                        width: double.infinity,
                        height:210,
                        fit: BoxFit.contain,
                      ),


                      Positioned(
                        top: 160,
                        left: 10,
                        width: MediaQuery.of(context).size.width-50,
                        height:200,
                        // Note: without ClipRect, the blur region will be expanded to full
                        // size of the Image instead of custom size
                        child: ClipRRect(
                          borderRadius:new BorderRadius.all(
                              Radius.circular((30))),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(.1),
                            ),
                          ),
                        ),
                      ),
                      Align(alignment: Alignment.bottomCenter,child:
                      Container(
                          margin: EdgeInsets.all( 10),
                          padding: EdgeInsets.all(20),
                          height: 200,
                          decoration: new BoxDecoration(

                            borderRadius: new BorderRadius.all(
                                Radius.circular((30))),
                            gradient: new LinearGradient(
                                colors: [
                                  Colors.blue[100].withOpacity(.8),
                                  Colors.blue[100].withOpacity(.6),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 1.00),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[



                                Expanded(child:RichText(
                                  overflow:TextOverflow.ellipsis ,
                                  softWrap: true,
                                  text: TextSpan(
                                    text: 'Track your rating\nfor any event ?\n',


                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 26,

                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                    children: <TextSpan>[

                                      TextSpan(
                                          text:
                                          'As humans by default are judgmental\nuse it to track your progress',

                                          style: TextStyle(

                                              fontSize: 16, color: Colors.black54)),

                                    ],
                                  ),
                                )),
                              ],),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        FadeRoute(
                                            page: trackMaker(
                                              changeTheme: setTheme,
                                              fromPath: 3,
                                            )));
                                    // scaleController.forward();
                                  },
                                  child:Container(
                                    margin: EdgeInsets.only( top:10),
                                    padding: EdgeInsets.all(12),
                                    height: 45,
                                    decoration: new BoxDecoration(

                                      borderRadius: new BorderRadius.all(
                                          Radius.circular((30))),
                                      gradient: new LinearGradient(
                                          colors: [
                                            Colors.blue[100].withOpacity(.8),
                                            Colors.blue[100].withOpacity(.6),
                                          ],
                                          begin: const FractionalOffset(0.0, 0.0),
                                          end: const FractionalOffset(1.0, 1.00),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp),
                                    ),
                                    child:Icon(Icons.arrow_forward_ios))),



                              ],)
                          ],))),

                    ],),),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 0),
                    padding: EdgeInsets.all(0),
                    height: 370,
                    decoration: new BoxDecoration(

                      borderRadius: new BorderRadius.all(
                          Radius.circular((30))),
                      gradient: new LinearGradient(
                          colors: [
                            Colors.indigo.withOpacity(.7),
                            Colors.indigo.withOpacity(.5),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Stack(children: <Widget>[


                      Image.asset(
                        'assets/images/write.png',
                        width: double.infinity,
                        height:210,
                        fit: BoxFit.contain,
                      ),


                      Positioned(
                        top: 145,
                        left: 10,
                        width: MediaQuery.of(context).size.width-50,
                        height:215,
                        // Note: without ClipRect, the blur region will be expanded to full
                        // size of the Image instead of custom size
                        child: ClipRRect(
                          borderRadius:new BorderRadius.all(
                              Radius.circular((30))),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(.1),
                            ),
                          ),
                        ),
                      ),
                      Align(alignment: Alignment.bottomCenter,child:
                      Container(
                          margin: EdgeInsets.all( 10),
                          padding: EdgeInsets.all(20),
                          height: 215,
                          decoration: new BoxDecoration(

                            borderRadius: new BorderRadius.all(
                                Radius.circular((30))),
                            gradient: new LinearGradient(
                                colors: [
                                  Colors.blue[100].withOpacity(.8),
                                  Colors.blue[100].withOpacity(.6),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 1.00),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[



                                  Expanded(child:RichText(
                                    overflow:TextOverflow.ellipsis ,
                                    softWrap: true,
                                    text: TextSpan(
                                      text: 'Have some words of\nyour own to share ?\n',


                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontSize: 26,

                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                      children: <TextSpan>[

                                        TextSpan(
                                            text:
                                            'Words can sometimes describe\nemotions better than objective\nnumbers use them to track your life',

                                            style: TextStyle(

                                                fontSize: 16, color: Colors.black54)),

                                      ],
                                    ),
                                  ),),
                                ],),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            FadeRoute(
                                                page: trackMaker(
                                                  changeTheme: setTheme,
                                                  fromPath:4,
                                                )));
                                        // scaleController.forward();
                                      },
                                      child:Container(
                                      margin: EdgeInsets.only( top:10),
                                      padding: EdgeInsets.all(12),
                                      height: 45,
                                      decoration: new BoxDecoration(

                                        borderRadius: new BorderRadius.all(
                                            Radius.circular((30))),
                                        gradient: new LinearGradient(
                                            colors: [
                                              Colors.blue[100].withOpacity(.8),
                                              Colors.blue[100].withOpacity(.6),
                                            ],
                                            begin: const FractionalOffset(0.0, 0.0),
                                            end: const FractionalOffset(1.0, 1.00),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                      ),
                                      child:Icon(Icons.arrow_forward_ios))),



                                ],)
                            ],))),

                    ],),),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 0),
                    padding: EdgeInsets.all(0),
                    height: 370,
                    decoration: new BoxDecoration(

                      borderRadius: new BorderRadius.all(
                          Radius.circular((30))),
                      gradient: new LinearGradient(
                          colors: [
                            Colors.blueGrey.withOpacity(.7),
                            Colors.blueGrey.withOpacity(.5),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Stack(children: <Widget>[


                      Image.asset(
                        'assets/images/options.png',
                        width: double.infinity,
                        height:210,
                        fit: BoxFit.contain,
                      ),


                      Positioned(
                        top: 160,
                        left: 10,
                        width: MediaQuery.of(context).size.width-50,
                        height:200,
                        // Note: without ClipRect, the blur region will be expanded to full
                        // size of the Image instead of custom size
                        child: ClipRRect(
                          borderRadius:new BorderRadius.all(
                              Radius.circular((30))),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(.1),
                            ),
                          ),
                        ),
                      ),
                      Align(alignment: Alignment.bottomCenter,child:
                      Container(
                          margin: EdgeInsets.all( 10),
                          padding: EdgeInsets.all(20),
                          height: 200,
                          decoration: new BoxDecoration(

                            borderRadius: new BorderRadius.all(
                                Radius.circular((30))),
                            gradient: new LinearGradient(
                                colors: [
                                  Colors.blue[100].withOpacity(.8),
                                  Colors.blue[100].withOpacity(.6),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 1.00),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[



                                  Expanded(child:RichText(
                                    overflow:TextOverflow.ellipsis ,
                                    softWrap: true,
                                    text: TextSpan(
                                      text: 'Track your choices\nto any event ?\n',


                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontSize: 26,

                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                      children: <TextSpan>[

                                        TextSpan(
                                            text:
                                            'Choices can be hard and confusing\nBut tracking them shouldn’t be',

                                            style: TextStyle(

                                                fontSize: 16, color: Colors.black54)),

                                      ],
                                    ),
                                  )),
                                ],),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[

                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          FadeRoute(
                                              page: trackMaker(
                                                changeTheme: setTheme,
                                                fromPath: 5,
                                              )));
                                      // scaleController.forward();
                                    },
                                    child:Container(
                                      margin: EdgeInsets.only( top:10),
                                      padding: EdgeInsets.all(12),
                                      height: 45,
                                      decoration: new BoxDecoration(

                                        borderRadius: new BorderRadius.all(
                                            Radius.circular((30))),
                                        gradient: new LinearGradient(
                                            colors: [
                                              Colors.blue[100].withOpacity(.8),
                                              Colors.blue[100].withOpacity(.6),
                                            ],
                                            begin: const FractionalOffset(0.0, 0.0),
                                            end: const FractionalOffset(1.0, 1.00),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                      ),
                                      child:Icon(Icons.arrow_forward_ios))),



                                ],),

                            ],))),

                    ],),),


                  SizedBox(height: 20,),


                ],
              ),
              margin: EdgeInsets.only(top: 2),
              padding: EdgeInsets.only(left: 15, right: 15),
            ),)),
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