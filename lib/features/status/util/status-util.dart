import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/resources/common/firebase_common/firebaseStorage_common.dart';

import '../../../models/status_model.dart';
import '../../../models/user-model.dart';
import '../../../resources/common/utils.dart';

final statusUtilProvider = Provider((ref) {
  return StatusUtility(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref);
});

class StatusUtility {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusUtility({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  //uploading user status
  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      //extract all contact on our db with user phone no as a contact

      //Create status id
      var statusId = const Uuid().v1();
      //get user id
      String userId = auth.currentUser!.uid;

      //save status and get image url
      String imageurl =
          await ref.read(commonFirebaseStorageProvider).storeFileToFirebase(
                '/status/$statusId$userId',
                statusImage,
              );

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      //list of contact who can see user status
      List<String> uidWhoCanSee = [];

      //go through all conatacts on db and get those what current userid is in their contact
      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          //add id to whocansee list
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrls = [];
      //get user status below 24 hrs
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .where('createdAt',
              isLessThan: DateTime.now().subtract(const Duration(hours: 24)))
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        //create a status model from the snapshot gotten from firebase
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());

        statusImageUrls = status.photoUrlList;

        //add new uploaded image to status list
        statusImageUrls.add(imageurl);

        //add to status list on firebase
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageurl];
      }

      Status status = Status(
        uid: userId,
        username: username,
        phoneNumber: phoneNumber,
        photoUrlList: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSeeStatus: uidWhoCanSee,
      );
      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      //get list of contact
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (int i = 0; i < contacts.length; i++) {
        var statusesSnapshot = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch,
            )
            .get();

        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSeeStatus.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
