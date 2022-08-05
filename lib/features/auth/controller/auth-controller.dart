import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/utility/auth_util.dart';

import '../../../models/user-model.dart';

//authcontroller provider
final authControllerProvider = Provider((ref) {
  //get data and state from the authUtilProvider
  final authUtil = ref.watch(authUtilProvider);
  return AuthController(authUtility: authUtil, ref: ref);
});

final userDataProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthUtil authUtility;
  //providerRef is initiated here because the provider will be use in a widget class which has widgetRef not provider ref
  final ProviderRef ref;
  AuthController({required this.authUtility, required this.ref});

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

  void saveDateToFirebase(BuildContext context, String name, File? profilePic) {
    return authUtility.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authUtility.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userDataById(String userId) {
    return authUtility.userData(userId);
  }
}
