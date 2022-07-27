import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/screen/otp-screen.dart';

import '../../../resources/common/colors.dart';
import '../../../resources/common/utils.dart';
import '../controller/auth-controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  //ConsumerStatefulWidget is a StatefulWidget that can read providers... it exposes ref
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  //a country object expose by the country picker package
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    //get the phonenumber from the phonecontroller
    String phoneNumber = phoneController.text.trim();
    //check to ensure coutry and phoneNumber is represent
    if (country != null && phoneNumber.isNotEmpty) {
      //read the authControllerProvider to get its data
      ref.read(authControllerProvider).signInWithPhone(context,
          '+${country!.phoneCode}$phoneNumber'); //since firebase require both the country code and the phone number
    } else {
      showSnackBar(context: context, content: 'Enter every field');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('WhatsApp will need to verify your phone number.'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: pickCountry,
                child: const Text('Pick Country'),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  //conditionally showing country code
                  if (country != null) Text('+${country!.phoneCode}'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.6),
              SizedBox(
                width: 90,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //elevated button style
                        primary: tabColor,
                        minimumSize: const Size(double.infinity, 40)),
                    child: const Text(
                      ' NEXT',
                      style: TextStyle(color: blackColor),
                    ),
                    onPressed: sendPhoneNumber),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
