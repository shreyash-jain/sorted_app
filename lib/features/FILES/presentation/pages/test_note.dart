import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/emoji/emoji_picker.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/core/global/widgets/text_transition.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/blocks_list.dart';
import 'package:sorted/features/FILES/presentation/widgets/edit_image.dart';
import 'package:sorted/features/FILES/presentation/widgets/note_loaded.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_widget.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/PLAN/presentation/pages/kanban_view.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class NoteHub extends StatefulWidget {
  const NoteHub({Key key, this.note}) : super(key: key);
  final NoteModel note;

  @override
  State<StatefulWidget> createState() => NoteHubState();
}

class NoteHubState extends State<NoteHub> {
  ZefyrController _controller;
  NoteBloc bloc;
  double height = 10;

  NotusDocument document;
  TextboxBlock textboxBlock;
  ScrollController _listScrollController;

  var _focusNode = FocusNode();
  Emoji emojiProfile = Emoji(name: "Heavy Plus Sign", emoji: "➕");
  bool isShowSticker = false;

  @override
  void initState() {
    _listScrollController = new ScrollController(
        // NEW
        );

    _listScrollController.addListener(
      () {
        if (_listScrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (bloc.state is NotesLoaded) if ((bloc.state as NotesLoaded)
              .isBottomNavVisible) bloc.add(ChangeVisibility(false));
        }
        if (_listScrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (bloc.state is NotesLoaded) if (!(bloc.state as NotesLoaded)
              .isBottomNavVisible) bloc.add(ChangeVisibility(true));
        }
      },
    );
    bloc = NoteBloc(sl(), sl())
      ..add(UpdateNote(NoteModel(id: 1, title: "First note")));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => bloc,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(child: new LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Center(child:
                  BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
                if (state is NoteError) {
                  return MessageDisplay(
                    message: state.message,
                  );
                } else if (state is EditColossal) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding / 2,
                              ),
                              decoration: new BoxDecoration(
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(16.0)),
                                gradient: new LinearGradient(
                                    colors: [
                                      Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withAlpha(130),
                                      Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withAlpha(130),
                                    ],
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    stops: [1.0, 0.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(OMIcons.arrowBackIos,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Tap to',
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: Gparam.textSmaller,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Edit',
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: Gparam.textSmaller,
                                      )),
                                  TextSpan(
                                      text: ' image',
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: Gparam.textSmaller,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(OMIcons.forward,
                                color: Theme.of(context).primaryColor),
                            tooltip: 'reminders',
                            onPressed: () {
                              EditColossal cState =
                                  (bloc.state as EditColossal);
                              bloc.add(UploadMultipleImageThenGoToNote(
                                  cState.prevNotesLoadedState,
                                  cState.position,
                                  cState.imageFiles));
                            },
                          ),
                        ],
                      ),
                      Container(
                        height: Gparam.height,
                        margin: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: GridView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.vertical,
                          itemCount: state.imageFiles.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (2),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildImageTile(
                              index,
                              state.imageFiles[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is NoteLoading) {
                  return Center(child: LoadingWidget());
                } else if (state is OpenSelectBlock) {
                  return FadeAnimationTB(.3, BlockListWidget());
                } else if (state is EditImageBlock) {
                  return EditImageView(
                      image: state.imageFile,
                      position: state.position,
                      multiIndex: state.multiIndex,
                      prevNotesLoadedState: state.prevNotesLoadedState,
                      isSingleImage: state.isSingleImage,
                      colossalState: state.colossalState);
                } else if (state is NotesLoaded) {
                  print("rebuild");
                  return Stack(
                    children: [
                      Container(
                        height: Gparam.height,
                        child: SingleChildScrollView(
                          controller: _listScrollController,
                          child: Column(
                            children: [
                              Stack(children: [
                                if (state.note.cover != "0")
                                  Hero(
                                    tag: state.note.id.toString(),
                                    child: Container(
                                      width: Gparam.width,
                                      height: 200,
                                      margin: EdgeInsets.only(
                                          right: Gparam.widthPadding / 4,
                                          left: Gparam.widthPadding / 4,
                                          bottom: Gparam.heightPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.only(
                                            bottomLeft: Radius.circular(16.0),
                                            bottomRight: Radius.circular(16.0)),
                                      ),
                                      child: ClipRRect(
                                          borderRadius: new BorderRadius.only(
                                              bottomLeft: Radius.circular(16.0),
                                              bottomRight:
                                                  Radius.circular(16.0)),
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
                                                  strokeWidth: 3,
                                                ),
                                              ),
                                            ),
                                            imageUrl: state.note.cover,
                                            fit: BoxFit.cover,
                                            width: 200,
                                          )),
                                    ),
                                  ),
                                Hero(
                                  tag: "null",
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: Gparam.widthPadding / 2,
                                          ),
                                          decoration: new BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(16.0)),
                                            gradient: new LinearGradient(
                                                colors: [
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor
                                                      .withAlpha(130),
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor
                                                      .withAlpha(130),
                                                ],
                                                begin:
                                                    FractionalOffset.topCenter,
                                                end: FractionalOffset
                                                    .bottomCenter,
                                                stops: [1.0, 0.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(OMIcons.arrowBackIos,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                      if (state.note.cover == "0")
                                        Container(
                                          padding: EdgeInsets.all(0),
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Goal',
                                              style: TextStyle(
                                                  fontFamily: 'ZillaSlab',
                                                  fontSize: Gparam.textMedium,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: ' Planner',
                                                    style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          Gparam.textMedium,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      IconButton(
                                        icon: Icon(OMIcons.search,
                                            color:
                                                Theme.of(context).primaryColor),
                                        tooltip: 'reminders',
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                                if (state.note.cover != "0")
                                  Container(
                                    width: Gparam.width,
                                    height: 200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(6),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 6),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                decoration: BoxDecoration(
                                                  borderRadius: new BorderRadius
                                                          .all(
                                                      Radius.circular(12.0)),
                                                  gradient: new LinearGradient(
                                                      colors: [
                                                        Theme.of(context)
                                                            .primaryColor,
                                                        Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.8)
                                                      ],
                                                      begin: FractionalOffset
                                                          .topCenter,
                                                      end: FractionalOffset
                                                          .bottomCenter,
                                                      stops: [.2, .8],
                                                      tileMode:
                                                          TileMode.repeated),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    // Router.navigator.pushNamed(
                                                    //     Router.selectCover,
                                                    //     arguments:
                                                    //         SelectCoverArguments(
                                                    //             goalBloc: bloc));
                                                  },
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .picture_in_picture,
                                                            size: 14,
                                                            color: Theme.of(
                                                                    context)
                                                                .scaffoldBackgroundColor),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        RichText(
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          text: TextSpan(
                                                            text: "Change ",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: "cover",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Montserrat",
                                                                      height:
                                                                          1.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          14)),
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                  )
                              ]),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: InkWell(
                                  onTap: () {
                                    // setState(() {
                                    //   isShowSticker = !isShowSticker;
                                    // });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gparam.widthPadding),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Text(
                                                        (state.note.noteEmoji !=
                                                                "0")
                                                            ? state
                                                                .note.noteEmoji
                                                            : emojiProfile
                                                                .emoji,
                                                        style: TextStyle(
                                                            fontSize: 36,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                    ]),
                                                SizedBox(
                                                  width: Gparam.widthPadding,
                                                ),
                                                Container(
                                                    child: Flexible(
                                                  child: RichText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    text: TextSpan(
                                                      text: state.note.title,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize:
                                                              Gparam.textSmall,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                              if (state.note.cover == "0")
                                Container(
                                  width: Gparam.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Gparam.widthPadding,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(6),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 0),
                                              alignment: Alignment.bottomCenter,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(12.0)),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  // Router.navigator.pushNamed(Router.selectCover,
                                                  //     arguments:
                                                  //         SelectCoverArguments(goalBloc: bloc));
                                                },
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.add_a_photo,
                                                          size: 14,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      RichText(
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        text: TextSpan(
                                                          text: "Add ",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: "cover",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                    height: 1.2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      )
                                                    ]),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              NoteLoadedWidget(
                                state: state,
                                noteBloc: bloc,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: Gparam.height,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: state.isBottomNavVisible ? 55.0 : 0.0,
                            child: Wrap(
                              children: <Widget>[
                                Container(
                                  height: 128,
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 70),
                                  width: Gparam.width,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 8,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            bloc.add(OpenAllBlocks(
                                                state as NotesLoaded,
                                                state.blocks.length));
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(12.0)),
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Theme.of(context)
                                                          .primaryColor,
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(.9)
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [.2, .8],
                                                    tileMode:
                                                        TileMode.repeated),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.add_box,
                                                    size: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    "Block",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        height: 1.2,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              gradient: new LinearGradient(
                                                  colors: [
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(.9)
                                                  ],
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter,
                                                  stops: [.2, .8],
                                                  tileMode: TileMode.repeated),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(
                                                  Icons.add_alarm,
                                                  size: 25,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Reminder",
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              gradient: new LinearGradient(
                                                  colors: [
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(.9)
                                                  ],
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter,
                                                  stops: [.2, .8],
                                                  tileMode: TileMode.repeated),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(
                                                  Icons.add_comment,
                                                  size: 25,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Comment",
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              gradient: new LinearGradient(
                                                  colors: [
                                                    Theme.of(context)
                                                        .primaryColor,
                                                    Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(.9)
                                                  ],
                                                  begin: FractionalOffset
                                                      .topCenter,
                                                  end: FractionalOffset
                                                      .bottomCenter,
                                                  stops: [.2, .8],
                                                  tileMode: TileMode.repeated),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(
                                                  Icons.text_format,
                                                  size: 25,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Add textbox",
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
              })),
            );
          })),
        ));
  }

  printTest() {
    print("tested");
  }

  Widget _buildImageTile(int index, File imageFile) {
    return InkWell(
      onTap: () {
        if ((bloc.state as EditColossal).isUploading == -1)
          bloc.add(EditSingleColossalImage(
              multiIndex: index,
              colossalState: bloc.state as EditColossal,
              image: imageFile));
      },
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: FileImage(imageFile),
                  height: Gparam.height / 2,
                ),
              )),
          if ((bloc.state as EditColossal).isUploading == -1)
            Container(
                padding: EdgeInsets.all(16),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Theme.of(context).primaryColor.withAlpha(150),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        )))),
          if ((bloc.state as EditColossal).isUploading == index)
            Container(
                padding: EdgeInsets.all(16),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Theme.of(context).primaryColor.withAlpha(150),
                        ),
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                        )))),
          if ((bloc.state as EditColossal).isUploading > index)
            Container(
                padding: EdgeInsets.all(16),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Theme.of(context).primaryColor.withAlpha(150),
                        ),
                        child: Icon(
                          Icons.cloud_done,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        )))),
        ],
      ),
    );
  }
}
