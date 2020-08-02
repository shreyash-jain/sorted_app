import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes/components/FadeAnimation.dart';
import 'package:notes/components/cards2.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/Display_questions.dart';
import 'package:notes/screens/ListQuestion.dart';
import 'package:notes/screens/dashboard.dart';
import 'package:notes/screens/expenseEdit.dart';
import 'package:notes/screens/richedit.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/cards.dart';

Color primaryColor = Color.fromARGB(255, 58, 149, 255);
final int id = 0;

class MyNotesPage extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  final int book_id;

  MyNotesPage(
      {Key key,
      this.title,
      Function(Brightness brightness) changeTheme,
      @required this.book_id})
      : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(book_id);
}

class _MyHomePageState extends State<MyNotesPage> {
  List<NoteBookModel> notebookList = [];
  bool isFlagOn = false;
  String name="";
  bool headerShouldHide = false;
  List<NotesModel> notesList = [];
  TextEditingController searchController = TextEditingController();
  ThemeData theme = appThemeLight;
  bool isSearchEmpty = true;
  int my_id;

  _MyHomePageState(int my_id) {
    this.my_id = my_id;
  }

  @override
  void initState() {
    super.initState();
    setNotesFromDB();
  }

  setNotesFromDB() async {
    print("Entered setNotes");
    var fetchedNotebook = await NotesDatabaseService.db.getNotebookname(my_id);
    setState(() {
      notebookList = fetchedNotebook;
      name = notebookList[0].title;
    });
    var fetchedNotes = await NotesDatabaseService.db.getNotesFromDB(my_id);
    setState(() {
      notesList = fetchedNotes;
    });
    print("no. of notes :" + notesList.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          gotoEditNote();
        },
        label: Text('Add note'.toUpperCase()),
        icon: Icon(Icons.add),
      ),

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
                name,
                style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
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



                        Text("Your\nNotes in",style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 32.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54
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

    child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(

            children: <Widget>[


              buildButtonRow(),
              buildImportantIndicatorText(),
              Container(height: 32),
              ...buildNoteComponentsList(),
              GestureDetector(
                  onTap: gotoEditNote, child: AddNoteCardComponent()),
              Container(height: 100)
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),)),
    );
  }

  Widget buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isFlagOn = !isFlagOn;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 160),
              height: 50,
              width: 50,
              curve: Curves.slowMiddle,
              child: Icon(
                isFlagOn ? Icons.flag : OMIcons.flag,
                color: isFlagOn ? Colors.white : Colors.grey.shade300,
              ),
              decoration: BoxDecoration(
                  color: isFlagOn ? Colors.blue : Colors.transparent,
                  border: Border.all(
                    width: isFlagOn ? 2 : 1,
                    color:
                        isFlagOn ? Colors.blue.shade700 : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(75))),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.only(left: 16),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      maxLines: 1,
                      onChanged: (value) {
                        handleSearch(value);
                      },
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isSearchEmpty ? Icons.search : Icons.cancel,
                        color: Colors.grey.shade300),
                    onPressed: cancelSearch,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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




  Widget buildImportantIndicatorText() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      firstChild: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          'Only showing notes marked important'.toUpperCase(),
          style: TextStyle(
              fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
        ),
      ),
      secondChild: Container(
        height: 2,
      ),
      crossFadeState:
          isFlagOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  List<Widget> buildNoteComponentsList() {
    List<Widget> noteComponentsList = [];
    notesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    if (searchController.text.isNotEmpty) {
      notesList.forEach((note) {
        if (note.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
          noteComponentsList.add(NoteComponent(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
      return noteComponentsList;
    }
    if (isFlagOn) {
      notesList.forEach((note) {
        if (note.isImportant)
          noteComponentsList.add(NoteComponent(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
    } else {
      notesList.forEach((note) {
        noteComponentsList.add(NoteComponent(
          noteData: note,
          onTapAction: openNoteToRead,
        ));
      });
    }
    return noteComponentsList;
  }

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }

  void gotoEditNote() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditorPage(
                triggerRefetch: refetchNotesFromDB, book_id: my_id)));
  }

  void refetchNotesFromDB() async {
    await setNotesFromDB();
    print("Refetched notes");
  }

  openNoteToRead(NotesModel noteData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewNotePage(
                triggerRefetch: refetchNotesFromDB, currentNote: noteData)));
    await Future.delayed(Duration(milliseconds: 300), () {});
    setState(() {
      headerShouldHide = false;
    });
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }
}
