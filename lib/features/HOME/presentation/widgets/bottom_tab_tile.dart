import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class BottomTabTile extends StatelessWidget {
  const BottomTabTile({
    Key key,
    @required this.currentBottomTab,
    @required this.index,
    @required this.tabName,
    @required this.imagePath,
    @required this.imagePath2,
    @required this.onTapAction,
  }) : super(key: key);

  final int currentBottomTab;
  final Function(int index) onTapAction;
  final int index;
  final String tabName;
  final String imagePath;
  final String imagePath2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapAction(index);
      },
      child: AnimatedContainer(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(
              Radius.circular((10)),
            ),
            gradient: (currentBottomTab != null && currentBottomTab == index)
                ? new LinearGradient(
                    colors: [Colors.black12, Colors.black12],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.00),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)
                : null,
          ),
          duration: Duration(milliseconds: 400),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (currentBottomTab != null && currentBottomTab == index)
                  ? SizedBox(
                      width: 0,
                    )
                  : Image.asset(
                      imagePath,
                      color: Colors.black26,
                    ),
              if (currentBottomTab != null && currentBottomTab == index)
                SizedBox(
                  width: 10,
                ),
              if (currentBottomTab != null && currentBottomTab == index)
                Text(
                  tabName,
                  style: Gtheme.black20,
                )
            ],
          )),
    );
  }
}
