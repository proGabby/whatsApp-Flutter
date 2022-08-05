import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/select_contact/utils/select_contact_utlils.dart';

final getContactProvider = FutureProvider<List>((ref) {
  final selectContactUtils = ref.watch(selectContactUtilityProvider);
  return selectContactUtils.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactUtils = ref.watch(selectContactUtilityProvider);
  return SelectContactController(
      ref: ref, selectContactUtils: selectContactUtils);
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactUtility selectContactUtils;
  SelectContactController({
    required this.ref,
    required this.selectContactUtils,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactUtils.selectContact(selectedContact, context);
  }
}
