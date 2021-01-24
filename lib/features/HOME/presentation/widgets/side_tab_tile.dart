import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class SideTabTile extends StatelessWidget {
  const SideTabTile({
    Key key,
    @required this.currentSideTab,
    @required this.isNavEnabled,
    @required this.tabName,
    @required this.description,
    @required this.index,
    @required this.onTapAction,
    this.icon,
  }) : super(key: key);

  final int currentSideTab;
  final bool isNavEnabled;
  final IconData icon;
  final String tabName;
  final String description;
  final Function(int index) onTapAction;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapAction(index);
      },
      child: AnimatedContainer(
          curve: Curves.easeOutQuad,
          padding: EdgeInsets.all(
              (currentSideTab == null || currentSideTab != index)
                  ? Gparam.widthPadding / 5
                  : Gparam.widthPadding / 3),
          duration: Duration(milliseconds: 400),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: Theme.of(context).highlightColor.withOpacity(.54),
                ),
              ),
              if (isNavEnabled)
                SizedBox(
                  width: 12,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(tabName,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: Gparam.textVerySmall,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          )),
    );
  }
}
