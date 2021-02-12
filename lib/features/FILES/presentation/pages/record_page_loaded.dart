import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/features/FILES/data/models/notebook_model.dart';
import 'package:sorted/features/FILES/presentation/record_bloc/record_bloc.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';

class RecordTabPage extends StatefulWidget {
  final RecordLoaded state;
  const RecordTabPage({Key key, this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecordTabPageState();
}

class RecordTabPageState extends State<RecordTabPage> {
  List<String> sliderText = [
    "Tips related to how to record",
    "Articles related to importance on self tracking",
    "Results from our app users on their progress",
    "Share public notes moderated by our team to showcase productivity",
    "Advertisements for self tracking devices and related companies"
  ];
  List<String> sliderURLS = [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2FQuicknote%2Fashley-edwards-AjcVTjCz310-unsplash.jpg?alt=media&token=bcd2a117-fa2a-49ae-ad33-7c60eeff83da",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2Fslider%2Fjess-bailey-5xjw079i6Q4-unsplash.jpg?alt=media&token=f44ba0c2-3980-4f97-8c5e-1ff6dcbf3a33",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2Fslider%2Fmarkus-winkler-IrRbSND5EUc-unsplash.jpg?alt=media&token=effce1ec-c6ec-4b6a-a796-4bee2977cc49",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2Fslider%2Fcathryn-lavery-fMD_Cru6OTk-unsplash.jpg?alt=media&token=7762f364-b34f-470d-b2a5-e582e0197de3",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/notebooks%2Fslider%2FPartner_Logos.jpg?alt=media&token=7e9d28e6-c53a-4ae0-abc5-663dc6a3df55"
  ];
  int selectedCategory = 0;

  ScrollController _listScrollController;
  final dataKey1 = new GlobalKey(debugLabel: "1");
  final dataKey2 = new GlobalKey(debugLabel: "2");
  final dataKey3 = new GlobalKey(debugLabel: "3");

  final dataKey4 = new GlobalKey(debugLabel: "4");
  final dataKey5 = new GlobalKey(debugLabel: "5");
  final dataKey6 = new GlobalKey(debugLabel: "6");
  final dataKey7 = new GlobalKey(debugLabel: "7");

  ScrollController mainAxisController;
  ScrollController secondAxisController;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  @override
  void initState() {
    _listScrollController = ScrollController();
    mainAxisController = ScrollController();
    secondAxisController = ScrollController();
    secondAxisController
      ..addListener(() {
        if (secondAxisController.position.pixels ==
            secondAxisController.position.minScrollExtent) {
          mainAxisController.animateTo(
              mainAxisController.position.minScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate);
          setState(() {
            selectedCategory = 0;
          });
        } else if (secondAxisController.position.pixels > 10) {
          mainAxisController.animateTo(
              mainAxisController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate);
        }
        if (secondAxisController.position.pixels >
            (widget.state.everydayNotebooks.length +
                    widget.state.educationNotebooks.length +
                    widget.state.financeNotebooks.length +
                    widget.state.selfloveNotebooks.length +
                    widget.state.blogsNotebooks.length +
                    widget.state.friendsNotebooks.length) *
                220.0) {
          setState(() {
            selectedCategory = 6;
          });
        } else if (secondAxisController.position.pixels >
            (widget.state.everydayNotebooks.length +
                    widget.state.educationNotebooks.length +
                    widget.state.financeNotebooks.length +
                    widget.state.selfloveNotebooks.length +
                    widget.state.friendsNotebooks.length) *
                220.0) {
          setState(() {
            selectedCategory = 5;
          });
        } else if (secondAxisController.position.pixels >
            (widget.state.everydayNotebooks.length +
                    widget.state.educationNotebooks.length +
                    widget.state.financeNotebooks.length +
                    widget.state.friendsNotebooks.length) *
                220.0) {
          setState(() {
            selectedCategory = 4;
          });
        } else if (secondAxisController.position.pixels >
            (widget.state.everydayNotebooks.length +
                    widget.state.educationNotebooks.length +
                    widget.state.financeNotebooks.length) *
                220.0) {
          setState(() {
            selectedCategory = 3;
          });
        } else if (secondAxisController.position.pixels >
            (widget.state.everydayNotebooks.length +
                    widget.state.educationNotebooks.length) *
                220.0) {
          setState(() {
            selectedCategory = 2;
          });
        } else if (secondAxisController.position.pixels >
            (widget.state.everydayNotebooks.length) * 220.0) {
          setState(() {
            selectedCategory = 1;
          });
        }
        if (itemScrollController.isAttached)
          itemScrollController.scrollTo(
              index: selectedCategory,
              duration: Duration(milliseconds: 200),
              curve: Curves.decelerate);
      });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: mainAxisController,
      physics: ScrollPhysics(parent: PageScrollPhysics()),
      body: Builder(builder: (BuildContext context) {
        final innerScrollController = PrimaryScrollController.of(context);
        return ListView(
          controller: secondAxisController,
          children: [
            Divider(
              color: Theme.of(context).highlightColor.withAlpha(50),
            ),
            CategoryBlock(
                key: dataKey1,
                widget: widget,
                notebooks: widget.state.everydayNotebooks,
                index: 0),
            CategoryBlock(
                key: dataKey2,
                widget: widget,
                notebooks: widget.state.educationNotebooks,
                index: 1),
            CategoryBlock(
                key: dataKey3,
                widget: widget,
                notebooks: widget.state.financeNotebooks,
                index: 2),
            CategoryBlock(
                key: dataKey4,
                widget: widget,
                notebooks: widget.state.friendsNotebooks,
                index: 3),
            CategoryBlock(
                key: dataKey5,
                widget: widget,
                notebooks: widget.state.selfloveNotebooks,
                index: 4),
            CategoryBlock(
                key: dataKey6,
                widget: widget,
                notebooks: widget.state.blogsNotebooks,
                index: 5),
            CategoryBlock(
                key: dataKey7,
                widget: widget,
                notebooks: widget.state.healthNotebooks,
                index: 6),
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
            actions: <Widget>[],
            expandedHeight: 370,
            pinned: true,
            primary: true,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(0.0)),
            ),
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return FlexibleSpaceBar(
                titlePadding: EdgeInsets.all(0),
                stretchModes: const <StretchMode>[StretchMode.blurBackground],
                collapseMode: CollapseMode.pin,
                title: Container(
                    height: 55,
                    child: ScrollablePositionedList.builder(
                      scrollDirection: Axis.horizontal,
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      itemCount: widget.state.categories.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0)
                          return SizedBox(
                            width: Gparam.widthPadding / 2,
                          );

                        return GestureDetector(
                            onTap: () {},
                            child: CategoryItem(
                              widget: widget,
                              index: index - 1,
                              onTap: onTapCategory,
                              selected: selectedCategory,
                            ));
                      },
                    )),
                background: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(OMIcons.arrowBackIos,
                              color: Theme.of(context).primaryColor),
                          tooltip: 'back',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Sort.it',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: Gparam.textMedium,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Recorder',
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: Gparam.textMedium,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(OMIcons.search,
                              color: Theme.of(context).primaryColor),
                          tooltip: 'reminders',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Container(
                        height: 250,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sliderText.length + 1,
                            itemBuilder: (context, position) {
                              if (position == 0)
                                return Container(
                                  height: 250,
                                  margin:
                                      EdgeInsets.all(Gparam.widthPadding / 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: ClipRRect(
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(16.0)),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/note_application.jpg"),
                                      )),
                                );
                              return Stack(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.all(Gparam.widthPadding / 2),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(2, 2),
                                            color: Colors.black.withAlpha(10),
                                            spreadRadius: 2,
                                            blurRadius: 10),
                                        BoxShadow(
                                            offset: Offset(-2, -2),
                                            color: Colors.black.withAlpha(10),
                                            spreadRadius: 2,
                                            blurRadius: 10)
                                      ],
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 250,
                                          child: ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      strokeWidth: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                imageUrl:
                                                    sliderURLS[position - 1],
                                                fit: BoxFit.cover,
                                                width: Gparam.width -
                                                    Gparam.widthPadding,
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(2, 2),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    spreadRadius: 2,
                                                    blurRadius: 10),
                                                BoxShadow(
                                                    offset: Offset(-2, -2),
                                                    color: Colors.black
                                                        .withAlpha(10),
                                                    spreadRadius: 2,
                                                    blurRadius: 10)
                                              ],
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor
                                                  .withAlpha(200),
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                            ),
                                            child: Text(
                                              sliderText[position - 1],
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  shadows: [
                                                    Shadow(
                                                        color: Colors.black38,
                                                        blurRadius: 30)
                                                  ],
                                                  fontSize: Gparam.textSmall,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          color: Colors.black45,
                        )
                      ],
                    ),
                    SizedBox(height: Gparam.heightPadding),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  onTapCategory(int category) {
    setState(() {
      selectedCategory = category;
    });
    //mainAxisController.jumpTo(6000);
    print(secondAxisController.position.maxScrollExtent);
    print(secondAxisController.position.minScrollExtent);

    if (category == 0) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        secondAxisController.jumpTo(0);
      });
    } else if (category == 1) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        secondAxisController.jumpTo(1500);
      });
    } else if (category == 2) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        secondAxisController.jumpTo((widget.state.everydayNotebooks.length +
                widget.state.educationNotebooks.length) *
            220.0);
      });
    } else if (category == 3) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        secondAxisController.jumpTo((widget.state.everydayNotebooks.length +
                widget.state.educationNotebooks.length +
                widget.state.financeNotebooks.length) *
            220.0);
      });
    } else if (category == 4) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        secondAxisController.jumpTo((widget.state.everydayNotebooks.length +
                widget.state.educationNotebooks.length +
                widget.state.financeNotebooks.length +
                widget.state.friendsNotebooks.length) *
            220.0);
      });
    } else if (category == 5) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        secondAxisController.jumpTo((widget.state.everydayNotebooks.length +
                widget.state.educationNotebooks.length +
                widget.state.financeNotebooks.length +
                widget.state.selfloveNotebooks.length +
                widget.state.friendsNotebooks.length) *
            220.0);
      });
    } else if (category == 6) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        secondAxisController.jumpTo((widget.state.everydayNotebooks.length +
                widget.state.educationNotebooks.length +
                widget.state.financeNotebooks.length +
                widget.state.selfloveNotebooks.length +
                widget.state.blogsNotebooks.length +
                widget.state.friendsNotebooks.length) *
            220.0);
      });
    }
  }

  onNotebookTap(int category) {}
}

class CategoryBlock extends StatelessWidget {
  const CategoryBlock({
    Key key,
    @required this.widget,
    this.index,
    this.notebooks,
  }) : super(key: key);

  final RecordTabPage widget;
  final int index;
  final List<NotebookModel> notebooks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Gparam.heightPadding / 2,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: Gparam.widthPadding),
              child: Text(
                widget.state.categories[index],
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Theme.of(context).highlightColor,
                    fontSize: Gparam.textMedium,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Gparam.heightPadding / 5,
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                    left: Gparam.widthPadding, right: Gparam.widthPadding / 2),
                child: Container(
                  child: Text(
                    widget.state.categoriesDescription[index],
                    maxLines: 2,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Theme.of(context).highlightColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(Gparam.widthPadding / 2),
          width: Gparam.width,
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: notebooks.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (1),
              childAspectRatio: 1.9,
            ),
            itemBuilder: (BuildContext context, int index) {
              //if (index < 50)
              return Container(
                  child: NotebookItem(
                index: index,
                widget: widget,
                notebooks: notebooks,
                onTap: onNotebookTap,
              ));
            },
          ),
        ),
      ],
    );
  }

  onNotebookTap(NotebookModel notebook) {
    rt.Router.navigator.pushNamed(rt.Router.notesHubPage,
        arguments: rt.NotesHubPageArguments(thisNotebook: notebook));
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key key,
    @required this.widget,
    this.index,
    this.selected,
    this.onTap,
  }) : super(key: key);
  final int index;
  final Function(int category) onTap;
  final int selected;
  final RecordTabPage widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(index);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (selected != index) ? null : Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          widget.state.categories[index],
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

class NotebookItem extends StatelessWidget {
  const NotebookItem({
    Key key,
    @required this.widget,
    this.index,
    this.onTap,
    this.notebooks,
  }) : super(key: key);
  final int index;
  final Function(NotebookModel notebook) onTap;
  final List<NotebookModel> notebooks;

  final RecordTabPage widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(notebooks[index]);
      },
      child: Hero(
        tag: notebooks[index].id,
        child: Container(
            margin: EdgeInsets.all(8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  notebooks[index].assetPath,
                  fit: BoxFit.cover,
                ))),
      ),
    );
  }
}
