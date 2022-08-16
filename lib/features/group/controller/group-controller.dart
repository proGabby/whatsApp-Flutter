import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/group_util.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupUtilityProvider);
  return GroupController(
    groupUtils: groupRepository,
    ref: ref,
  );
});

class GroupController {
  final GroupUtility groupUtils;
  final ProviderRef ref;
  GroupController({
    required this.groupUtils,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) {
    groupUtils.createGroup(context, name, profilePic, selectedContact);
  }
}
