import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/utils.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/card_title.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/height_widget/height_picker.dart';

class HeightCard extends StatelessWidget {
  final int height;
  final ValueChanged<int> onChanged;
  final ValueChanged<BuildContext> onGoBack;

  const HeightCard({Key key, this.height = 170, this.onChanged, this.onGoBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        right: screenAwareSize(16.0, context),
        left: screenAwareSize(4.0, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {
                onGoBack(context);
              },
              child: CardTitle("Done", subtitle: "")),
          CardTitle("Height", subtitle: "(cm)"),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenAwareSize(8.0, context)),
              child: LayoutBuilder(builder: (context, constraints) {
                return HeightPicker(
                  maxHeight: 220,
                  widgetHeight: constraints.maxHeight,
                  height: height,
                  onGoBack: onGoBack,
                  onChange: (val) => onChanged(val),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
