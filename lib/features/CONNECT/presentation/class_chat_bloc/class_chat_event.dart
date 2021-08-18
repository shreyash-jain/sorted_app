part of 'class_chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class MessagesFetched extends ChatEvent {
  final bool changeMaxReached;

  MessagesFetched({this.changeMaxReached});
  @override
  List<Object> get props => [changeMaxReached];
}

class AddNewClassMessage extends ChatEvent {
  final String text;

  AddNewClassMessage(this.text);

  @override
  List<Object> get props => [text];
}

class AddNewConsultationMessage extends ChatEvent {
  final String text;

  AddNewConsultationMessage(this.text);

  @override
  List<Object> get props => [text];
}

class ConsultationMessagesFetched extends ChatEvent {
  final bool changeMaxReached;

  ConsultationMessagesFetched({this.changeMaxReached});
  @override
  List<Object> get props => [changeMaxReached];
}
