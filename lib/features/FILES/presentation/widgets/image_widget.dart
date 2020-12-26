import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class ImageWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(int decoration) updateDecoration;

  const ImageWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ImageWidgetState();
}

class ImageWidgetState extends State<ImageWidget> {
  double height = 10;
  TransformationController controller = TransformationController();
  ImageBloc bloc;

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print("Load Textbox " + widget.blockInfo.toString());
    bloc = BlocProvider.of<ImageBloc>(context);
    bloc..add(GetImage(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(
        child: BlocBuilder<ImageBloc, ImageState>(builder: (context, state) {
      if (state is ImageError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is ImageInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is ImageLoading) {
        return Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()));
      } else if (state is ImageLoaded) {
        if (state.imageBlock.decoration == 1)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.imageBlock.title != null &&
                      state.imageBlock.title != "")
                    Container(
                      child: Text(
                        state.imageBlock.title,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: Gparam.textSmaller,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  if (state.imageBlock.title != null &&
                      state.imageBlock.title != "")
                    SizedBox(
                      height: 8,
                    ),
                     if (state.imageBlock.url != null &&
                      state.imageBlock.url != "")
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
                    child: Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CachedNetworkImage(
                              imageUrl: state.imageBlock.url,
                              fit: BoxFit.cover,
                              height: 160,
                              width: Gparam.width,
                            ))),
                  ),
                ],
              ));
        else if (state.imageBlock.decoration == 0)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.imageBlock.title != null &&
                        state.imageBlock.title != "")
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
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(0),
                                    ),
                                    child: Text(
                                      state.imageBlock.title,
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
                        ],
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    if (state.imageBlock.url != null &&
                        state.imageBlock.url != "")
                      GestureDetector(
                        onTap: () {
                          _MenuBottomSheet(context, state.imageBlock);
                          print("edit");
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
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
                                  Center(
                                      child: InteractiveViewer(
                                    transformationController: controller,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: CachedNetworkImage(
                                          imageUrl: state.imageBlock.url,
                                          placeholder: (context, url) => Center(
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                strokeWidth: 3,
                                              ),
                                            ),
                                          ),
                                          fit: BoxFit.contain,
                                          height: (state.size.height >
                                                  state.size.width)
                                              ? Gparam.width
                                              : null,
                                        )),
                                    onInteractionEnd:
                                        (ScaleEndDetails endDetails) {
                                      controller.value = Matrix4.identity();
                                    },
                                  )),
                                  Column(
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
        else
          return Container();
      }
    }));
  }

  void _MenuBottomSheet(context, ImageBlock item) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        isScrollControlled: true,
        builder: (context1) {
          return StatefulBuilder(builder: (BuildContext context2,
              StateSetter setState /*You can rename this!*/) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context2);
                    bloc.add(StartUploadImage(item, context, widget.blockInfo));
                  },
                  leading: Icon(Icons.update),
                  title: Text(
                    'Update Image',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: "Montserrat",
                      height: 1.2,
                      color: Theme.of(context2).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Gparam.textSmaller,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context2);

                    // widget.moveUp(
                    //     widget.todo, widget.position, widget.todoBloc);
                  },
                  leading: Icon(Icons.description),
                  title: Text(
                    'Delete Image',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: "Montserrat",
                      height: 1.2,
                      color: Theme.of(context2).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Gparam.textSmaller,
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }
}
