import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/CONNECT/presentation/class_chat_bloc/class_chat_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/chat/bottom_loader.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/chat/receive_message.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/chat/send_message.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ChatWidget extends StatefulWidget {
  final ClassModel classroom;

  ChatWidget({Key key, this.classroom}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  TextEditingController _messageController;
  final _scrollController = ScrollController();

  ClassChatBloc chatBloc;
  FocusNode _messageFocus;
  double keyHeight = 0.0;
  @override
  void initState() {
    _messageController = TextEditingController();
    _messageFocus = FocusNode();
    _scrollController.addListener(_onScroll);
    chatBloc = ClassChatBloc(sl(), widget.classroom);

    _messageFocus.addListener(() {
      if (_messageFocus.hasFocus) {
        setState(() {
          print("keyboard 1 " +
              MediaQuery.of(context).viewInsets.bottom.toString());
          keyHeight = 300;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    print("_onScroll");
    if (_isTop) {
      print("_onScroll dddd");
      chatBloc.add(MessagesFetched());
    }
    ;
  }

  bool get _isTop {
    if (!_scrollController.hasClients) return false;
    final minScroll = _scrollController.position.minScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll <= (minScroll * 1.1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => chatBloc..add(MessagesFetched()),
      child: BlocBuilder<ClassChatBloc, ChatsLoaded>(
        builder: (context, state) {
          switch (state.status) {
            case MessageStatus.failure:
              return const Center(child: Text('failed to fetch posts'));
            case MessageStatus.success:
              return Stack(
                children: [
                  Container(
                    child: SingleChildScrollView(
                      child: Container(
                          height: Gparam.height - 200,
                          child: (state.messages.isEmpty)
                              ? Center(
                                  child: Container(
                                      child: Column(
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Gtheme.stext("No Chats"),
                                  ],
                                )))
                              : ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Timer(
                                      Duration(seconds: 1),
                                      () => _scrollController.jumpTo(
                                          _scrollController
                                              .position.maxScrollExtent),
                                    );
                                    return index >= state.messages.length
                                        ? BottomLoader()
                                        : (state.messages[index].isSender)
                                            ? SentMessage(
                                                key: Key(
                                                    state.messages[index].id),
                                                message:
                                                    state.messages[index].text,
                                              )
                                            : ReceiveMessage(
                                                key: Key(
                                                    state.messages[index].id),
                                                message:
                                                    state.messages[index].text,
                                                senderName: state
                                                    .messages[index].senderName,
                                              );
                                  },
                                  itemCount: !state.hasReachedMax
                                      ? state.messages.length
                                      : state.messages.length + 1,
                                  controller: _scrollController,
                                )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.grey.shade50,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: Gtheme.blackShadowBold28,
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              chatBloc
                                  .add(AddNewMessage(_messageController.text));
                              _messageController.clear();
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.black,
                              size: 25,
                            ),
                            backgroundColor: Colors.white,
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
