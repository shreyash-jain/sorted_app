import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key key,
    @required this.widget,
    
    @required int currentPage,
   
  }) : _currentPage = currentPage, super(key: key);

  final LoginPage widget;
  
  final int _currentPage;
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceAround,
      children: [
        if (widget.valid == null ||
            widget.valid <= 1)
          Container(
              width: Gparam.height / 60,
              height: Gparam.height / 60,
              decoration: BoxDecoration(
                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
                color: (_currentPage == 0)
                    ? Colors.white30
                    : (widget.valid != null &&
                            widget.valid > 1)
                        ? Colors.black
                            .withOpacity(.09)
                        : Colors.red
                            .withOpacity(.3),
              )),
        if (widget.valid != null &&
            widget.valid > 1)
          Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),

                color:
                    Colors.black.withOpacity(.09),
              ),
              child: Icon(Icons.check,
                  color: Colors.black26)),
        if (widget.valid != null &&
            widget.valid <= 3)
          Container(
              width: Gparam.height / 60,
              height: Gparam.height / 60,
              decoration: BoxDecoration(
                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
                color: (_currentPage == 1)
                    ? Colors.white24
                    : (widget.valid > 3 ||
                            _currentPage < 1)
                        ? Colors.black
                            .withOpacity(.09)
                        : Colors.red
                            .withOpacity(.3),
              )),
        if (widget.valid != null &&
            widget.valid > 3)
          Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),

                color:
                    Colors.black.withOpacity(.09),
              ),
              child: Icon(Icons.check,
                  color: Colors.black26)),
        if (_currentPage < 2)
          Container(
              width: Gparam.height / 60,
              height: Gparam.height / 60,
              decoration: BoxDecoration(
                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
                color:
                    Colors.black.withOpacity(.09),
              )),
        if (_currentPage >= 2)
          Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),

                color:
                    Colors.black.withOpacity(.09),
              ),
              child: Icon(Icons.check,
                  color: Colors.black26)),
        if (_currentPage < 3)
          Container(
              width: Gparam.height / 60,
              height: Gparam.height / 60,
              decoration: BoxDecoration(
                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)),
                color:
                    Colors.black.withOpacity(.09),
              )),
        if (_currentPage >= 3)
          Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Theme.of(context).primaryColor, width: 5),

                color:
                    Colors.black.withOpacity(.09),
              ),
              child: Icon(Icons.check,
                  color: Colors.black26)),
      ],
    );
  }
}