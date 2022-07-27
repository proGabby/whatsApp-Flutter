import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/utility/auth_util.dart';

//authcontroller provider
final authControllerProvider = Provider((ref) {
  //get data and state from the authUtilProvider
  final authUtil = ref.watch(authUtilProvider);
  return AuthController(authUtility: authUtil);
});

class AuthController {
  final AuthUtil authUtility;
  AuthController({required this.authUtility});

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authUtility.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(
      BuildContext context, String verificationId, String otpFromUser) {
    authUtility.verifyOTP(
        context: context,
        verificationId: verificationId,
        otpFromUser: otpFromUser);
  }
}
