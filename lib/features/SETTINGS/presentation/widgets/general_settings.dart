import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/theme/theme.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({
    Key key,
    @required this.onTapBiometric,
    @required this.onTapThemeChange,
    @required this.biometricSwitched,
  }) : super(key: key);

  final bool biometricSwitched;
  final Function(bool biometric) onTapBiometric;
  final Function(String theme) onTapThemeChange;

  Widget buildCardWidget(Widget child, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.05),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black.withAlpha(10)
                    : Theme.of(context).primaryColor.withAlpha(20),
                blurRadius: 1)
          ]),
      margin: EdgeInsets.only(
          left: Gparam.widthPadding,
          right: Gparam.widthPadding,
          top: Gparam.heightPadding / 2),
      padding: EdgeInsets.all(Gparam.widthPadding / 2),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: Gparam.widthPadding,
              top: Gparam.heightPadding * 2,
              bottom: Gparam.heightPadding,
              right: Gparam.widthPadding),
          child: Text('General Settings',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Milliard',
                  fontSize: Gparam.textSmall,
                  fontWeight: FontWeight.bold)),
        ),
        buildCardWidget(
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Icon(OMIcons.formatPaint)),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    Text('Theme',
                        style: TextStyle(
                            fontFamily: 'Eastman',
                            fontSize: Gparam.textSmaller,
                            color: Theme.of(context).highlightColor)),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: Gparam.heightPadding / 2,
                  width: 0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        onTapThemeChange(lightString);
                      },
                      child: Container(
                        width: Gparam.widthPadding * 1.2,
                        height: Gparam.widthPadding * 1.2,
                        margin: EdgeInsets.all(Gparam.widthPadding / 4),
                        decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(60.0)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withAlpha(20),
                                blurRadius: 4)
                          ],
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(.7),
                              ],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onTapThemeChange(darkString);
                      },
                      child: Container(
                        width: Gparam.widthPadding * 1.2,
                        height: Gparam.widthPadding * 1.2,
                        margin: EdgeInsets.all(Gparam.widthPadding / 4),
                        decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(60.0)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.white.withAlpha(10),
                                blurRadius: 15)
                          ],
                          gradient: new LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(.7),
                              ],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              stops: [0.0, 0.7],
                              tileMode: TileMode.clamp),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onTapThemeChange(darkBlueString);
                      },
                      child: Container(
                        width: Gparam.widthPadding * 1.2,
                        height: Gparam.widthPadding * 1.2,
                        margin: EdgeInsets.all(Gparam.widthPadding / 4),
                        decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(60.0)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withAlpha(20),
                                blurRadius: 4)
                          ],
                          gradient: new LinearGradient(
                              colors: [
                                stringToColor("#473B7B"),
                                stringToColor("#30D2BE"),
                              ],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              stops: [0.1, 0.8],
                              tileMode: TileMode.clamp),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onTapThemeChange(lightPinkString);
                      },
                      child: Container(
                        width: Gparam.widthPadding * 1.2,
                        height: Gparam.widthPadding * 1.2,
                        margin: EdgeInsets.all(Gparam.widthPadding / 4),
                        decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(60.0)),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black.withAlpha(20),
                                blurRadius: 4)
                          ],
                          gradient: new LinearGradient(
                              colors: [
                                stringToColor("#fd868c"),
                                stringToColor("#fad0c4"),
                              ],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              stops: [0.1, 0.8],
                              tileMode: TileMode.clamp),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            context),
        buildCardWidget(
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular(60.0)),
                    ),
                    child: Icon(
                        (biometricSwitched) ? OMIcons.lock : OMIcons.lockOpen)),
                SizedBox(
                  width: Gparam.widthPadding / 2,
                ),
                Text('Biometric Lock',
                    style: TextStyle(
                        fontFamily: 'Eastman',
                        fontSize: Gparam.textSmaller,
                        color: Theme.of(context).highlightColor)),
                Spacer(),
                Row(
                  children: <Widget>[
                    Container(
                      child: Switch(
                        value: biometricSwitched,
                        onChanged: (value) {
                          if (biometricSwitched != value) onTapBiometric(value);
                        },
                        activeColor:
                            (Theme.of(context).brightness == Brightness.dark)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColor,
                        activeTrackColor:
                            (Theme.of(context).brightness == Brightness.dark)
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).primaryColorLight,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ],
                )
              ],
            ),
            context),
      ],
    );
  }
}
