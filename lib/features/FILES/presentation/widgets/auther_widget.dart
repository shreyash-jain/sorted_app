import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class AutherWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;

  final Function(int decoration) updateDecoration;

  const AutherWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AutherWidgetState();
}

class AutherWidgetState extends State<AutherWidget> {
  double height = 10;
  TransformationController controller = TransformationController();

  var _focusNode = FocusNode();

  var sController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("Load Heading " + widget.blockInfo.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");

    return MeasureSize(
        onChange: (Size size) {
          print("child measured");
          if (widget.blockInfo.height != size.height)
            widget.updateBlockInfo(
                widget.blockInfo.copyWith(height: size.height));
        },
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: Gparam.heightPadding/3),
            child: Row(children: [
              Flexible(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: Gparam.widthPadding,
                          ),
                          if (CacheDataClass.cacheData.getUserDetail() != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image(
                                image: NetworkImage(
                                  CacheDataClass.cacheData
                                      .getUserDetail()
                                      .imageUrl,
                                ),
                                height: 20,
                                width: 20,
                              ),
                            ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "by ",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textVerySmall,
                                fontWeight: FontWeight.w800),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (CacheDataClass.cacheData.getUserDetail() !=
                                  null)
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    CacheDataClass.cacheData
                                        .getUserDetail()
                                        .name,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: Gparam.textVerySmall,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )))
            ]),
          ),
        ));
    ;
  }
}
