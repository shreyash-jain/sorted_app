import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/FILES/data/models/notebook_model.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/notes_hub_bloc/notes_hub_bloc.dart';
import 'package:sorted/features/FILES/presentation/record_bloc/record_bloc.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';

class NotesHubLoadedPage extends StatefulWidget {
  final NotesHubLoaded state;
  const NotesHubLoadedPage({Key key, this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NotesHubLoadedPageState();
}

class NotesHubLoadedPageState extends State<NotesHubLoadedPage> {
  Color otherColor = Colors.black;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

    String valueString = widget.state.thisNotebook.color
        .split('(0x')[1]
        .split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    if (mounted) otherColor = new Color(value);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          physics: ScrollPhysics(parent: PageScrollPhysics()),
          body: Builder(builder: (BuildContext context) {
            return ListView(
              children: [
                SizedBox(
                  height: Gparam.heightPadding,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                    Container(
                      child: Text(
                        widget.state.thisNotebook.icon + "  ",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).highlightColor,
                            fontSize: Gparam.textVeryLarge,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Container(
                      child: Text(
                        widget.state.thisNotebook.title,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).highlightColor,
                            fontSize: Gparam.textMedium,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(Gparam.widthPadding),
                  child: Text(
                    widget.state.thisNotebook.description,
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Theme.of(context).highlightColor,
                        fontSize: Gparam.textSmaller,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                    height: 45,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: Gparam.widthPadding / 2,
                        ),
                        CategoryItem(
                          widget: widget,
                          index: 0,
                          text: "Records",
                          selected: selectedTab,
                          onTap: onTabTapped,
                        ),
                        CategoryItem(
                          widget: widget,
                          index: 1,
                          text: "Template",
                          selected: selectedTab,
                          onTap: onTabTapped,
                        ),
                        CategoryItem(
                          widget: widget,
                          index: 2,
                          text: "Research",
                          selected: selectedTab,
                          onTap: onTabTapped,
                        )
                      ],
                    )),
                Divider(
                  color: Theme.of(context).highlightColor.withAlpha(60),
                ),
                Container(
                  margin: EdgeInsets.all(Gparam.widthPadding / 2),
                  width: Gparam.width,
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.state.notes.length,
                    staggeredTileBuilder: (i) {
                      return _getTile(i);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      //if (index < 50)
                      return Container(
                          child: _buildNoteCard(
                              index,
                              widget.state.notes[index],
                              context,
                              (widget.state.notesText != null &&
                                      widget.state.notesText.length > 0)
                                  ? widget.state.notesText[index]
                                  : "",
                              (widget.state.notesText != null &&
                                      widget.state.notesUrl.length > 0)
                                  ? widget.state.notesUrl[index]
                                  : "",
                              (widget.state.notesText != null &&
                                      widget.state.hasList.length > 0)
                                  ? widget.state.hasList[index]
                                  : false,
                              (widget.state.notesText != null &&
                                      widget.state.hasTable.length > 0)
                                  ? widget.state.hasTable[index]
                                  : false,
                              (widget.state.notesText != null &&
                                      widget.state.hasCalendar.length > 0)
                                  ? widget.state.hasCalendar[index]
                                  : false));
                    },
                  ),
                ),
              ],
            );
          }),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverSafeArea(
              top: true,
              sliver: SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 10,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shadowColor: Colors.black26,
                title: Text(
                  widget.state.thisNotebook.title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: otherColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).highlightColor,
                  ),
                  tooltip: 'Open shopping cart',
                  onPressed: () {
                    // handle the press
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Theme.of(context).highlightColor,
                    tooltip: 'Open shopping cart',
                    onPressed: () {
                      // handle the press
                    },
                  )
                ],
                expandedHeight: 200,
                pinned: true,
                primary: true,
                floating: true,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(0.0)),
                ),
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    titlePadding: EdgeInsets.all(0),
                    stretchModes: const <StretchMode>[
                      StretchMode.blurBackground
                    ],
                    collapseMode: CollapseMode.parallax,
                    title: Container(
                      height: 0,
                      width: Gparam.width * .9,
                      color: otherColor,
                    ),
                    background: Hero(
                      tag: widget.state.thisNotebook.id,
                      child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(32),
                                  bottomLeft: Radius.circular(32)),
                              child: Image.asset(
                                widget.state.thisNotebook.assetPath,
                                fit: BoxFit.cover,
                              ))),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  MyFloatingActionButton(notebook: widget.state.thisNotebook),
            )),
      ],
    );
  }

  StaggeredTile _getTile(int index) {
    if (widget.state.notesUrl != null && widget.state.notesUrl.length > 0) {
      if (widget.state.notesUrl[index].isNotEmpty)
        return StaggeredTile.count(1, 2.5);
    }
    return StaggeredTile.count(1, 1.5);
  }

  onTabTapped(int category) {
    setState(() {
      selectedTab = category;
    });
  }

  Widget _buildNoteCard(int i, NoteModel note, BuildContext context,
      String text, String url, bool hasList, bool hasTable, bool hasCal) {
    return GestureDetector(
      onTap: () {
        Router.navigator.pushNamed(Router.noteHub,
            arguments: NoteMainArguments(note: note));
      },
      child: Hero(
        tag: note.id.toString(),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.all(Gparam.widthPadding / 6),
            width: Gparam.width / 2,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(
                Radius.circular((12)),
              ),
              gradient: new LinearGradient(
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.8),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.00),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Stack(
              children: [
                if (note.cover != "")
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).primaryColor,
                                  (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? BlendMode.lighten
                                      : BlendMode.multiply,
                                ),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                                  imageUrl: note.cover,
                                  fit: BoxFit.cover,
                                  width: Gparam.width / 2 -
                                      Gparam.widthPadding / 2 -
                                      Gparam.widthPadding / 3 -
                                      2,
                                  height: 60,
                                ))),
                      ],
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(alignment: Alignment.center, children: [
                            Text(
                              (note.noteEmoji != "0") ? note.noteEmoji : "",
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ]),
                          SizedBox(width: 4),
                          Container(
                            child: Flexible(
                                child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              text: TextSpan(
                                text: note.title,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: Gparam.textSmaller,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: otherColor.withAlpha(160), width: .5),
                        borderRadius: new BorderRadius.all(
                          Radius.circular((12)),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (url != "")
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        child: CircularProgressIndicator(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    ),
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                    height: Gparam.width / 2 - 16,
                                    width: Gparam.width / 2 -
                                        Gparam.widthPadding / 2 -
                                        24,
                                  )),
                            ),
                          SizedBox(height: Gparam.widthPadding / 2),
                          Container(
                            height: (Gparam.width / 2 * 1.5) -
                                Gparam.widthPadding -
                                10 -
                                24 -
                                70,
                            width:
                                Gparam.width / 2 - Gparam.widthPadding / 2 - 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: (Gparam.width / 2 * 1.5) -
                                      Gparam.widthPadding -
                                      10 -
                                      24 -
                                      70 -
                                      70,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 15,
                                    text: TextSpan(
                                      text: text,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).highlightColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Container(
                                    height: 60,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        if (hasCal) Icon(Icons.calendar_today),
                                        if (hasList) Icon(Icons.list),
                                        if (hasTable) Icon(Icons.table_chart)
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key key,
    @required this.widget,
    this.index,
    this.selected,
    this.onTap,
    this.text,
  }) : super(key: key);
  final int index;
  final Function(int category) onTap;
  final String text;
  final int selected;
  final NotesHubLoadedPage widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (selected != index) ? null : Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: (selected == index)
                  ? Theme.of(context).textSelectionHandleColor
                  : Theme.of(context).highlightColor,
              fontSize: Gparam.textSmall,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class MyFloatingActionButton extends StatelessWidget {
  final NotebookModel notebook;

  const MyFloatingActionButton({Key key, this.notebook}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(Icons.add),
      onPressed: () {
        BlocProvider.of<NotesHubBloc>(context)
            .add(AddNewRecord(0, notebook, context));
      },
      label: new Text(
        "Record",
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: Gparam.textSmaller,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
