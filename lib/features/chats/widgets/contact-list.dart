import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/features/chats/screen/chat-screen_mobile.dart';

import 'package:whatsapp_clone/resources/common/circularLoader.dart';

import '../../../models/chat-contact-model.dart';
import '../../../resources/common/colors.dart';
import '../controller/chat-controller.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: StreamBuilder<List<ChatContact>>(
            stream: ref.watch(chatControllerProvider).chatContacts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularLoader();
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatContactData = snapshot.data![index];

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          context.push(MobileChatScreen.routeName, extra: {
                            'name': chatContactData.name,
                            'uid': chatContactData.contactId,
                            'isGroupChat': false,
                            'profilePic': chatContactData.profilePic,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              chatContactData.name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                chatContactData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chatContactData.profilePic,
                              ),
                              radius: 30,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContactData.timeSent),
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
