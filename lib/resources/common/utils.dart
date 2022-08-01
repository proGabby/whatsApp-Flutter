import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//show a snackbar with a message
void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

//pick a file
Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    //get image from gallery
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    //ensure only picked image is converted to a file
    if (pickedImage != null) {
      //convert picked image to a file
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}
