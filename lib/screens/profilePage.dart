
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/LibraryCards.dart';
import 'package:notes/components/bookcards.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/activity.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/data/user_activity.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/screens/home.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'QuestionForm.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/bookcards.dart';

class ProfilePage extends StatefulWidget {
  Function() triggerRefetch;
  Function(Brightness brightness) changeTheme;

  ProfilePage(
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

class _AddQuestionState extends State<ProfilePage> {
  PageController _pageController;
  ThemeData theme = appThemeLight;
  bool isFlagOn = false;
  int _selectedIndex;
  String google_url="";
  List<QuestionModel> quesList = [];
  TextEditingController searchController = TextEditingController();
  QuestionModel currentQues;
  String name="Shreyash";
  int edit_activity=0;
  String user_image='assets/images/male1.png';
  bool isSearchEmpty = true;
  bool headerShouldHide = false;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  SharedPreferences prefs;
  Shader linearGradient;
  List< ActivityModel> AllActivityList =[];
  List< UserAModel> AllUserActivityList =[];
  List<int> activity_position;
  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    initiatePref();
    get_UserActivityModel();

  }
  initiatePref() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_name')!=null) name=prefs.getString('user_name');
    if (prefs.getString('user_image')!=null) user_image=prefs.getString('user_image');

    if (prefs.getString('google_image')!=null) google_url=prefs.getString('google_image');
  }

  get_UserActivityModel() async {
    var fetchedDate = await NotesDatabaseService.db.getUserActiviyAfterFromDB(6);
    setState(() {
      AllUserActivityList = fetchedDate;

    });
    print(AllUserActivityList.length);

    get_ActivityModel();
  }

  get_ActivityModel() async {
    var fetchedDate = await NotesDatabaseService.db.getActiviyAfterFromDB(6);
    setState(() {
      AllActivityList = fetchedDate;
     List<int> already=[];
      for (int i=0;i<AllUserActivityList.length;i++){

       if (!already.contains(AllUserActivityList[i].a_id)) already.add(AllUserActivityList[i].a_id);

      }

      int start=0;
      int end=AllActivityList.length;
      while(start<end){
        if (already.contains(AllActivityList[start].id)){
          AllActivityList.removeAt(start);
          end--;
        }
        else {
          start++;
        }

      }

      activity_position=new List<int>.filled(AllActivityList.length, 0, growable: true);


    });
  }
  List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.red,
    Colors.cyan,
    Colors.teal,
    Colors.amber.shade900,
    Colors.deepOrange
  ];
  @override
  Widget build(BuildContext context) {
    linearGradient=LinearGradient(
        colors: [
          const Color(0xFF00c6ff),
          Theme
              .of(context)
              .primaryColor,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 1.00),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
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

                expandedHeight: 80,
                pinned: true,
                primary:true,
                shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.only(bottomRight: Radius.circular(16.0),bottomLeft: Radius.circular(16.0)),

                ),
                flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "My Profile",
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        color: Colors.blueGrey
                          ),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),


                    background: Container(
                      padding: EdgeInsets.only(top:40,left:20,right: 20),
                      child:Container(
                          decoration: BoxDecoration(
                            color:  Theme
                                .of(context)
                                .scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30) ),
                          ),
                          width: MediaQuery.of(context).size.width-80,

                          alignment: Alignment.center,



                          child:
                          Row(

                            children: <Widget>[



                          ],)
                      ),
                      decoration: new BoxDecoration(

                        gradient: new LinearGradient(
                            colors: [
                              const Color(0xFF00c6ff),
                              Theme
                                  .of(context)
                                  .primaryColor,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.00),
                            stops: [0.0, 1.0],
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(0)),
            ),

            child:AnimatedContainer(
              duration: Duration(milliseconds: 200),

              child:MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView(

                children: <Widget>[
                  Container(

                    margin: EdgeInsets.only(left: 20,right:20),

                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              const Color(0xFF00c6ff),
                              Theme
                                  .of(context)
                                  .primaryColor,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.00),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight:Radius.circular(30) ),
                      ),
                      child:
                      Column(children: <Widget>[

                        SizedBox(height: 16,),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[




                                Hero(
                                    tag: "DemoTag",
                                    transitionOnUserGestures: true,
                                    child:Padding(
                                      padding :EdgeInsets.only(right:20,bottom: 10),
                                      child:Stack(children: <Widget>[

                                        Image(
                                          image: AssetImage(
                                            user_image,
                                          ),
                                          height:100,
                                          width:100,
                                        ),
                                        Padding(
                                            padding :EdgeInsets.only(right:0),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                google_url,
                                              ),
                                              radius: 50,
                                              backgroundColor: Colors.transparent,
                                            )),




                                      ],),)),

                              ],),
                            Padding(
                                padding: EdgeInsets.only(left: 4),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(name,
                                      style: TextStyle(
                                          fontFamily: 'ZillaSlab',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45
                                      ),
                                      textAlign: TextAlign.left,),


                                    SizedBox(height: 8,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[


                                        Text("Level  " ,
                                          style: TextStyle(
                                              fontFamily: 'ZillaSlab',
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black45
                                          ),
                                          textAlign: TextAlign.left,),

                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(

                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.all(Radius.circular(30) ),
                                          ),

                                          child:Text("5",

                                          style: TextStyle(
                                              fontFamily: 'ZillaSlab',
                                              fontSize:16.0,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white70
                                          ),
                                          textAlign: TextAlign.center,),),

                                      ],),

                                    SizedBox(height: 8,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[


                                        Text("Sheldon ",

                                          style: TextStyle(
                                              fontFamily: 'ZillaSlab',
                                              fontSize:16.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white60
                                          ),
                                          textAlign: TextAlign.left,),

                                        Text("from tbbt",

                                          style: TextStyle(
                                              fontFamily: 'ZillaSlab',
                                              fontSize:14.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white60
                                          ),
                                          textAlign: TextAlign.left,),

                                      ],),

],)),
                          ],),
                        SizedBox(height: 16,),
                      ],)


                  ),
                  SizedBox(height: 24,),
                  Container(

                      margin: EdgeInsets.only(left: 20,right:20),

                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              const Color(0xFF00c6ff),
                              Theme
                                  .of(context)
                                  .primaryColor,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.00),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.all( Radius.circular(30) ),
                      ),
                      child:Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.all( Radius.circular(30) ),
                          ),
                          child:

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[




                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Row(children: <Widget>[
                                  Text("Coins" ,
                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45
                                    ),
                                    textAlign: TextAlign.left,),

                                  Icon(Icons.fiber_manual_record)

                                ],),
                                SizedBox(height: 10,),

                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(

                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.all(Radius.circular(30) ),
                                  ),

                                  child:Text("5068",

                                    style: TextStyle(
                                        fontFamily: 'ZillaSlab',
                                        fontSize:20.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white70
                                    ),
                                    textAlign: TextAlign.center,),),





                              ],),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Text("Stories" ,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45
                                ),
                                textAlign: TextAlign.left,),
                              SizedBox(height: 10,),

                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(

                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.all(Radius.circular(30) ),
                                ),

                                child:Text("48",

                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize:20.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white70
                                  ),
                                  textAlign: TextAlign.center,),),





                            ],),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Text("Streaks" ,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45
                                ),
                                textAlign: TextAlign.left,),
                              SizedBox(height: 10,),

                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(

                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.all(Radius.circular(30) ),
                                ),

                                child:Text("5",

                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize:20.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white70
                                  ),
                                  textAlign: TextAlign.center,),),





                            ],),


                      
                      ],))
                      


                  ),
                  SizedBox(height: 24,),
             (achievementsWidget()),
                  Container(

                    margin: EdgeInsets.only(right:34,top:16,bottom: 16),
                    padding: EdgeInsets.all(8),
                    decoration:
                    new BoxDecoration(
                      borderRadius: new BorderRadius.only(topRight:  Radius.circular(20.0),bottomRight:   Radius.circular((20))),
                      gradient: new LinearGradient(
                          colors: [
                            const Color(0xFF00c6ff),
                            Theme
                                .of(context)
                                .primaryColor,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),

                    child:Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(

                        'My Habits & Hobbies',
                        style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),),),
         if (edit_activity==0)(HobbiesWidget()),
                  if (edit_activity==1)(AllActivityWidget()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width/2-16,
                        margin: EdgeInsets.only(right:0,top:16,bottom: 16),
                        padding: EdgeInsets.all(8),
                        decoration:
                        new BoxDecoration(
                          borderRadius: new BorderRadius.only(topRight:  Radius.circular(20.0),bottomRight:   Radius.circular((20))),
                          gradient: new LinearGradient(
                              colors: [
                                const Color(0xFF00c6ff),
                                Theme
                                    .of(context)
                                    .primaryColor,

                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.00),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),

                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[

                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(

                                'Invite a friend',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),),
                            Padding(
                              padding: EdgeInsets.only(top:15,right: 28),
                              child: Icon(

                                 OMIcons.mail
                              ),)


                          ],),),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width/2-16,
                      margin: EdgeInsets.only(right:0,top:16,bottom: 16),
                      padding: EdgeInsets.all(8),
                      decoration:
                      new BoxDecoration(
                        borderRadius: new BorderRadius.only(topLeft:  Radius.circular(20.0),bottomLeft:   Radius.circular((20))),
                        gradient: new LinearGradient(
                            colors: [

                              Theme
                                  .of(context)
                                  .primaryColor,
                              const Color(0xFF00c6ff),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 1.00),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),

                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                        Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(

                          'Rate us 5 Stars',
                          style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),),
                        Padding(
                          padding: EdgeInsets.only(top:15,left: 28),
                          child: Icon(

                            OMIcons.starBorder
                          ),)


                      ],),),



                  ],)


                ],
              )),
              margin: EdgeInsets.only(top: 0),
              padding: EdgeInsets.only(left: 0, right: 0),
            ),)),
    );
  }


  List<Widget> buildNoteComponentsList() {
    List<Widget> noteComponentsList = [];


    return noteComponentsList;
  }

  Widget _buildActivityCard(int index,
      ActivityModel this_act) {
    String count= "";
    String image='assets/images/'+this_act.image+'.jpg';

    return GestureDetector(
      onTap: () {
        setState(() {


          activity_position[index]=1- activity_position[index];
          //if ( activity_position[index]==1)


        });
      },
      child: Padding(

        padding:EdgeInsets.only(),child:Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
        height: 100,
        width: 120,

        child: Stack(

          children: <Widget>[

            Container(



                decoration: BoxDecoration(
                  // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                    borderRadius:  BorderRadius.all( Radius.circular(10.0) ),
                    image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover
                    )
                )


            ),

            if (activity_position[index]!=1)Padding(
              padding: EdgeInsets.all(4),

              child:Align(

                alignment: Alignment.center,
                child: Text(
                  this_act.name,
                  style: TextStyle(
                      color: Colors.white ,
                      fontFamily: 'ZillaSlab',
                      fontSize: 20,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 4.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Color.fromARGB(255, 0, 0, 2),
                        ),
                      ],
                      fontWeight: FontWeight.w500),

                ),),
            ),

            if (activity_position[index]==1)Padding(
              padding: EdgeInsets.only(),

              child:Align(

                alignment: Alignment.center,
                child: Icon(Icons.add_circle,size: 50,color: Colors.orange[400].withOpacity(.8),),),
            ),


          ],
        ),
      ),),
    );
  }
  BoxShadow buildBoxShadow(Color color, BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
          color:  Colors.black.withAlpha(100),

          blurRadius: 8,
          offset: Offset(0, 8));
    }
    return BoxShadow(
        color:color.withAlpha(60),

        blurRadius: 8,
        offset: Offset(0, 8));
  }
  
  Widget HobbiesWidget(){


    return Padding(padding:EdgeInsets.only(left:0,top:0),
      child:Container(
        height:200,
        child: FadeAnimation(.8, Container(

          child:ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AllUserActivityList.length +2  ,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index==AllUserActivityList.length+1) {
                  return GestureDetector(
                    onTap: () {

                      setState(() {
                        edit_activity=1;
                      });


                    },
                    child: Padding(

                      padding:EdgeInsets.only(),child:Container(
                      margin: EdgeInsets.symmetric(vertical: 55, horizontal: 8.0),
                      height: 60,
                      width: 120,

                      child: Stack(

                        children: <Widget>[

                          Container(




                                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                decoration:
                                new BoxDecoration(
                                  borderRadius: new BorderRadius.all( Radius.circular((10))),
                                  gradient: new LinearGradient(
                                      colors: [
                                        const Color(0xFF00c6ff),
                                        Theme
                                            .of(context)
                                            .primaryColor,
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 1.00),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),



                          ),

                          Padding(
                            padding: EdgeInsets.all(4),

                            child:Align(

                              alignment: Alignment.center,
                              child: Icon(Icons.add_circle,size: 40,color: Colors.white,),),
                          ),




                        ],
                      ),
                    ),),
                  );

                }
                if (index==0){

                  return SizedBox(width: 28,);
                }

                return  _buildUserActivityCard(
                    index-1,
                    AllUserActivityList[index-1]
                );

              }
          ),)),
      ),);
  }

  Widget AllActivityWidget(){


    return Padding(padding:EdgeInsets.only(left:28,top:0),
      child:Container(
        height:200,
        child: FadeAnimation(2.6, Container(

          child:ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AllActivityList.length +1  ,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index==AllActivityList.length) {
                  return GestureDetector(
                    onTap: () async {

                      setState(() {
                        edit_activity=0;
                      });
                      for (var i=0;i<activity_position.length;i++){

                        if (activity_position[i]==1){
                          UserAModel usera=new UserAModel(name: AllActivityList[i].name,a_id:AllActivityList[i].id,image: AllActivityList[i].image);
                          await NotesDatabaseService.db.addUserActivity(usera);
                        }


                      }

                      setState(() {
                        get_UserActivityModel();
                      });


                    },
                    child: Padding(

                      padding:EdgeInsets.only(),child:Container(
                      margin: EdgeInsets.symmetric(vertical: 55, horizontal: 8.0),
                      height: 60,
                      width: 120,

                      child: Stack(

                        children: <Widget>[

                          Container(




                            // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                            decoration:
                            new BoxDecoration(
                              borderRadius: new BorderRadius.all( Radius.circular((10))),
                              gradient: new LinearGradient(
                                  colors: [
                                    const Color(0xFF00c6ff),
                                    Theme
                                        .of(context)
                                        .primaryColor,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 1.00),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),



                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom:20),

                            child:Align(

                              alignment: Alignment.center,
                              child: Icon(Icons.save,size: 25,color: Colors.white,),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top:24),

                            child:Align(

                              alignment: Alignment.center,
                              child: Text("Save",  style: TextStyle(
                                  color: Colors.white ,
                                  fontFamily: 'ZillaSlab',
                                  fontSize: 20,

                                  fontWeight: FontWeight.w500),),),
                          ),




                        ],
                      ),
                    ),),
                  );

                }

                return  _buildActivityCard(
                    index,
                    AllActivityList[index]
                );

              }
          ),)),
      ),);
  }

  Widget _buildUserActivityCard(int index,
      UserAModel this_act) {
    String count= "";
    String image='assets/images/'+this_act.image+'.jpg';

    return GestureDetector(
      onTap: () {


      },
      child: Padding(

        padding:EdgeInsets.only(),child:Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8.0),
        height: 100,
        width: 120,

        child: Stack(

          children: <Widget>[

            Container(



                decoration: BoxDecoration(
                  // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                    borderRadius:  BorderRadius.all( Radius.circular(10.0) ),
                    image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover
                    )
                )


            ),

           Padding(
              padding: EdgeInsets.all(4),

              child:Align(

                alignment: Alignment.center,
                child: Text(
                  this_act.name,
                  style: TextStyle(
                      color: Colors.white ,
                      fontFamily: 'ZillaSlab',
                      fontSize: 20,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 4.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Color.fromARGB(255, 0, 0, 2),
                        ),
                      ],
                      fontWeight: FontWeight.w500),

                ),),
            ),




          ],
        ),
      ),),
    );
  }



  Widget achievementsWidget() {

    Color color =
    colorList.elementAt(56 % colorList.length);
    return Container(
      height: 180,
        margin: EdgeInsets.fromLTRB(20, 0,20, 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 12),
          image: DecorationImage(
              image: AssetImage('assets/images/achievements.jpg'),
              fit: BoxFit.cover
          ),
          borderRadius: new BorderRadius.all( Radius.circular(30.0) ),

          boxShadow: [buildBoxShadow(color, context)],
        ),
        child: Material(
            borderRadius: new BorderRadius.all( Radius.circular(30.0) ),

            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).dialogBackgroundColor,
            child: InkWell(
              borderRadius: new BorderRadius.all( Radius.circular(30.0) ),

              onTap: () {

              },
              splashColor: color.withAlpha(20),
              highlightColor: color.withAlpha(10),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/achievements.jpg'),
                      fit: BoxFit.cover
                  ),

                ),
                padding: EdgeInsets.all(24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Achievements',
                        style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 32,
                            foreground: Paint()..shader = linearGradient,
                            fontWeight: FontWeight.w800),
                      ),
                      Icon(Icons.short_text,size:50,color: Colors.white30,)


                    ]),
              ),
            )));

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
