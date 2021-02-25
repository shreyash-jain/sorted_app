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
      "Suggested",
      "Fitness",
      "Mindfulness",
      "Nutrition",
      "Relationship",
      "Career",
      "Finance"
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
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding / 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor.withOpacity(.1),
                        borderRadius:
                            BorderRadius.circular(Gparam.topPadding / 4),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.menu),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Search Track & Lifestyle',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).highlightColor,
                                fontSize: Gparam.textSmaller,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: Column(
                    children: [
                      TabBar(
                        
                        indicatorColor: Theme.of(context).textSelectionColor,
                        labelColor: Theme.of(context).textSelectionColor,
                        labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                       
                                        fontSize: Gparam.textVerySmall,
                                        fontWeight: FontWeight.w500),

                       
                        isScrollable: true,
                        unselectedLabelColor: Theme.of(context).highlightColor,
                        tabs: _tabs
                            .map((String name) => Tab(
                                  text: 
                                    name
                                  
                                ))
                            .toList(),
                      ),
                      Divider(height: 1,color: Colors.grey,)
                    ],
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
