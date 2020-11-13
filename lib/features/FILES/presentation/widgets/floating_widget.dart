import 'package:flutter/material.dart';

class FloatingWidget extends StatelessWidget {
  final Widget child;

  const FloatingWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .7,
      child: child,
    );
  }
}
