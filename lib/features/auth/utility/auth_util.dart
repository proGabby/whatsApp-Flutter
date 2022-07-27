import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/auth/screen/otp-screen.dart';
import '../../../resources/common/utils.dart';

final authUtilProvider = Provider((ref) {
  return AuthUtil(
      auth: FirebaseAuth.instance, firestore: FirebaseStorage.instance);
});

class AuthUtil {
  final FirebaseAuth auth;
  final FirebaseStorage firestore;

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
}
