import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/shimmer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/colossal_bloc/colossal_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class ColossalWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(int decoration) updateDecoration;

  const ColossalWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ColossalWidgetState();
}

class ColossalWidgetState extends State<ColossalWidget> {
  double height = 10;
  TransformationController controller = TransformationController();

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print("Load Colossal " + widget.blockInfo.toString());
    BlocProvider.of<ColossalBloc>(context)
      ..add(UpdateColossal(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(child:
        BlocBuilder<ColossalBloc, ColossalState>(builder: (context, state) {
      if (state is ColossalError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is ColossalInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is ColossalLoaded) {
        print("shreyash " + state.toString());
        if (state.colossal.decoration == 0)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.colossal.title != null &&
                        state.colossal.title != "")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    OMIcons.image,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(0),
                                    ),
                                    child: Text(
                                      state.colossal.title,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Theme.of(context).primaryColor,
                                          fontSize: Gparam.textSmall,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Icon(
                            OMIcons.moreVert,
                            color: Theme.of(context).primaryColor,
                          )
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
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0)),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Stack(
                              children: [
                                Container(
                                  height: 260,
                                  width: Gparam.width,
                                  margin: EdgeInsets.symmetric(horizontal: 0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.images.length + 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0)
                                        return SizedBox(
                                          width: 12,
                                        );
                                      else if (index == state.images.length + 1)
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12.0)),
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
                                        );
                                      if (state.images != null &&
                                          state.images.length > 0)
                                        return _buildImageTile(
                                            index - 1,
                                            state.images[index - 1],
                                            state.doLocalExist[index - 1]);
                                    },
                                  ),
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
        else
          return Container();
      }
    }));
  }

  Widget _buildImageTile(int index, ImageBlock imageFile, bool doLocalExists) {
    print("shreyash haha " + imageFile.url);

    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          if (doLocalExists && (imageFile.url == null || imageFile.url == ""))
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    image: FileImage(File(imageFile.imagePath)),
                  ),
                )),
          if (imageFile.url != null && imageFile.url != "")
            Container(
              margin: EdgeInsets.all(12),
              child: Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Center(
                          child: Container(
                              width: 10,
                              height: 10,
                              child: Shimmer(
                                period: Duration(milliseconds: 1600),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.grey[200],
                                    Colors.grey[200],
                                    Colors.grey[350],
                                    Colors.grey[200],
                                    Colors.grey[200]
                                  ],
                                  stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                                ),
                                child: Container(
                                  height: 260,
                                  width: 260,
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(60.0)),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          color: Colors.black.withAlpha(80),
                                          blurRadius: 4)
                                    ],
                                    gradient: new LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.white,
                                        ],
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        stops: [1.0, 0.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                ),
                              )),
                        ),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.network_check),
                        imageUrl: imageFile.url,
                        fit: BoxFit.cover,
                      ))),
            ),
          SizedBox(
            width: 0,
            height: 0,
          )
        ],
      ),
    );
  }
}
