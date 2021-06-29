import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';

import 'package:cached_network_image/cached_network_image.dart';

class HomeBlogWidgetM extends StatefulWidget {
  final List<BlogModel> blog;
  final int index;
  final Function(List<BlogModel> blog, int index) onClick;
  HomeBlogWidgetM({Key key, this.blog, this.index, this.onClick})
      : super(key: key);

  @override
  _HomeBlogWidgetMState createState() => _HomeBlogWidgetMState();
}

class _HomeBlogWidgetMState extends State<HomeBlogWidgetM> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick(widget.blog, widget.index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                  width: 192,
                  height: 80,
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  child: (widget.blog[widget.index].image_url != null &&
                          widget.blog[widget.index].image_url != "")
                      ? CachedNetworkImage(
                          imageUrl: widget.blog[widget.index].image_url,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          child: Center(child: Icon(Icons.broken_image)),
                        )),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: Container(
                  width: 200,
                  height: 120,
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  child: Column(
                    children: [
                      Container(
                        height: 78,
                        padding: EdgeInsets.only(
                            top: 8, left: 8, right: 8, bottom: 2),
                        child: Text(
                          widget.blog[widget.index].article_title,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textSmall,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                          height: 35,
                          margin: EdgeInsets.only(left: 8),
                          alignment: Alignment.topLeft,
                          decoration: new BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(children: [
                                Container(
                                  height: 24,
                                  width: 3,
                                  color: Color(0xFF307df0),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  MdiIcons.run,
                                  color: Color(0xFF307df0),
                                ),
                                ...widget.blog[widget.index].tags
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => Row(
                                        children: [
                                          Gtheme.stext(" #",
                                              size: GFontSize.XXS,
                                              weight: GFontWeight.B,
                                              color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark)
                                                  ? Gcolors.W
                                                  : Gcolors.B),
                                          Gtheme.stext(e.value,
                                              size: GFontSize.XXS,
                                              color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark)
                                                  ? Gcolors.W1
                                                  : Gcolors.B1),
                                        ],
                                      ),
                                    ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  height: 24,
                                  width: 3,
                                  color: Color(0xFF307df0),
                                ),
                              ])
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
