import 'package:flutter/material.dart';

class OnSuccessWidget extends StatelessWidget {
 

  const OnSuccessWidget({
    Key key,
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SingleChildScrollView(
          child: Icon(
            Icons.check,
            size: 200,
            color:Colors.black12
          ),
        ),
      ),
    );
  }
}
