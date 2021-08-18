import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/presentation/blogs_bloc/blogs_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/blogs/blog_widget.m.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/features/HOME/presentation/widgets/heading.dart';

class HomeBlogWidget extends StatelessWidget {
  const HomeBlogWidget({
    Key key,
    @required this.blogBloc,
  }) : super(key: key);

  final BlogBloc blogBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => blogBloc,
      child: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogInitial)
            return Container(height: 0, width: 0);
          else if (state is BlogError) {
            return Center(child: Gtheme.stext(state.message));
          } else if (state is BlogLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeading(
                  heading: "Blogs",
                  subHeading: "Curated just for you",
                ),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(width: Gparam.widthPadding / 2),
                      ...state.blogs
                          .asMap()
                          .entries
                          .map((e) => HomeBlogWidgetM(
                              blog: state.blogs,
                              index: e.key,
                              onClick: (blog, index) {
                               
                              }))
                          .toList()
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
