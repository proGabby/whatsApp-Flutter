import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:whatsapp_clone/features/auth/controller/auth-controller.dart';
import 'package:whatsapp_clone/features/auth/screen/login-screen.dart';
import 'package:whatsapp_clone/features/auth/screen/otp-screen.dart';
import 'package:whatsapp_clone/features/mainscreen.dart';
import 'package:whatsapp_clone/models/user-model.dart';
import 'package:whatsapp_clone/resources/common/colors.dart';
import 'package:whatsapp_clone/resources/common/errro.dart';
import 'firebase_options.dart';

import './features/landing/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //binding app engine to flutter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      //A widget that stores the state of providers... exposed by riverpod
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      routeInformationProvider: _router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      //using builder to set the initial screen
      // builder: (context, child) {
      //   return ref.watch(userDataProvider).when(
      //       data: ((user) {
      //         if (user == null) {
      //           return const LandingScreen();
      //         }
      //         return const MobileScren();
      //       }),
      //       error: ((err, stackTrace) => ErrorScrren(error: err.toString())),
      //       loading: () => const CircularProgressIndicator());
      // },
      theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(color: appBarColor)),
    );
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
          path: "/",
          builder: (context, state) {
            return const HomeScreen();
          }),
      // GoRoute(
      //     path: LandingScreen.routeName,
      //     builder: (context, state) {
      //       return const LandingScreen();
      //     }),
      GoRoute(
          path: LoginScreen.routeName,
          builder: (context, state) {
            return const LoginScreen();
          }),
      GoRoute(
          path: OTPScreen.routeName,
          builder: (context, state) {
            return OTPScreen(
              verificationId: state.extra! as String,
            );
          }),
    ],
    errorBuilder: (context, state) {
      return const ErrorScrren(error: "404 Eror");
    },
  );
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDataProvider).when(
        data: ((user) {
          if (user == null) {
            return const LandingScreen();
          }
          return const MobileScren();
        }),
        error: ((err, stackTrace) => ErrorScrren(error: err.toString())),
        loading: () => const CircularProgressIndicator());
  }
}
