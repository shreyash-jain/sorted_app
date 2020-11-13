import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';
import 'package:sorted/core/global/utility/url_preview/widgets/url_description.dart';
import 'package:sorted/core/global/utility/url_preview/widgets/url_image.dart';
import 'package:sorted/core/global/utility/url_preview/widgets/url_site_name.dart';
import 'package:sorted/core/global/utility/url_preview/widgets/url_title.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/link_bloc/link_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class LinkWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(int decoration) updateDecoration;

  const LinkWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LinkWidgetState();
}

class LinkWidgetState extends State<LinkWidget> {
  double height = 10;
  TransformationController controller = TransformationController();

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print("Load Textbox " + widget.blockInfo.toString());
    BlocProvider.of<LinkBloc>(context)..add(GetLink(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(
        child: BlocBuilder<LinkBloc, LinkState>(builder: (context, state) {
      if (state is LinkError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is LinkInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is LinkLoaded) {
        return MeasureSize(
            onChange: (Size size) {
              print("child measured");
              if (state.blockInfo.height != size.height)
                widget.updateBlockInfo(
                    widget.blockInfo.copyWith(height: size.height));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
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
                              GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(state.link.url)) {
                                    await launch(state.link.url);
                                  }
                                },
                                child: Center(
                                  child: _buildPreviewCard(context, state.link),
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        OMIcons.moreVert,
                                        color: Theme.of(context).primaryColor,
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

  Widget _buildPreviewCard(BuildContext context, LinkModel link) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).padding.left -
                    MediaQuery.of(context).padding.right) *
                0.25,
            child: PreviewImage(
              link.image,
              Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PreviewTitle(
                    link.title,
                    Theme.of(context).primaryColor,
                    1,
                  ),
                  PreviewDescription(
                    link.description,
                    Theme.of(context).primaryColor,
                    3,
                  ),
                  PreviewSiteName(
                    link.siteName,
                    Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
