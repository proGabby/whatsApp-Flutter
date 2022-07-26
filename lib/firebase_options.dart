// File generated by FlutterFire CLI.
// ignore_for_file: lines_longdart pub add firebase_core_darter_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
///
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDd_1EqQwRMMx4IUKLiXXZKZBI5dMQSTU8',
    appId: '1:916326237423:web:50164cf4ace692c318071a',
    messagingSenderId: '916326237423',
    projectId: 'whatsapp-clone-94a16',
    authDomain: 'whatsapp-clone-94a16.firebaseapp.com',
    storageBucket: 'whatsapp-clone-94a16.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQ95mpkXyl6RcHNbwy9YsgHNUIvpzACOw',
    appId: '1:916326237423:android:8c3d9e1f915b899d18071a',
    messagingSenderId: '916326237423',
    projectId: 'whatsapp-clone-94a16',
    storageBucket: 'whatsapp-clone-94a16.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGvvKD-8F6gRbaJ4pg-NWglI9KiOjvDxo',
    appId: '1:916326237423:ios:29c140d9785d0d1118071a',
    messagingSenderId: '916326237423',
    projectId: 'whatsapp-clone-94a16',
    storageBucket: 'whatsapp-clone-94a16.appspot.com',
    iosClientId:
        '916326237423-l99emilrjh88v60au4tm1ugc8vu6r004.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );
}
