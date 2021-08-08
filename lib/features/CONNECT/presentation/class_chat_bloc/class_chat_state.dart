part of 'class_chat_bloc.dart';

enum MessageStatus { initial, success, failure}



class ChatsLoaded extends Equatable {
  const ChatsLoaded({
    this.status = MessageStatus.initial,
    this.messages = const <ChatMessageEntitiy>[],
    this.hasReachedMax = false,
  });
  final MessageStatus status;
  final List<ChatMessageEntitiy> messages;
  final bool hasReachedMax;

  

  @override
  List<Object> get props => [messages,status,hasReachedMax];

  ChatsLoaded copyWith({
    MessageStatus status,
    List<ChatMessageEntitiy> messages,
    bool hasReachedMax,
  }) {
    return ChatsLoaded(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
