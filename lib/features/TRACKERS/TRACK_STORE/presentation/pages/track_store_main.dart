import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';

import './market_page.dart';

class TrackStoreMain extends StatefulWidget {
  @override
  _TrackStoreMainState createState() => _TrackStoreMainState();
}

class _TrackStoreMainState extends State<TrackStoreMain> {
  @override
  Widget build(BuildContext context) {
    final _tabs = [
      "all",
      "hello",
      "there",
      "younes",
      "sdfsdf",
      "dsfjls",
      "jsldfjslkj"
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: DefaultTabController(
          length: _tabs.length,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    height: Gparam.topPadding / 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      height: Gparam.topPadding,
                      width: Gparam.width * 0.8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius:
                            BorderRadius.circular(Gparam.topPadding / 4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.menu),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Search for something here',
                            // style: TextStyle(
                            //     color:
                            //         Theme.of(context).textSelectionHandleColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: Gparam.topPadding / 2,
                  ),
                ),
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: TabBar(
                    labelColor: Theme.of(context).highlightColor,
                    indicatorColor: Theme.of(context).textSelectionColor,
                    isScrollable: true,
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: _tabs.map((String name) {
                if (name == _tabs[0]) return MarketPage();
                return Text(name);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
