// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
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
        return macos;
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
    apiKey: 'AIzaSyCqzyh-avvB7KiwguKK3r2NxXTJB1SSpKc',
    appId: '1:687461433768:web:bab78312904e444abf1d9d',
    messagingSenderId: '687461433768',
    projectId: 'uiam-903ed',
    authDomain: 'uiam-903ed.firebaseapp.com',
    storageBucket: 'uiam-903ed.appspot.com',
    measurementId: 'G-Q5958H13CX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1iiFQZk04_wjNgO6iJlqW-EbGGGm6DPY',
    appId: '1:687461433768:android:7182f0331bf3a99ebf1d9d',
    messagingSenderId: '687461433768',
    projectId: 'uiam-903ed',
    storageBucket: 'uiam-903ed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0L1eo3ze7_s7Neh9hLlvN1jTi5iwFj3Q',
    appId: '1:687461433768:ios:20040530ce71bb7bbf1d9d',
    messagingSenderId: '687461433768',
    projectId: 'uiam-903ed',
    storageBucket: 'uiam-903ed.appspot.com',
    iosClientId: '687461433768-jv97va3v68usd1ko6eutr71df5ro7trk.apps.googleusercontent.com',
    iosBundleId: 'com.uiam.personal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB0L1eo3ze7_s7Neh9hLlvN1jTi5iwFj3Q',
    appId: '1:687461433768:ios:20040530ce71bb7bbf1d9d',
    messagingSenderId: '687461433768',
    projectId: 'uiam-903ed',
    storageBucket: 'uiam-903ed.appspot.com',
    iosClientId: '687461433768-jv97va3v68usd1ko6eutr71df5ro7trk.apps.googleusercontent.com',
    iosBundleId: 'com.uiam.personal',
  );
}
