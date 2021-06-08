import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/FILES/presentation/widgets/youtube_loaded.dart';
import 'package:sorted/features/FILES/presentation/youtube_bloc/todolist_bloc.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class YoutubeWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(int decoration) updateDecoration;

  const YoutubeWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => YoutubeWidgetState();
}

class YoutubeWidgetState extends State<YoutubeWidget> {
  double height = 10;
  TransformationController controller = TransformationController();
  String videoTitle = "";
  String videoChannel = "";

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print("Load Textbox " + widget.blockInfo.toString());
    BlocProvider.of<YoutubeBloc>(context)..add(GetVideo(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(child:
        BlocBuilder<YoutubeBloc, YoutubeState>(builder: (context, state) {
      if (state is YoutubeError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is YoutubeInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is YoutubeLoaded) {
        return MeasureSize(
            onChange: (Size size) {
              print("child measured");
              if (state.blockInfo.height != size.height)
                widget.updateBlockInfo(
                    widget.blockInfo.copyWith(height: size.height));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.item.title != null && state.item.title != "")
                    Container(
                      color: Theme.of(context).primaryColor.withAlpha(200),
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: Gparam.widthPadding,
                                  ),
                                  Icon(
                                    OMIcons.playCircleOutline,
                                    color: Theme.of(context).highlightColor,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Text(
                                      state.item.title,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color:
                                              Theme.of(context).highlightColor,
                                          fontSize: Gparam.textSmall,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(right: Gparam.widthPadding / 2),
                            child: Icon(
                              OMIcons.moreVert,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  if (videoTitle != "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: Gparam.widthPadding,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha(0),
                                  ),
                                  child: Text(
                                    videoTitle,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: Gparam.textSmall,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (videoChannel != "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: Gparam.widthPadding,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha(0),
                                  ),
                                  child: Text(
                                    videoChannel,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: Gparam.textVerySmall,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      // TextboxBlock toSendBlock = state.textboxBlock;
                      // Navigator.push(
                      //     context,
                      //     FadeRoute(
                      //         page: TextboxEdit(
                      //       textboxBlock: toSendBlock,
                      //       textboxBloc:
                      //           BlocProvider.of<ImageBloc>(context),
                      //     )));
                      print("edit");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: Stack(
                            children: [
                              YoutubeLoadedWidget(
                                  state: state, loadVideoData: loadVideoData),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 4),
                                        decoration: BoxDecoration(
                                          // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(150),
                                        ),
                                        child: Icon(
                                          OMIcons.moreVert,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      }
    }));
  }

  loadVideoData(YoutubeMetaData videoData) {
    print("loadVideoData  " + videoData.toString());
    setState(() {
      videoTitle = videoData.title;
      videoChannel = videoData.author;
    });
  }
}
