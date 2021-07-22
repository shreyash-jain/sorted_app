import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/action_button.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/action_button_orange.dart';

class ConnectPage extends StatefulWidget {
  ConnectPage({Key key}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
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
              SizedBox(height: 20),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
                child: Container(
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Gtheme.stext("Live Classes"),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Gtheme.stext("Personal Training"),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Gtheme.stext("Workshops"),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Gtheme.stext("Online Therapy"),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Gtheme.stext("Fitness Podcasts"),
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
