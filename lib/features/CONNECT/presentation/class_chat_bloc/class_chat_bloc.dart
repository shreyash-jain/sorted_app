import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/CONNECT/data/models/chat_message.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/domain/entities/chat_message_entity.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

part 'class_chat_event.dart';
part 'class_chat_state.dart';

const _messageLimit = 20;

class ClassChatBloc extends Bloc<ChatEvent, ChatsLoaded> {
  final ConnectRepository repository;
  final ClassModel classroom;
  final ClientConsultationModel consultationModel;
  ClassChatBloc(this.repository, this.classroom, this.consultationModel)
      : super(ChatsLoaded());

  static const _pageSize = 20;

  @override
  Stream<Transition<ChatEvent, ChatsLoaded>> transformEvents(
    Stream<ChatEvent> events,
    TransitionFunction<ChatEvent, ChatsLoaded> transitionFn,
  ) {
    return super.transformEvents(
      events.throttleTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ChatsLoaded> mapEventToState(ChatEvent event) async* {
    if (event is MessagesFetched) {
      yield (event.changeMaxReached != null && event.changeMaxReached)
          ? (await _mapPostFetchedToState(state.copyWith(hasReachedMax: false)))
          : (await _mapPostFetchedToState(state));
    } else if (event is AddNewClassMessage) {
      Failure failure;
      ChatMessageEntitiy messageEntitiy;
      var messageid = await repository.addChatMessage(
          ChatMessage(text: event.text), classroom);
      messageid.fold((l) => failure = l, (r) {
        messageEntitiy = r;
      });
      if (failure == null)
        yield state.copyWith(
          status: MessageStatus.success,
          messages: List.of(state.messages)..add(messageEntitiy),
          hasReachedMax: state.hasReachedMax,
        );
      else
        yield state.copyWith(status: MessageStatus.failure);
    }
    else if (event is ConsultationMessagesFetched) {
      yield (event.changeMaxReached != null && event.changeMaxReached)
          ? (await _mapPostConsultationFetchedToState(
              state.copyWith(hasReachedMax: false)))
          : (await _mapPostConsultationFetchedToState(state));
    } else if (event is AddNewConsultationMessage) {
      Failure failure;
      ChatMessageEntitiy messageEntitiy;
      var messageid = await repository.addConsultationChatMessage(
          ChatMessage(text: event.text), consultationModel);
      messageid.fold((l) => failure = l, (r) {
        messageEntitiy = r;
      });
      if (failure == null)
        yield state.copyWith(
          status: MessageStatus.success,
          messages: List.of(state.messages)..add(messageEntitiy),
          hasReachedMax: state.hasReachedMax,
        );
      else
        yield state.copyWith(status: MessageStatus.failure);
    }
  }
  Future<ChatsLoaded> _mapPostConsultationFetchedToState(
      ChatsLoaded state) async {
    Failure failure;
    List<ChatMessageEntitiy> messages;

    if (state.hasReachedMax) return state;

    try {
      if (state.status == MessageStatus.initial) {
        final messagesResult = await repository.getConsultationChatMessages(
            consultationModel, null, _messageLimit);

        messagesResult.fold((l) => failure = l, (r) => {messages = r});
        if (failure == null)
          return state.copyWith(
            status: MessageStatus.success,
            messages: messages.reversed.toList(),
            hasReachedMax: false,
          );
        else {
          print(Failure.mapToString(failure));
          return state.copyWith(status: MessageStatus.failure);
        }
      }
      final postsResult = await repository.getConsultationChatMessages(
          consultationModel,
          (state.messages.length > 0)
              ? ChatMessage.fromEntity(
                  state.messages[state.messages.length - 1])
              : null,
          _messageLimit);
      postsResult.fold((l) => failure = l, (r) => {messages = r});

      if (failure == null)
        return messages.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: MessageStatus.success,
                messages: (List.of(state.messages)..addAll(messages))
                    .reversed
                    .toList(),
                hasReachedMax: false,
              );
      else {
        print(Failure.mapToString(failure));
        return state.copyWith(status: MessageStatus.failure);
      }
    } on Exception {
      return state.copyWith(status: MessageStatus.failure);
    }
  }

  Future<ChatsLoaded> _mapPostFetchedToState(ChatsLoaded state) async {
    Failure failure;
    List<ChatMessageEntitiy> messages;

    if (state.hasReachedMax) return state;

    try {
      if (state.status == MessageStatus.initial) {
        final messagesResult =
            await repository.getChatMessages(classroom, null, _messageLimit);

        messagesResult.fold((l) => failure = l, (r) => {messages = r});
        if (failure == null)
          return state.copyWith(
            status: MessageStatus.success,
            messages: messages.reversed.toList(),
            hasReachedMax: false,
          );
        else {
          print(Failure.mapToString(failure));
          return state.copyWith(status: MessageStatus.failure);
        }
      }
      final postsResult = await repository.getChatMessages(
          classroom,
          (state.messages.length > 0)
              ? ChatMessage.fromEntity(
                  state.messages[state.messages.length - 1])
              : null,
          _messageLimit);
      postsResult.fold((l) => failure = l, (r) => {messages = r});

      if (failure == null)
        return messages.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: MessageStatus.success,
                messages: (List.of(state.messages)..addAll(messages))
                    .reversed
                    .toList(),
                hasReachedMax: false,
              );
      else {
        print(Failure.mapToString(failure));
        return state.copyWith(status: MessageStatus.failure);
      }
    } on Exception {
      return state.copyWith(status: MessageStatus.failure);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
