import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:core';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/global/blocs/deeplink_bloc/deeplink_bloc.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/cache_deep_link.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/deep_link_data/deep_link_data.dart';

import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/CONNECT/presentation/pages/class_list.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/presentation/blogs_bloc/blogs_bloc.dart';
import 'package:sorted/features/HOME/presentation/pages/camera_screen.dart';
import 'package:sorted/features/HOME/presentation/recipe_bloc/recipe_bloc.dart';
import 'package:sorted/features/HOME/presentation/transformation_bloc/transformation_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/blogs/home_blog.dart';
import 'package:sorted/features/HOME/presentation/widgets/planner/home_planner.dart';
import 'package:sorted/features/HOME/presentation/widgets/recipes/home_recipe.dart';

import 'package:sorted/features/HOME/presentation/widgets/flexible_safe_area.dart';
import 'package:sorted/features/HOME/presentation/widgets/right_side_opener.dart';
import 'package:sorted/features/HOME/presentation/widgets/me_we_switch.dart';

import 'package:sorted/features/HOME/presentation/widgets/side_tab.dart';

import 'package:sorted/features/HOME/presentation/widgets/slide_stack.dart';
import 'package:sorted/features/HOME/presentation/widgets/transformation/transformation_widget.m.dart';

import 'package:supercharged/supercharged.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class SortedHome extends StatefulWidget {
  SortedHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SortedHomeState createState() => _SortedHomeState();
}

class _SortedHomeState extends State<SortedHome>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  BlogBloc blogBloc;
  StreamSubscription<DeepLinkType> _deeplinkSubscription;
  TransformationBloc transBloc;
  DeeplinkBloc deeplinkBloc;
  RecipeBloc recipeBloc;
  var bottomNavIndex = 0;
  int currentBottomTab;
  int currentSideTab;
  var formatterDate = new DateFormat('dd-MM-yyyy');
  List<String> imagePath = [];
  List<int> imageTotal = [];
  List<String> inspirations = [];
  bool isMe = true;
  bool isNavEnabled = false;
  bool isSearchEmpty = true;
  Shader linearGradient;
  String name = "Shreyash";
  ScrollController nestedScrollController;
  Animation<double> positionAnimation;
  AnimationController positionController;
  SharedPreferences prefs;
  double currentSliverheight, prevSliverHeight;
  Reference refStorage = FirebaseStorage.instance.ref();
  StreamSubscription deeplinkStateSubscription;

  bool showSideTab = true;
  Animation<double> tabAnimation;
  AnimationController tabController;
  TabController tab_Controller;
  DateTime today = DateTime.now();
  double top;

  final _cameraKey = GlobalKey<CameraScreenState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (deeplinkStateSubscription != null) deeplinkStateSubscription.cancel();

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    tab_Controller = new TabController(length: 2, vsync: this);
    blogBloc = sl<BlogBloc>()..add(LoadBlogs());
    recipeBloc = sl<RecipeBloc>()..add(LoadRecipes());
    transBloc = sl<TransformationBloc>()..add(LoadTransformation());

    nestedScrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );

    tabController = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this)
      ..addListener(() => setState(() {}));
    tabAnimation = Tween<double>(begin: 0, end: Gparam.width / 7).animate(
        new CurvedAnimation(parent: tabController, curve: Curves.decelerate));

    positionController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    positionAnimation =
        Tween<double>(begin: 0.0, end: 0.0).animate(positionController);

    WidgetsBinding.instance.addPostFrameCallback((_) => runAfterBuild(context));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void afterBuild() {}

  void _toEnd() {
    // NEW
    if (nestedScrollController != null)
      nestedScrollController.animateTo(
        // NEW
        nestedScrollController.position.minScrollExtent, // NEW
        duration: const Duration(milliseconds: 500), // NEW
        curve: Curves.decelerate, // NEW
      ); // NEW
  }

  void _toStart() {
    // NEW
    if (nestedScrollController != null)
      nestedScrollController.animateTo(
        // NEW
        nestedScrollController.position.maxScrollExtent, // NEW
        duration: const Duration(milliseconds: 500), // NEW
        curve: Curves.decelerate, // NEW
      ); // NEW
  }

  onChanged(bool newBool) {
    setState(() {
      isMe = newBool;
    });
  }

  void _changeFilterState() {}

  void onSideTabSelected(int toIndex) {
    print(toIndex);

    if (toIndex == 0) {
      print("introspect");
      context.router.push(
        TrackStoreMain(),
      );
    } else if (toIndex == 1) {
      print("plan");
    } else if (toIndex == 2) {
      print("record");
    }
    if (currentSideTab == toIndex)
      setState(() {
        currentSideTab = null;
      });
    else
      setState(() {
        currentSideTab = toIndex;
      });
  }

  void onBottomTabSelected(int index) {
    setState(() {
      currentBottomTab = index;
    });
  }

  void onSlide(double value) {}

  onClickBlog(List<BlogModel> blog, int index) {
    context.router.push(
      FullBlogRoute(blog: blog[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeeplinkBloc>(),
      child: BlocListener<DeeplinkBloc, DeeplinkState>(
        listener: (context, state) {
          print("got data from deep link   -   >   no chills");
          if (state is DeeplinkLoaded) {
            print("got data from deep link   -   >   ahha");
            switch (state.type.type) {
              case 1:
                print("got data from deep link   -   >   1");
                context.router.push(
                    ClassListRoute(classId: state.classEnrollData.classId));

                deeplinkBloc.add(ResetData());

                break;
              default:
            }
          } else {
            print("data from deep link no data");
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
            body: SafeArea(child: new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  CustomPaint(
                      child: NestedScrollView(
                    controller: nestedScrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverSafeArea(
                        top: false,
                        sliver: SliverAppBar(
                          elevation: 5,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shadowColor: Colors.black26,
                          leading: Container(),
                          actions: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            ChatIconWidget(),
                          ],
                          expandedHeight: 190,
                          pinned: true,
                          primary: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(0.0)),
                          ),
                          flexibleSpace: LayoutBuilder(builder:
                              (BuildContext context,
                                  BoxConstraints constraints) {
                            currentSliverheight = constraints.biggest.height;
                            print(currentSliverheight);

                            bool direction;
                            if (prevSliverHeight != null &&
                                prevSliverHeight > currentSliverheight) {
                              direction = false;
                            } else if (prevSliverHeight != null &&
                                prevSliverHeight < currentSliverheight)
                              direction = true;

                            prevSliverHeight = currentSliverheight;

                            return FlexibleSpaceArea(
                                currentSliverheight: currentSliverheight,
                                name: name);
                          }),
                        ),
                      ),
                    ],
                    body: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Transform.translate(
                              offset: Offset(tabAnimation.value, 0.0),
                              child: AnimatedContainer(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                width: Gparam.width,
                                duration: Duration(milliseconds: 700),
                                child: ListView(children: <Widget>[
                                  HomePlanner(),
                                  Row(
                                    children: [
                                      HomeTransformationWidgetM(
                                        transBloc: transBloc,
                                      ),
                                    ],
                                  ),
                                  HomeRecipeWidget(
                                    recipeBloc: recipeBloc,
                                  ),
                                  HomeBlogWidget(blogBloc: blogBloc),
                                  SizedBox(
                                    height: 100,
                                  )
                                ]),
                              ),
                            )
                          ],
                        )),
                  )),
                  //
                  //! Side bar

                  //! bottom tab
                ],
              );
            }))),
      ),
    );
  }

  runAfterBuild(BuildContext context) {}
}

class ChatIconWidget extends StatelessWidget {
  const ChatIconWidget({
    Key key,
    this.isActiveChat,
  }) : super(key: key);

  final bool isActiveChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Icon(
              OMIcons.chat,
              color: Theme.of(context).highlightColor,
              size: 28,
            ),
            tooltip: 'Settings',
            onPressed: () {},
          ),
          Positioned(
            right: 8,
            bottom: 15,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.redAccent, // border color
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
