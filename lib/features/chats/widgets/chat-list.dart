import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/resources/common/circularLoader.dart';

import '../../../models/msg-model.dart';
import '../controller/chat-controller.dart';
import 'sender-msg-card.dart';
import 'user-msg-card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  // void onMessageSwipe(
  //   String message,
  //   bool isMe,
  //   MessageEnum messageEnum,
  // ) {
  //   ref.read(messageReplyProvider.state).update(
  //         (state) => MessageReply(
  //           message,
  //           isMe,
  //           messageEnum,
  //         ),
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            // widget.isGroupChat
            //     ? ref
            //         .read(chatControllerProvider)
            //         .groupChatStream(widget.recieverUserId)
            //     :
            ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularLoader();
          }
          //to ensure whenever a new message arrive screen will automatically scroll to last message
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
            //attach the scroll controller to ensure it is effective
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);

              // if (!messageData.isSeen &&
              //     messageData.recieverid ==
              //         FirebaseAuth.instance.currentUser!.uid) {
              //   ref.read(chatControllerProvider).setChatMessageSeen(
              //         context,
              //         widget.recieverUserId,
              //         messageData.messageId,
              //       );
              // }

              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  onLeftSwipe: () {},
                  // onMessageSwipe(
                  //   messageData.text,
                  //   true,
                  //   messageData.type,
                  // ),
                  isSeen: messageData.isSeen,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightSwipe: () {},
                // onMessageSwipe(
                //   messageData.text,
                //   false,
                //   messageData.type,
                // ),
                repliedText: messageData.repliedMessage,
              );
            },
          );
        });
  }
}
