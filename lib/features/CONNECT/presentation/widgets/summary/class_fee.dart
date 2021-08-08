
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/data/models/class_private.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/action_button.dart';

class ClassFeeWidget extends StatelessWidget {
  final ClassPrivateModel fee;
  const ClassFeeWidget({Key key, this.fee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Gparam.widthPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gtheme.stext("₹ 4000.00", weight: GFontWeight.N),
          Gtheme.stext(" / ", weight: GFontWeight.B),
          Gtheme.stext("month", weight: GFontWeight.B2),
          Spacer(),
          ActionButton(
            text: "Manage",
            icon: MdiIcons.viewListOutline,
            onClick: () {
              // context.router.push(ClassFeeDetails());
            },
          )
        ],
      ),
    );
  }
}
