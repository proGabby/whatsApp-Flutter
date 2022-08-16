import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/chats/screen/chat-screen_mobile.dart';
import 'package:whatsapp_clone/features/mainscreen.dart';
import 'package:whatsapp_clone/models/group-model.dart';
import 'package:go_router/go_router.dart';

import '../../../resources/common/circularLoader.dart';
import '../../../resources/common/colors.dart';
import '../../chats/controller/chat-controller.dart';

class GroupList extends ConsumerWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: StreamBuilder<List<GroupModel>>(
            stream: ref.watch(chatControllerProvider).chatGroups(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularLoader();
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var groupData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          context.go(MobileChatScreen.routeName, extra: {
                            'name': groupData.name,
                            'uid': groupData.groupId,
                            'isGroupChat': true,
                            'profilePic': groupData.groupPic,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              groupData.name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                groupData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                groupData.groupPic,
                              ),
                              radius: 30,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(groupData.timeSent),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: dividerColor, indent: 85),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
