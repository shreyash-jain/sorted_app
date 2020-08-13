import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("splash");
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/SortedLogo.png',
          key: const Key('splash_bloc_image'),
          width: 150,
        ),
      ),
    );
  }
}
