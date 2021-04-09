import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/widgets/animated_fab.dart';
import 'package:sorted/features/PROFILE/presentation/page/profile_main_page.dart';
import 'package:sorted/features/SETTINGS/presentation/pages/settings_page.dart';

class RootHome extends StatefulWidget {
  @override
  _RootHomeState createState() => _RootHomeState();
}

class _RootHomeState extends State<RootHome> {
  int _currentIndex = 0;

  final _libraryScreen = GlobalKey<NavigatorState>();
  final _playlistScreen = GlobalKey<NavigatorState>();
  final _searchScreen = GlobalKey<NavigatorState>();
  final _bibleScreen = GlobalKey<NavigatorState>();
  final _settingsScreen = GlobalKey<NavigatorState>();
  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Flutter Step-by-Step",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            _createDrawerItem(
              icon: Icons.contacts,
              text: 'Contacts',
            ),
            _createDrawerItem(
              icon: Icons.event,
              text: 'Events',
            ),
            _createDrawerItem(
              icon: Icons.note,
              text: 'Notes',
            ),
            Divider(),
            _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
            _createDrawerItem(icon: Icons.face, text: 'Authors'),
            _createDrawerItem(
                icon: Icons.account_box, text: 'Flutter Documentation'),
            _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
            Divider(),
            _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
            ListTile(
              title: Text('0.0.1'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              Navigator(
                key: _libraryScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => SortedHome(),
                ),
              ),
              Navigator(
                key: _playlistScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => SettingsPage(),
                ),
              ),
              Navigator(
                key: _searchScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => SettingsPage(),
                ),
              ),
              Navigator(
                key: _bibleScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => SettingsPage(),
                ),
              ),
              Navigator(
                key: _settingsScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => ProfilePage(),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              selectedItemColor: Theme.of(context).highlightColor,
              unselectedItemColor: Colors.grey.withOpacity(.6),
              onTap: (val) => _onTap(val, context),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              items: [
                new BottomNavigationBarItem(
                  icon: new Icon(MdiIcons.homeLightbulbOutline),
                  title: new Text("Home"),
                ),
                new BottomNavigationBarItem(
                  icon: new Icon(MdiIcons.accountSearchOutline),
                  title: new Text("Search"),
                ),
                new BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      Icon(Icons.add),
                    ],
                  ),
                  title: new Text(""),
                ),
                new BottomNavigationBarItem(
                  icon: new Icon(MdiIcons.dotsHexagon),
                  title: new Text("Spaces"),
                ),
                new BottomNavigationBarItem(
                  icon: new Icon(MdiIcons.emoticonExcitedOutline),
                  title: new Text("Me"),
                )
              ],
            ),
          ),
          new Positioned(
            bottom: -60,
            width: Gparam.width,
            child: new AnimatedFab(
              onClick: _changeFilterState,
            ),
          ),
        ],
      ),
    );
  }

  void _changeFilterState() {}

  void _onTap(int val, BuildContext context) {
    if (_currentIndex == val) {
      switch (val) {
        case 0:
          _libraryScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 1:
          _playlistScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 2:
          _searchScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 3:
          _bibleScreen.currentState.popUntil((route) => route.isFirst);
          break;
        case 4:
          _settingsScreen.currentState.popUntil((route) => route.isFirst);
          break;
        default:
      }
    } else {
      if (mounted) {
        setState(() {
          _currentIndex = val;
        });
      }
    }
  }
}