import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:whatsapp_clone/features/select_contact/screen/selectcontact-screen.dart';
import 'package:whatsapp_clone/features/status/screen/confirm_status_screen.dart';

import '../resources/common/colors.dart';
import '../resources/common/utils.dart';
import 'auth/controller/auth-controller.dart';
import 'chats/widgets/contact-list.dart';
import 'status/screen/status-contact-screen.dart';

class MobileScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobilescreen';
  const MobileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends ConsumerState<MobileScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController tabBarController;

  @override
  void initState() {
    tabBarController = TabController(length: 2, vsync: this);
    //adding an observer for widgebing
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  //Called when the system puts the app in the background or returns the app to the foreground.
  //appLifecycleState use to check whether user is offline or online
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //switch depanding on the state
    switch (state) {
      case AppLifecycleState.resumed:
        //set online status to true
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        //set online status to false
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: const Text(
                      'Create Group',
                    ),
                    onTap: () {})
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          //tabview to enable top navigation tabbar
          controller: tabBarController,
          children: const [
            ContactsList(),
            StatusContactsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
              context.push(SelectContactsScreen.routeName);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                context.pushNamed(ConfirmStatusScreen.routeName,
                    extra: pickedImage);
              }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
