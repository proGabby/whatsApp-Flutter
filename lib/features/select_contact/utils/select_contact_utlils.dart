import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/features/chats/screen/chat-screen_mobile.dart';

import '../../../models/user-model.dart';
import '../../../resources/common/utils.dart';

final selectContactUtilityProvider = Provider((ref) {
  return SelectContactUtility(firestore: FirebaseFirestore.instance);
});

class SelectContactUtility {
  final FirebaseFirestore firestore;

  SelectContactUtility({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        //Noted: ensure to set withproperties to true... To ensure contact details are attach to the contact
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      //get all user from firestore
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      //iterate through each user data
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        //remove space on the phone number
        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        //ensure phone number and user phone
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;

          //navigate to chat screen
          context.replace(MobileChatScreen.routeName, extra: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
      }

      if (!isFound) {
        showSnackBar(
          context: context,
          content: 'This number does not exist on this app.',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context: context, content: e.toString());
    }
  }
}
