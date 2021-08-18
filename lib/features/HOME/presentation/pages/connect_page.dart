import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/action_button.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/utils/action_button_orange.dart';

class ConnectPage extends StatefulWidget {
  ConnectPage({Key key}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [Image(image: AssetImage('assets/images/explore.png'))],
          ),
        ),
      ),
    );
  }
}
