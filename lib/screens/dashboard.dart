import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes/components/bookcards.dart';
import 'package:notes/components/faderoute.dart';
import 'package:notes/data/models.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/theme.dart';
import 'package:notes/screens/ListQuestion.dart';
import 'package:notes/screens/NotesList.dart';
import 'package:notes/screens/edit.dart';
import 'package:notes/screens/home.dart';
import 'package:notes/screens/view.dart';
import 'package:notes/services/database.dart';
import 'Display_questions.dart';
import 'settings.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../components/bookcards.dart';

class MyDashPage extends StatefulWidget {
  Function() triggerRefetch;
  Function(Brightness brightness) changeTheme;

  MyDashPage(
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
  _MyDashState createState() => _MyDashState();
}

class _MyDashState extends State<MyDashPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController;
  ThemeData theme = appThemeLight;
  bool isFlagOn = false;
  int _selectedIndex;
  List<NoteBookModel> notesList = [];
  TextEditingController searchController = TextEditingController();
  NoteBookModel currentNote;
  bool isSearchEmpty = true;
  bool headerShouldHide = false;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Color col;

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setNotesFromDB();
  }

  setNotesFromDB() async {
    print("Entered setNotes");
    var fetchedNotes = await NotesDatabaseService.db.getNotebookFromDB();
    setState(() {
      notesList = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    col = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade600
        : Colors.grey.shade300;
    return Scaffold(
      key: _scaffoldKey,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        label: Text(
          'Add notebook'.toUpperCase(),
        ),
        icon: Icon(Icons.add),
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
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
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.centerRight,
                      child: Icon(
                        OMIcons.menu,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade600
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SettingsPage(
                                  changeTheme: widget.changeTheme)));
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
              buildButtonRow(),
              buildImportantIndicatorText(),
              Container(height: 32),
              ...buildNoteComponentsList(),
              GestureDetector(
                  onTap: () => _settingModalBottomSheet(context),
                  child: AddNotebookCardComponent()),
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    currentNote = NoteBookModel(
        title: "", notes_num: 0, isImportant: false, date: DateTime.now());
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 20,
                      top: 20),
                  child: TextField(
                    focusNode: titleFocus,
                    autofocus: true,
                    controller: titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSubmitted: (text) {
                      titleFocus.unfocus();
                      FocusScope.of(context).requestFocus(contentFocus);
                      handleSave();
                    },
                    textInputAction: TextInputAction.done,
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
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('Add'),
                      onPressed: () async {
                        handleSave();
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
          );
        });
  }

  void handleSave() async {
    setState(() {
      currentNote.notes_num = 0;
      currentNote.title = titleController.text;
      currentNote.isImportant = false;
    });
    Navigator.pop(context);
    await NotesDatabaseService.db.addNoteBookInDB(currentNote);
    titleFocus.unfocus();
    setState(() {
      setNotesFromDB();
      buildNoteComponentsList();
      titleController.clear();
    });
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
            .contains(searchController.text.toLowerCase()))
          noteComponentsList.add(NotebookCardComponent(
            notebookData: note,
            onTapAction: openNotebookToRead,
          ));
      });
      return noteComponentsList;
    }
    if (isFlagOn) {
      notesList.forEach((note) {
        if (note.isImportant)
          noteComponentsList.add(NotebookCardComponent(
            notebookData: note,
            onTapAction: openNotebookToRead,
          ));
      });
    } else {
      notesList.forEach((note) {
        noteComponentsList.add(NotebookCardComponent(
          notebookData: note,
          onTapAction: openNotebookToRead,
        ));
      });
    }
    return noteComponentsList;
  }

  Widget buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
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
                  borderRadius: BorderRadius.all(Radius.circular(16))),
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

  Widget buildHeaderWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 32, left: 10),
          width: headerShouldHide ? 0 :null,
          child: Text(
            'Your Notebooks',
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

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }

  openNotebookToRead(NoteBookModel notebookData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: MyNotesPage(
                title: 'Home',
                changeTheme: setTheme,
                book_id: notebookData.id)));
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
    await setNotesFromDB();
    print("Refetched notes");
  }
}
