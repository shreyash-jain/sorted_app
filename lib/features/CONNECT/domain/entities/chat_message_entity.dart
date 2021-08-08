class ChatMessageEntitiy {
  String id;
  String text;
  int type;
  String time;
  String url;
  bool isSender;
  String senderName;
  ChatMessageEntitiy({
    this.senderName='',
    this.id = '',
    this.text = '',
    this.type = 0,
    this.time = '',
    this.url = '',
    this.isSender = false,
  });
}
