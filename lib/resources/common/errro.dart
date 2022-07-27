import 'package:flutter/material.dart';

class ErrorScrren extends StatelessWidget {
  final String error;
  const ErrorScrren({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(error)),
    );
  }
}
