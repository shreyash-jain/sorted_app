import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/consultation_chat/consultation_chat_main.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/consultation_resources/consultation_resources.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/planner/consultation_planner.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/summary/consultation_summary.dart';

class ConsultationMain extends StatefulWidget {
  final ClientConsultationModel consultation;

  ConsultationMain({Key key, this.consultation}) : super(key: key);

  @override
  _ConsultationMainState createState() => _ConsultationMainState();
}

class _ConsultationMainState extends State<ConsultationMain>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ConsultationMain> {
  @override
  bool get wantKeepAlive => true;
  TabController tab_controller;
  int _currentIndex = 0;
  String tabName = "Summary";

  @override
  void initState() {
    tab_controller = TabController(length: 4, vsync: this);

    tab_controller.addListener(_handleTabSelection);

    super.initState();
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = tab_controller.index;
    });

    switch (_currentIndex) {
      case 0:
        setState(() {
          tabName = "Summary";
        });

        break;
      case 1:
        setState(() {
          tabName = "Planner";
        });

        break;
      case 2:
        setState(() {
          tabName = "Performance";
        });

        break;
      case 3:
        setState(() {
          tabName = "Chat";
        });

        break;
      case 4:
        setState(() {
          tabName = "Resources";
        });

        break;

      default:
    }
  }

  @override
  void dispose() {
    tab_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), // here the desired height
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 2,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Gtheme.stext(widget.consultation.packageName,
                            size: GFontSize.S, weight: GFontWeight.B1),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Gtheme.stext(tabName,
                            size: GFontSize.XS, weight: GFontWeight.L),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: DefaultTabController(
          length: 7,
          child: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      pinned: true,
                      primary: false, // no reserve space for status bar
                      toolbarHeight: 0, // title height = 0
                      collapsedHeight: 0,
                      forceElevated: innerBoxIsScrolled,
                      floating: true,

                      snap: false,
                      bottom: TabBar(
                        indicatorWeight: 3,
                        controller: tab_controller,
                        indicatorColor: Colors.black26,
                        tabs: [
                          Tab(
                            icon: Icon(
                              MdiIcons.viewDashboardVariant,
                              color: (_currentIndex == 0)
                                  ? Colors.black45
                                  : Colors.black12,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              MdiIcons.notebookCheck,
                              color: (_currentIndex == 1)
                                  ? Colors.black45
                                  : Colors.black12,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              MdiIcons.message,
                              color: (_currentIndex == 3)
                                  ? Colors.black45
                                  : Colors.black12,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              MdiIcons.bookshelf,
                              color: (_currentIndex == 4)
                                  ? Colors.black45
                                  : Colors.black12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: tab_controller,
              children: [
                ConsultationSummary(consultation: widget.consultation),
                ConsultationPlanner(consultation: widget.consultation),
                ConsultationChatWidget(consultation: widget.consultation),
                ConsultationResourcesWidget(consultation: widget.consultation),
              ],
            ),
          ),
        ));
  }
}
