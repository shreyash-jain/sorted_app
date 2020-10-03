import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class SideTabTile extends StatelessWidget {
  const SideTabTile({
    Key key,
    @required this.currentSideTab,
    @required this.isNavEnabled,
    @required this.tabName,
    @required this.description,
    @required this.index, @required this.onTapAction,
    
  }) : super(key: key);

  final int currentSideTab;
  final bool isNavEnabled;
  final String tabName;
  final String description;
  final Function(int index) onTapAction;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       onTapAction(index);
      },
      child: AnimatedContainer(
          curve: Curves.easeOutQuad,
          padding: EdgeInsets.all(
              (currentSideTab == null || currentSideTab != index) ? Gparam.widthPadding/5 : Gparam.widthPadding/3),
          decoration: (currentSideTab == index)
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1),
                        color: (Theme.of(context).brightness==Brightness.light)?Colors.black.withAlpha(20):Color.fromARGB(100, 30, 30, 30),
                        blurRadius: 30)
                  ],
                  borderRadius: new BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)),
                  gradient: new LinearGradient(
                      colors: [
                        Theme.of(context).backgroundColor,
                        Theme.of(context).primaryColor,
                        

                      ],
                      begin: FractionalOffset.topRight,
                      end: FractionalOffset.bottomCenter,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                )
              : null,
          duration: Duration(milliseconds: 400),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotatedBox(
                  quarterTurns: 3,
                  child: Text(tabName,
                      style: TextStyle(
                          color:  (Theme.of(context).brightness==Brightness.light)?(currentSideTab == index)
                              ? Colors.black12
                              : Colors.black45:(currentSideTab == index)
                              ? Colors.white24
                              : Colors.white70,
                          fontFamily: 'ZillaSlab',
                          fontSize: 22,
                          shadows: [
                            Shadow(
                              blurRadius: 60.0,
                              color: Colors.white,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                          fontWeight: FontWeight.bold))),
              if (isNavEnabled)
                SizedBox(
                  width: 12,
                ),
              if (isNavEnabled)
                Container(
                  width: Gparam.width / 2 - Gparam.width / 8,
                  padding: EdgeInsets.all(8),
                  decoration:  (currentSideTab == index)
                              ?null:BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.all( Radius.circular(14.0)),
                        ),
                  child: Text(description,
                      style: TextStyle(
                          color: (currentSideTab == index)
                              ? Colors.black
                              : Colors.black26,
                          fontFamily: 'ZillaSlab',
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              blurRadius: 60.0,
                              color: Colors.white,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                          fontWeight: FontWeight.normal)),
                )
            ],
          )),
    );
  }
    
}