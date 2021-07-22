import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';

class BuildHomeHeader extends StatelessWidget {
  const BuildHomeHeader({
    Key key,
    @required this.dateOnClick,
    @required PageController controller,
    @required this.selectedDate,
    @required this.today,
    @required this.datesFit,
    @required this.context,
  })  : _controller = controller,
        super(key: key);

  final PageController _controller;
  final DateTime today;
  final Function(DateTime date) dateOnClick;
  final DateTime selectedDate;
  final int datesFit;
  final BuildContext context;
  Widget _buildActivityCard(int index, DateTime startDate) {
    String count = "";

    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          height: 85,
          width: Gparam.width,
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 0,
                  ),
                  ...makeDateRow(startDate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> makeDateRow(DateTime startDate) {
    List<Widget> datesWidget = [];

    for (var i = 0; i < datesFit; i++) {
      datesWidget.add(makeDateTile(startDate.add(Duration(days: i))));
    }
    return datesWidget;
  }

  Widget makeDateTile(DateTime tileDate) {
    return InkWell(
      onTap: () {
        dateOnClick(tileDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  DateFormat('E').format(tileDate).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Milliard',
                      fontSize: 14,
                      color: (isSameDate(tileDate, today))
                          ? Colors.black
                          : Colors.black26,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                DateFormat('dd').format(tileDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Milliard',
                    fontSize: 16,
                    color: (isSameDate(tileDate, today))
                        ? Colors.black
                        : Colors.black26,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (isSameDate(tileDate, selectedDate))
            Container(
              width: 30,
              height: 3,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            )
        ],
      ),
    );
  }

  bool isSameDate(DateTime thisDate, DateTime other) {
    return thisDate.year == other.year &&
        thisDate.month == other.month &&
        thisDate.day == other.day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
            child: Container(
              height: 70,
              color: Colors.grey.withOpacity(.05),
              child: Padding(
                padding: EdgeInsets.only(left: 0),
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 100,
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildActivityCard(index,
                          today.add(Duration(days: (index - 50) * datesFit)));
                    }),
              ),
            )),
      ],
    );
  }
}
