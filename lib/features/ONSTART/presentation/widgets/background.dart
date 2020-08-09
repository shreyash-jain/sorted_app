import 'package:flutter/material.dart';

class Background extends StatelessWidget {
 

  const Background({
    Key key,
  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SingleChildScrollView(
          child: Icon(
            Icons.fingerprint,
            size: 50,
          ),
        ),
      ),
    );
  }
}
