import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/chats/utils/chat_utils.dart';

import '../../../models/chat-contact-model.dart';
import '../../../models/msg-model.dart';
import '../../../resources/common/enums/msg-enum.dart';
import '../../../resources/common/providers/msg-reply-provider.dart';
import '../../auth/controller/auth-controller.dart';

final chatControllerProvider = Provider((ref) {
  final chatUtils = ref.watch(chatUtilityProvider);
  return ChatController(chatUtility: chatUtils, ref: ref);
});

class ChatController {
  final ChatUtility chatUtility;
  final ProviderRef ref;
  ChatController({
    required this.chatUtility,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatUtility.getChatContacts();
  }

  // Stream<List<Group>> chatGroups() {
  //   return chatRepository.getChatGroups();
  // }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatUtility.getChatStream(recieverUserId);
  }

  // Stream<List<Message>> groupChatStream(String groupId) {
  //   return chatRepository.getGroupChatStream(groupId);
  // }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataProvider).whenData(
          (value) => chatUtility.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    //to close the reply dialog after sending by updating the state
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataProvider).whenData(
          (value) => chatUtility.sendFileMessage(
            context: context,
            file: file,
            recieverUserId: recieverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    //to close the reply dialog after sending by updating the state
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String recieverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    //manipulating the gif string to fit flutter gif package
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    //gif url that flutter can handle
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    //write userdata and call Gif from the data
    ref.read(userDataProvider).whenData(
          (value) => chatUtility.sendGIFMessage(
            context: context,
            gifUrl: newgifUrl,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  // void setChatMessageSeen(
  //   BuildContext context,
  //   String recieverUserId,
  //   String messageId,
  // ) {
  //   chatRepository.setChatMessageSeen(
  //     context,
  //     recieverUserId,
  //     messageId,
  //   );
  // }
}
