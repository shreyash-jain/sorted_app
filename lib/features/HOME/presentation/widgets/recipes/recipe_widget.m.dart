import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';

class HomeRecipeWidgetM extends StatefulWidget {
  final List<TaggedRecipe> recipes;
  final int index;
  final Function(List<TaggedRecipe> recipes, int index) onClick;
  HomeRecipeWidgetM({Key key, this.recipes, this.index, this.onClick})
      : super(key: key);

  @override
  _HomeRecipeWidgetMState createState() => _HomeRecipeWidgetMState();
}

class _HomeRecipeWidgetMState extends State<HomeRecipeWidgetM> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick(widget.recipes, widget.index);
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
                height: 120,
                child: CachedNetworkImage(
                  imageUrl: widget.recipes[widget.index].image_url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: ImagePlaceholderWidget(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
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
                          widget.recipes[widget.index].name,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: 'Milliard',
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
                                SizedBox(
                                  width: 8,
                                ),
                                Gtheme.stext("Healthy",
                                    size: GFontSize.XXS,
                                    color: (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? GColors.W1
                                        : GColors.B1),
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
