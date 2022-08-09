import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth-controller.dart';
import 'package:whatsapp_clone/features/status/util/status-util.dart';
import 'package:whatsapp_clone/models/status_model.dart';

final statusControllerProvider = Provider((ref) {
  final statusUtility = ref.read(statusUtilProvider);
  return StatusController(statusUtility: statusUtility, ref: ref);
});

class StatusController {
  final StatusUtility statusUtility;
  final ProviderRef ref;

  StatusController({required this.statusUtility, required this.ref});

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataProvider).whenData((value) {
      statusUtility.uploadStatus(
        username: value!.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: file,
        context: context,
      );
    });
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusUtility.getStatus(context);
    return statuses;
  }
}
