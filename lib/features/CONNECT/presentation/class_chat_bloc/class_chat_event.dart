part of 'class_chat_bloc.dart';

abstract class ClassChatEvent extends Equatable {
  const ClassChatEvent();
}

class GetInitialChats extends ClassChatEvent {
  final ClassModel classroom;

  GetInitialChats(this.classroom);

  @override
  List<Object> get props => [classroom];
}

class MessagesFetched extends ClassChatEvent {
  final bool changeMaxReached;

  MessagesFetched({this.changeMaxReached});
  @override
  List<Object> get props => [changeMaxReached];
}

class AddNewMessage extends ClassChatEvent {
  final String text;

  AddNewMessage(this.text);

  @override
  List<Object> get props => [text];
}

class AddNewImage extends ClassChatEvent {
  final ClassModel classroom;
  final File file;

  AddNewImage(this.classroom, this.file);

  @override
  List<Object> get props => [classroom, file];
}

class LoadMoreChats extends ClassChatEvent {
  final ClassModel classroom;
  final ChatMessageEntitiy lastChat;

  LoadMoreChats(this.classroom, this.lastChat);

  @override
  List<Object> get props => [classroom, lastChat];
}
