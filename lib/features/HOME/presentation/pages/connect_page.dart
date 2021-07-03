import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/action_button.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/action_button_orange.dart';

class ClassResourcesWidget extends StatefulWidget {
  ClassResourcesWidget({Key key}) : super(key: key);

  @override
  _ClassResourcesWidgetState createState() => _ClassResourcesWidgetState();
}

class _ClassResourcesWidgetState extends State<ClassResourcesWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Gparam.widthPadding / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Gtheme.stext("Find experts",
                        size: GFontSize.S, weight: GFontWeight.N),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
                child: Container(
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        OrangeActionButton(
                          text: "Fitness Experts",
                          onClick: null,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        OrangeActionButton(
                          text: "Workout Classes",
                          onClick: null,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        OrangeActionButton(
                          text: "Yoga Classes",
                          onClick: null,
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                color: Colors.grey.shade200,
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.all(Gparam.widthPadding / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Gtheme.stext("Filter",
                        size: GFontSize.S, weight: GFontWeight.N),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
                child: Container(
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ActionButton(
                          text: "All",
                          onClick: null,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ActionButton(
                          text: "Top Rated",
                          onClick: null,
                          icon: MdiIcons.star,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
