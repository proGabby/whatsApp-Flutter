import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/auth/screen/otp-screen.dart';
import 'package:whatsapp_clone/features/auth/screen/user-information_screen.dart';
import 'package:whatsapp_clone/features/mainscreen.dart';
import '../../../models/user-model.dart';
import '../../../resources/common/firebase_common/firebaseStorage_common.dart';
import '../../../resources/common/utils.dart';

final authUtilProvider = Provider((ref) {
  return AuthUtil(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
});

class AuthUtil {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthUtil({required this.auth, required this.firestore});

  //sigin user with phone Number
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //starts a phone number verification process for the given phone number.
        verificationCompleted: (PhoneAuthCredential credential) async {
          //sigin with the credential gotten from phone verification
          await auth.signInWithCredential(credential);
        },
        //handle verification failed by throwing an exception
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        //handle instance when an SMS has been sent to the users phone
        codeSent: ((String verificationId, int? resendToken) async {
          context.go(OTPScreen.routeName, extra: verificationId);
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      //handling firebase auth exception
      showSnackBar(context: context, content: e.message!);
    }
  }

  //verify otp send to user
  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String otpFromUser}) async {
    try {
      //create a new Phone credential with an verification ID and SMS code.
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpFromUser,
      );

      //Asynchronously signs in to Firebase with the given 3rd-party credentials
      await auth.signInWithCredential(credential);
      context.go(UserInfoScreen.routeName);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  //saving user data to firebase
  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      //getting user id
      String uid = auth.currentUser!.uid;

      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        //save and get the photor url as string from firebase a
        photoUrl =
            await ref.read(commonFirebaseStorageProvider).storeFileToFirebase(
                  'profilePic/$uid',
                  profilePic,
                );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );

      //save details on firestore
      await firestore.collection('users').doc(uid).set(user.toMap());

      //navigator to mainscreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileScren(),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }
}
