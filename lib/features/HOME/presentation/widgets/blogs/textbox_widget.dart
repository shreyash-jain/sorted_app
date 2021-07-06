import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:zefyr/zefyr.dart';

class BlogTextBoxWidget extends StatelessWidget {
  final BlogTextboxModel textbox;
  const BlogTextBoxWidget({Key key, this.textbox}) : super(key: key);

  NotusDocument _loadDocument(String text) {
    return NotusDocument.fromJson(jsonDecode(text.replaceAll(r'\\\\n', r'\n')));
  }

  @override
  Widget build(BuildContext context) {
    print(textbox.content);
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
    var theme = ZefyrThemeData(
      defaultLineTheme: defaultLineTheme,
      attributeTheme: AttributeTheme.fallback(context, defaultLineTheme),
      indentWidth: 12.0,
      toolbarTheme: ToolbarTheme.fallback(context),
    );
    var introDocument = _loadDocument(
        textbox.content.replaceAll(r'"u"', r'"i"').replaceAll(r'\\\\n', r'\n'));

    return Container(
        margin: EdgeInsets.all(Gparam.widthPadding / 2),
        padding: EdgeInsets.all(Gparam.widthPadding),
        decoration: new BoxDecoration(
            color: (Theme.of(context).brightness == Brightness.dark)
                ? Colors.grey.shade900
                : Colors.grey.shade100,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gtheme.stext(textbox.heading.trim(),
                weight: GFontWeight.B,
                size: GFontSize.M,
                color: (Theme.of(context).brightness == Brightness.dark)
                    ? GColors.W
                    : GColors.B),
            if (textbox.imageUrl != null && textbox.imageUrl != "")
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: Gparam.width,
                  height: Gparam.width / 2,
                  child: CachedNetworkImage(
                    imageUrl: textbox.imageUrl,
                    fit: BoxFit.cover,
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
        ));
  }
}
