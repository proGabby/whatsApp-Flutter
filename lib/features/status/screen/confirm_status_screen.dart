import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/status/controller/status-controller.dart';

import '../../../resources/common/colors.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const routeName = '/confirm-status-screen';
  final File? myFile;
  const ConfirmStatusScreen({Key? key, required this.myFile}) : super(key: key);

  void addStatus(WidgetRef ref, BuildContext context) {
    ref.read(statusControllerProvider).addStatus(myFile!, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(myFile!),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        onPressed: () => addStatus(ref, context),
        backgroundColor: tabColor,
      ),
    );
  }
}
