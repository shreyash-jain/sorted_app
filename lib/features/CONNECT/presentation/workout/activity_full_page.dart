import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';

class ActivityPage extends StatefulWidget {
  final ActivityModel activity;

  ActivityPage({Key key, this.activity}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                height: Gparam.height,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(Gparam.widthPadding),
                            child: Gtheme.stext(widget.activity.exercise_name,
                                weight: GFontWeight.B1, size: GFontSize.S),
                          ),
                        ),
                      ],
                    ),
                    if (widget.activity.image_url != null &&
                        widget.activity.image_url != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.grey.shade50, BlendMode.color),
                              child: CachedNetworkImage(
                                  imageUrl: widget.activity.image_url,
                                  placeholder: (context, url) =>
                                      ImagePlaceholderWidget(),
                                  errorWidget: (context, url, error) => Icon(
                                        Icons.error,
                                        color: Colors.grey,
                                      ),
                                  width: Gparam.width - 2 * Gparam.widthPadding,
                                  height:
                                      (Gparam.width - 2 * Gparam.widthPadding) *
                                          .9,
                                  fit: BoxFit.cover),
                            )),
                      ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      color: Colors.black38,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(
                        horizontal: Gparam.widthPadding,
                      ),
                      child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: [
                            Gtheme.stext("Primary Body Trained",
                                weight: GFontWeight.B1, size: GFontSize.XS),
                            SizedBox(
                              height: 6,
                            ),
                            Gtheme.stext("Core",
                                weight: GFontWeight.N, size: GFontSize.XXS),
                          ]),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Divider(
                      color: Colors.black38,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (widget.activity.instructions != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.notebookOutline,
                              color: Colors.orange,
                              size: 21,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Gtheme.stext("Instructions",
                                weight: GFontWeight.B1, size: GFontSize.S),
                          ],
                        ),
                      ),
                    if (widget.activity.instructions != "")
                      SizedBox(
                        height: 16,
                      ),
                    if (widget.activity.instructions != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              ...widget.activity.instructions
                                  .split('.')
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        (e.key + 1).toString() + ". " + e.value,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 30,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Milliard',
                                            fontSize: Gparam.textSmaller,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  )
                                  .toList()
                            ],
                          ),
                        ),
                      ),
                    if (widget.activity.instructions != "")
                      SizedBox(
                        height: 16,
                      ),
                    if (widget.activity.how_to_start != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.lightbulbOnOutline,
                              color: Colors.orange,
                              size: 21,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Gtheme.stext("Activity Tips",
                                weight: GFontWeight.B1, size: GFontSize.S),
                          ],
                        ),
                      ),
                    if (widget.activity.how_to_start != "")
                      SizedBox(
                        height: 16,
                      ),
                    if (widget.activity.how_to_start != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              ...widget.activity.how_to_start
                                  .split('.')
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map((e) {
                                if (e.value.trim() != "")
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      (e.key + 1).toString() +
                                          ". " +
                                          e.value.trim(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 30,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Milliard',
                                          fontSize: Gparam.textSmaller,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  );
                                else
                                  return Container(
                                    height: 0,
                                  );
                              }).toList()
                            ],
                          ),
                        ),
                      ),
                    if (widget.activity.how_to_start != "")
                      SizedBox(
                        height: 16,
                      ),
                    if (widget.activity.benefits != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.treeOutline,
                              color: Colors.orange,
                              size: 21,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Gtheme.stext("Benefits",
                                weight: GFontWeight.B1, size: GFontSize.S),
                          ],
                        ),
                      ),
                    if (widget.activity.benefits != "")
                      SizedBox(
                        height: 16,
                      ),
                    if (widget.activity.benefits != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Container(
                          child: Text(
                            widget.activity.benefits,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 30,
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    if (widget.activity.benefits != "")
                      SizedBox(
                        height: 16,
                      ),
                    if (widget.activity.contraindications != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.accountCancelOutline,
                              color: Colors.orange,
                              size: 21,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Gtheme.stext("Who should not do this",
                                weight: GFontWeight.B1, size: GFontSize.S),
                          ],
                        ),
                      ),
                    if (widget.activity.contraindications != "")
                      SizedBox(
                        height: 16,
                      ),
                    if (widget.activity.contraindications != "")
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Container(
                          child: Text(
                            "People having conditions such as \n" +
                                widget.activity.contraindications,
                            maxLines: 30,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    if (widget.activity.contraindications != "")
                      SizedBox(
                        height: 16,
                      ),
                    SizedBox(
                      height: 90,
                    ),
                  ],
                ))),
          ],
        ),
      ),
    );
  }
}
