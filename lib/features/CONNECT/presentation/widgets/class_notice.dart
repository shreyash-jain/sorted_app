import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/CONNECT/data/models/noticeboard_message.dart';
import 'package:sorted/features/CONNECT/presentation/class_noticeboard_bloc/class_noticeboard_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/notice_tile.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ChatNoticeBoardWidget extends StatefulWidget {
  final ClassModel classroom;

  ChatNoticeBoardWidget({Key key, this.classroom}) : super(key: key);

  @override
  _ChatNoticeBoardWidgetState createState() => _ChatNoticeBoardWidgetState();
}

class _ChatNoticeBoardWidgetState extends State<ChatNoticeBoardWidget> {
  ClassNoticeboardBloc classNoticeboardBloc;
  TextEditingController messageController = TextEditingController();

  List<NoticeboardMessage> messages = [];
  @override
  void initState() {
    classNoticeboardBloc = ClassNoticeboardBloc(sl());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Gparam.widthPadding,
                vertical: Gparam.widthPadding / 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gtheme.stext("Class Noticeboard",
                    size: GFontSize.S, weight: GFontWeight.B2),
              ],
            ),
          ),
          BlocProvider(
            create: (context) =>
                classNoticeboardBloc..add(GetInitialMessages(widget.classroom)),
            child: BlocListener<ClassNoticeboardBloc, ClassNoticeboardState>(
              listener: (context, state) {
                if (state is ClassNoticeboardLoaded)
                  setState(() {
                    messages = state.messages;
                  });
              },
              child: Column(
                children: [
                  BlocBuilder<ClassNoticeboardBloc, ClassNoticeboardState>(
                    builder: (context, state) {
                      if (state is NoticeboardInitial)
                        return LoadingWidget();
                      else if (state is ClassNoticeError)
                        return MessageDisplay(message: state.message);
                      else if (state is NoticeboardEmpty)
                        return Container(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Gtheme.stext("No Announcements"),
                          ],
                        ));
                      else if (state is ClassNoticeboardLoaded)
                        return Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            ...messages
                                .asMap()
                                .entries
                                .map(
                                  (e) => Padding(
                                    padding: EdgeInsets.only(
                                        left: Gparam.widthPadding,
                                        right: Gparam.widthPadding,
                                        bottom: 16),
                                    child: ClassNoticeTile(
                                        notice: e.value.message,
                                        time:
                                            DateTime.fromMillisecondsSinceEpoch(
                                                e.value.time),
                                        subText: "Views"),
                                  ),
                                )
                                .toList()
                          ],
                        );
                      else
                        return Container(
                          height: 0,
                        );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
