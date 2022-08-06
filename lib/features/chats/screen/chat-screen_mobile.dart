import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/resources/common/circularLoader.dart';

import '../../../models/user-model.dart';
import '../../../resources/common/colors.dart';
import '../../auth/controller/auth-controller.dart';
import '../widgets/bottomchatfied.dart';
import '../widgets/chat-list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.userId,
    // required this.isGroupChat,
    // required this.profilePic
  }) : super(key: key);
  final String name;
  final String userId;
  final bool isGroupChat = false;
  final String profilePic = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream: ref.read(authControllerProvider).userDataById(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularLoader();
                  }
                  return Column(
                    children: [
                      Text(name),
                      Text(
                        snapshot.data!.isOnline ? 'online' : 'offline',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {}, // => makeCall(ref, context),
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: userId,
              isGroupChat: isGroupChat,
            ),
          ),
          BottomChatField(
            recieverUserId: userId,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
