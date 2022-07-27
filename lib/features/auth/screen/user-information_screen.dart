import 'package:flutter/material.dart';

class UserInFoScreen extends StatelessWidget {
  static const routeName = "/userinfoscreen";
  const UserInFoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("INFO SCREEN"),
      ),
    );
  }
}
