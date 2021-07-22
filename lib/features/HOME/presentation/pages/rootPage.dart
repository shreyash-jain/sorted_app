import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/features/FEED/presentation/pages/feed_main.dart';

import 'package:sorted/features/HOME/presentation/pages/connect_page.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';

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
              child: Text("Sort It",
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
                  builder: (context) => ConnectPage(),
                ),
              ),
              Navigator(
                key: _bibleScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => FeedHomePage(),
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
                  icon: new Icon(MdiIcons.homeOutline),
                  title: new Text("Home"),
                ),
                new BottomNavigationBarItem(
                  icon: new Icon(MdiIcons.accountSearchOutline),
                  title: new Text("Explore"),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(MdiIcons.postOutline),
                  title: new Text("Feed"),
                ),
                new BottomNavigationBarItem(
                  icon: new Icon(MdiIcons.emoticonExcitedOutline),
                  title: new Text("Me"),
                )
              ],
            ),
          ),
          // new Positioned(
          //     bottom: -3,
          //     right: 0,
          //     width: Gparam.width,
          //     child: Center(
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: MeWeButton(isMe: true, onChanged: null),
          //       ),
          //     )),
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
