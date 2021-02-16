import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/PLAN/presentation/bloc/cover_change_bloc/cover_bloc.dart';
import 'package:sorted/features/PLAN/presentation/bloc/goal_page_bloc/goal_page_bloc.dart';
import 'package:sorted/features/PLAN/presentation/bloc/task_bloc/plan_bloc.dart';

class SelectCover extends StatefulWidget {
  final GoalPageBloc goalBloc;
  const SelectCover({Key key, this.goalBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SelectCoverState();
}

class SelectCoverState extends State<SelectCover> {
  CoverBloc bloc;

  FocusNode searchFocus = FocusNode();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    bloc = sl<CoverBloc>()..add(LoadImages());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Center(child: buildBody(context));
      })),
    );
  }

  BlocProvider<CoverBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Center(
        child: ListView(
          children: <Widget>[
            // Top half
            BlocBuilder<CoverBloc, CoverState>(
              builder: (context, state) {
                if (state is ErrorCover) {
                  return MessageDisplay(
                    message: 'Start searching!',
                  );
                } else if (state is CoverLoading) {
                  return LoadingWidget();
                } else if (state is CoverLoaded) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(OMIcons.arrowBackIos,
                                color: Theme.of(context).primaryColor),
                            tooltip: 'back',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(OMIcons.search,
                                color: Theme.of(context).primaryColor),
                            tooltip: 'reminders',
                            onPressed: () {
                              bloc.add(StartSearchEvent());
                            },
                          ),
                          InkWell(
                            onTap: () {
                              bloc.add(StartSearchEvent());
                            },
                            child: Container(
                              padding: EdgeInsets.all(0),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Search ',
                                  style: TextStyle(
                                      fontFamily: 'Lemonmilk',
                                      fontSize: Gparam.textMedium,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'powered by',
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10,
                                        )),
                                    TextSpan(
                                        text: ' unsplash.com',
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Gparam.heightPadding,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Gparam.widthPadding,
                          ),
                          Container(
                            padding: EdgeInsets.all(0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Gradients',
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Gparam.textMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 240,
                        margin: EdgeInsets.only(left: Gparam.widthPadding),
                        child: GridView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.gradientUrls.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (2),
                            childAspectRatio: .7,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildImageTile(
                              index,
                              state.gradientUrls[index],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: Gparam.heightPadding,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Gparam.widthPadding,
                          ),
                          Container(
                            padding: EdgeInsets.all(0),
                            child: RichText(
                              text: TextSpan(
                                text: ' Work',
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Gparam.textMedium,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' goals',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: Gparam.textSmall,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 300,
                        margin: EdgeInsets.only(left: Gparam.widthPadding),
                        child: GridView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.workUrls.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (3),
                            childAspectRatio: .7,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildImageTile(
                              index,
                              state.workUrls[index],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: Gparam.heightPadding,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Gparam.widthPadding,
                          ),
                          Container(
                            padding: EdgeInsets.all(0),
                            child: RichText(
                              text: TextSpan(
                                text: ' Study',
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Gparam.textMedium,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' goals',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: Gparam.textSmall,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 240,
                        margin: EdgeInsets.only(left: Gparam.widthPadding),
                        child: GridView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.studyUrls.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (2),
                            childAspectRatio: .7,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildImageTile(
                              index,
                              state.studyUrls[index],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: Gparam.heightPadding,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Gparam.widthPadding,
                          ),
                          Container(
                            padding: EdgeInsets.all(0),
                            child: RichText(
                              text: TextSpan(
                                text: ' Get',
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Gparam.textSmall,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' Inspired',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: Gparam.textMedium,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 240,
                        margin: EdgeInsets.only(left: Gparam.widthPadding),
                        child: GridView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.inspireUrls.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (2),
                            childAspectRatio: .7,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildImageTile(
                              index,
                              state.inspireUrls[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is StartSearchState) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: Gparam.heightPadding,
                            left: Gparam.widthPadding,
                            right: Gparam.widthPadding),
                        child: Row(
                          children: [
                            RichText(
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              text: TextSpan(
                                text: "Search\n",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Gparam.textMedium,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "powered by ",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        height: 1.2,
                                        fontWeight: FontWeight.w300,
                                        fontSize: Gparam.textVerySmall,
                                      )),
                                  TextSpan(
                                      text: "Unsplash.com",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        height: 1.2,
                                        fontWeight: FontWeight.w800,
                                        fontSize: Gparam.textVerySmall,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Gparam.heightPadding,
                            left: Gparam.widthPadding,
                            right: Gparam.widthPadding),
                        child: FadeAnimationTB(
                            .3,
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: new BoxDecoration(
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(16.0)),
                                gradient: new LinearGradient(
                                    colors: [
                                      Theme.of(context)
                                          .primaryColor
                                          .withAlpha(50),
                                      Theme.of(context)
                                          .primaryColor
                                          .withAlpha(60),
                                    ],
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    stops: [0.3, 1],
                                    tileMode: TileMode.clamp),
                              ),
                              child: TextField(
                                focusNode: searchFocus,
                                controller: searchController,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                onChanged: (text) {
                                  // try{
                                  //  BlocProvider.of<UserIntroductionBloc>(context)
                                  //     .add(UpdateAge(int.parse(text)));
                                  // }
                                  // on Exception{
                                  //   BlocProvider.of<UserIntroductionBloc>(context)
                                  //     .add(UpdateAge(0));
                                  // }
                                },
                                onSubmitted: (text) {
                                  bloc.add(SearchUnsplash(text));
                                },
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: Gparam.textMedium,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w800),
                                decoration: InputDecoration.collapsed(
                                  hintText: 'start searching ...',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.5),
                                      fontSize: Gparam.textMedium,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500),
                                  border: InputBorder.none,
                                ),
                              ),
                            )),
                      )
                    ],
                  );
                } else if (state is SearchLoaded) {
                  return Container(
                    height: 800,
                    margin: EdgeInsets.only(left: Gparam.widthPadding),
                    child: GridView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: state.images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: (5),
                        childAspectRatio: .7,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildUnsplashImageTile(
                          index,
                          state.images[index],
                        );
                      },
                    ),
                  );
                } else if (state is SearchLoading) {
                  return Container(
                      height: Gparam.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingWidget(),
                        ],
                      ));
                }
              },
            ),
            SizedBox(height: 20),
            FlatButton(
              child: Text('FlatButton'),
              onPressed: () {
                //bloc.add(TestEvent());
              },
            ),

            // Bottom half
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(int i, String gradientUrl) {
    return InkWell(
      onTap: () {
        widget.goalBloc.add(UpdateGoalCover(gradientUrl));
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(right: 8, top: Gparam.heightPadding),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              placeholder: (context, url) => Center(
                child: Container(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    strokeWidth: 3,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: Colors.grey,
              ),
              imageUrl: gradientUrl,
              fit: BoxFit.cover,
              width: 200,
            )),
      ),
    );
  }

  Widget _buildUnsplashImageTile(int index, UnsplashImage image) {
    return InkWell(
      onTap: () {
        widget.goalBloc.add(UpdateGoalCover(image.imageUrl));
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(right: 8, top: Gparam.heightPadding),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              placeholder: (context, url) => Center(
                child: Container(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    strokeWidth: 3,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: Colors.grey,
              ),
              imageUrl: image.imageUrl,
              fit: BoxFit.cover,
              width: 200,
            )),
      ),
    );
  }
}
