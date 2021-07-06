import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';

class Accountsettings extends StatelessWidget {
  const Accountsettings({
    Key key,
    @required this.g_name,
    @required this.onTapGoogleFit,
    @required this.g_email,
    @required this.googleFitSwitched,
  }) : super(key: key);

  final String g_name;
  final String g_email;
  final Function(bool biometric) onTapGoogleFit;
  final bool googleFitSwitched;
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
          child: Text('Account Settings',
              style: TextStyle(
                  fontFamily: 'Milliard',
                  fontSize: Gparam.textSmall,
                  fontWeight: FontWeight.bold)),
        ),
        buildCardWidget(
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Icon(OMIcons.accountCircle)),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    Text('My Account',
                        style: TextStyle(
                            fontFamily: 'Eastman',
                            fontSize: Gparam.textSmaller,
                            color: Theme.of(context).highlightColor)),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30.0)),
                            gradient: new LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Theme.of(context).backgroundColor
                                      : Theme.of(context).primaryColorLight,
                                ],
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                stops: [.2, .8],
                                tileMode: TileMode.repeated),
                          ),
                          child: Text('BASIC',
                              style: TextStyle(
                                fontFamily: 'Eastman',
                                fontSize: Gparam.textVerySmall,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Gparam.heightPadding,
                ),
                Container(
                  height: 12,
                ),
                Container(
                    margin: EdgeInsets.only(top: 0, left: 00),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    decoration: new BoxDecoration(),
                    child: Text(
                      g_name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Eastman',
                        fontSize: Gparam.textSmaller,
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 0, left: 00),
                    padding: EdgeInsets.only(left: 8, top: 0),
                    alignment: Alignment.centerLeft,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          topRight: Radius.circular(0.0),
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(20.0)),
                    ),
                    child: Text(
                      g_email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Milliard',
                        fontSize: Gparam.textSmall,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.withOpacity(.8),
                      ),
                    )),
                Container(height: Gparam.heightPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
                        gradient: new LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Theme.of(context).backgroundColor
                                  : Theme.of(context).primaryColorLight,
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            stops: [.2, .8],
                            tileMode: TileMode.repeated),
                      ),
                      child: Text('UPGRADE',
                          style: TextStyle(
                            fontFamily: 'Eastman',
                            fontSize: Gparam.textVerySmall,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
                        gradient: new LinearGradient(
                            colors: [
                              Colors.redAccent,
                              Colors.redAccent.withOpacity(.8),
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            stops: [.2, .8],
                            tileMode: TileMode.repeated),
                      ),
                      child: Text('SIGNOUT',
                          style: TextStyle(
                            fontFamily: 'Eastman',
                            fontSize: Gparam.textVerySmall,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: Gparam.heightPadding / 2,
                ),
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
                    borderRadius: new BorderRadius.all(Radius.circular(30.0)),
                  ),
                  child: Image.asset('assets/images/google_fit.png',
                      width: 25,
                      height: 25,
                      color: (Theme.of(context).brightness == Brightness.dark)
                          ? Colors.white
                          : Colors.black),
                ),
                SizedBox(
                  width: Gparam.widthPadding / 2,
                ),
                Text('Connect Google Fit',
                    style: TextStyle(
                        fontFamily: 'Eastman',
                        fontSize: Gparam.textSmaller,
                        color: Theme.of(context).highlightColor)),
                Spacer(),
                Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      child: Switch(
                        value: googleFitSwitched,
                        onChanged: (value) async {
                          onTapGoogleFit(value);
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
