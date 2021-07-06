import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';

import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/presentation/blogs_bloc/blogs_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/blogs/textbox_widget.dart';
import 'package:zefyr/zefyr.dart';

class FullBlogPage extends StatefulWidget {
  final BlogModel blog;
  FullBlogPage({Key key, this.blog}) : super(key: key);

  @override
  _FullBlogPageState createState() => _FullBlogPageState();
}

class _FullBlogPageState extends State<FullBlogPage> {
  BlogBloc blogBloc;
  NotusDocument introDocument;
  ZefyrThemeData theme;

  @override
  void initState() {
    blogBloc = BlogBloc(sl())..add(LoadTextBox(widget.blog));

    introDocument = _loadDocument(widget.blog.base_content);

    super.initState();
  }

  NotusDocument _loadDocument(String text) {
    return NotusDocument.fromJson(jsonDecode(
        text.replaceAll(r'"u"', r'"i"').replaceAll(r'\\\\n', r'\n')));
  }

  @override
  Widget build(BuildContext context) {
    final defaultLineTheme = LineTheme(
      textStyle: TextStyle(
        fontFamily: 'Milliard',
        wordSpacing: 1.2,
        height: 1.5,
        color: (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black,
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
    );
    theme = ZefyrThemeData(
      defaultLineTheme: defaultLineTheme,
      attributeTheme: AttributeTheme.fallback(context, defaultLineTheme),
      indentWidth: 12.0,
      toolbarTheme: ToolbarTheme.fallback(context),
    );
    return Scaffold(
        body: SafeArea(
      child: BlocProvider(
          create: (context) => blogBloc,
          child: BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              if (state is BlogError)
                return Center(child: Text(state.message));
              else if (state is BlogInitial)
                return Center(child: LoadingWidget());
              else if (state is BlogLoaded)
                return Center(child: LoadingWidget());
              else if (state is BlogTextBoxesLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Gparam.heightPadding * 2),
                      Container(
                          height: 55,
                          margin: EdgeInsets.only(left: 0),
                          alignment: Alignment.topLeft,
                          decoration: new BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    SizedBox(width: Gparam.widthPadding),
                                    Container(
                                      height: 24,
                                      width: 3,
                                      color: Color(0xFF307df0),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Icon(
                                      MdiIcons.run,
                                      color: Color(0xFF307df0),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Gtheme.stext("Fitness",
                                        size: GFontSize.S,
                                        weight: GFontWeight.B,
                                        color: (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? GColors.W
                                            : GColors.B),
                                  ]),
                                  SizedBox(height: Gparam.heightPadding / 2),
                                  Row(children: [
                                    SizedBox(width: Gparam.widthPadding),
                                    ...widget.blog.tags.asMap().entries.map(
                                          (e) => Row(
                                            children: [
                                              Gtheme.stext("#",
                                                  size: GFontSize.XXS,
                                                  weight: GFontWeight.B,
                                                  color: (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark)
                                                      ? GColors.W
                                                      : GColors.B),
                                              Gtheme.stext(e.value + " ",
                                                  size: GFontSize.XXS,
                                                  color: (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark)
                                                      ? GColors.W1
                                                      : GColors.B1),
                                            ],
                                          ),
                                        ),
                                  ]),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: Gparam.heightPadding / 2),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Gtheme.stext(widget.blog.article_title,
                            weight: GFontWeight.B,
                            size: GFontSize.M,
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? GColors.W
                                : GColors.B),
                      ),
                      SizedBox(height: Gparam.heightPadding / 2),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Gtheme.stext(widget.blog.article_web_link,
                            weight: GFontWeight.L,
                            size: GFontSize.XXS,
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? GColors.W2
                                : GColors.B2),
                      ),
                      Container(
                          margin: EdgeInsets.all(Gparam.widthPadding / 2),
                          padding: EdgeInsets.all(Gparam.widthPadding),
                          decoration: new BoxDecoration(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark)
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              if (state.blog.image_url != null &&
                                  state.blog.image_url != "")
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    width: Gparam.width,
                                    height: Gparam.width / 2,
                                    child: (state.blog.image_url != null &&
                                            state.blog.image_url != "")
                                        ? CachedNetworkImage(
                                            imageUrl: state.blog.image_url,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            height: 0,
                                          ),
                                  ),
                                ),
                              SizedBox(
                                height: Gparam.heightPadding / 3,
                              ),
                              ZefyrTheme(
                                data: theme,
                                child: ZefyrView(
                                  document: introDocument,
                                ),
                              ),
                            ],
                          )),
                      ...state.textboxes
                          .asMap()
                          .entries
                          .map((e) => BlogTextBoxWidget(
                                textbox: e.value,
                              ))
                          .toList()
                    ],
                  ),
                );
              }
            },
          )),
    ));
  }
}
