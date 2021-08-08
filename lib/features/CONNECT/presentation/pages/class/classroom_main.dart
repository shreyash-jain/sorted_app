import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/presentation/class_notice.dart';
import 'package:sorted/features/CONNECT/presentation/resources/class_resources.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/chat/chat_main.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/summary/class_summary.dart';
import 'package:sorted/features/CONNECT/presentation/workout/classroom_workout.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ClassroomMain extends StatefulWidget {
  final ClassModel classroom;

  var updateClass;
  ClassroomMain({Key key, this.classroom}) : super(key: key);

  @override
  _ClassroomMainState createState() => _ClassroomMainState();
}

class _ClassroomMainState extends State<ClassroomMain>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ClassroomMain> {
  @override
  bool get wantKeepAlive => true;
  TabController tab_controller;
  int _currentIndex = 0;
  String tabName = "Summary";
  ClassModel _classroom = ClassModel();

  @override
  void initState() {
    _classroom = widget.classroom;
    tab_controller = TabController(length: 5, vsync: this);

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
          tabName = "Clients";
        });

        break;
      case 2:
        setState(() {
          tabName = "Workout";
        });

        break;
      case 3:
        setState(() {
          tabName = "Performance";
        });

        break;
      case 4:
        setState(() {
          tabName = "Chat";
        });

        break;
      case 5:
        setState(() {
          tabName = "Notice Board";
        });
        break;
      case 6:
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
                        Gtheme.stext(_classroom.name,
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
                Spacer(),
                Icon(
                  MdiIcons.pen,
                  color: Colors.black45,
                  size: 30,
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
                              MdiIcons.yoga,
                              color: (_currentIndex == 1)
                                  ? Colors.black45
                                  : Colors.black12,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              MdiIcons.message,
                              color: (_currentIndex == 2)
                                  ? Colors.black45
                                  : Colors.black12,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              MdiIcons.projectorScreen,
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
                ClassroomSummary(classroom: _classroom),
                // ClassroomClientList(
                //   classroom: _classroom,
                // ),
                ClassroomWorkout(classroom: _classroom),

                ChatWidget(classroom: _classroom),
                ChatNoticeBoardWidget(classroom: _classroom),
                ClassResourcesWidget(),
              ],
            ),
          ),
        ));
  }

  updateClass(ClassModel p1) {
    setState(() {
      _classroom = p1;
    });
    print("update at classmain");
    if (widget.updateClass != null) {
      widget.updateClass(p1);
    }
  }
}
