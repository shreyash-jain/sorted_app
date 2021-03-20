import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/track_comments/track_comments_bloc.dart';
import '../../domain/entities/track_comment.dart';
import '../widgets/single_comment.dart';
import '../bloc/track_comments/track_comments_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/global/injection_container.dart';
import '../../../../../core/global/constants/constants.dart';

class TrackCommentsPage extends StatefulWidget {
  final int track_id;
  TrackCommentsPage({@required this.track_id});
  @override
  _TrackCommentsPageState createState() => _TrackCommentsPageState();
}

class _TrackCommentsPageState extends State<TrackCommentsPage> {
  List<TrackComment> trackComments = [];
  TrackCommentsBloc commentsBloc;
  ScrollController controller = ScrollController();
  int size = 25;
  bool isEmty = false;
  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      commentsBloc.add(
        GetTrackCommentsEvent(
          trackComments: trackComments,
          size: 25,
          track_id: widget.track_id,
        ),
      );
    }
  }

  @override
  void initState() {
    commentsBloc = sl();
    commentsBloc.add(
      GetTrackCommentsEvent(
        trackComments: [],
        size: 25,
        track_id: widget.track_id,
      ),
    );
    controller.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    commentsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Comments",
            style: Gtheme.textBold.copyWith(
              fontSize: Gparam.textSmaller,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          // backgroundColor: Theme.of(context).highlightColor,
        ),
        body: BlocProvider<TrackCommentsBloc>(
          create: (_) => commentsBloc,
          child: BlocListener<TrackCommentsBloc, TrackCommentsState>(
            listener: (_, state) {
              if (state is GetTrackCommentsLoadedState) {
                trackComments = state.comments;
                if (trackComments.isEmpty) {
                  isEmty = true;
                }
              }
            },
            child: BlocBuilder<TrackCommentsBloc, TrackCommentsState>(
              builder: (context, state) {
                if (state is GetTrackCommentsLoadingState) {
                  return _buildLoading();
                }
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: isEmty ? _buildEmpty() : _buildList(),
                      ),
                    ),
                    Visibility(
                      visible: state is GetTrackCommentsLoadingPaginationState,
                      child: Container(
                        height: 40,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      controller: controller,
      itemCount: trackComments.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Container(height: Gparam.topPadding);
        }
        return SingleComment(
          trackComment: trackComments[i - 1],
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        "No Comment to show",
        style: Gtheme.textNormal.copyWith(fontSize: Gparam.textSmall),
      ),
    );
  }
}
