import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/features/auth/screen/login-screen.dart';

import '../../resources/common/colors.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = "/landing-screen";
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            //welcome text
            const Text(
              'Welcome to WhatsApp',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: _deviceSize.height / 9),
            //insert QR Image on the screen
            Image.asset(
              'assets/images/bg.png',
              height: 250,
              width: 340,
              color: tabColor,
            ),
            SizedBox(height: _deviceSize.height / 9),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                style: TextStyle(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: _deviceSize.width * 0.75,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      //elevated button style
                      primary: tabColor,
                      minimumSize: const Size(double.infinity, 40)),
                  child: const Text(
                    'AGREE AND CONTINUE',
                    style: TextStyle(color: blackColor),
                  ),
                  onPressed: () {
                    context.go(LoginScreen.routeName);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
