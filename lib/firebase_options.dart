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
    apiKey: 'AIzaSyByMdAHCU2PYpS69RCJGUhvkyvu5NCYIj8',
    appId: '1:780072412373:web:7895885a967148bdd0ee5c',
    messagingSenderId: '780072412373',
    projectId: 'steelhacks-2023-db',
    authDomain: 'steelhacks-2023-db.firebaseapp.com',
    storageBucket: 'steelhacks-2023-db.appspot.com',
    measurementId: 'G-JZW90ZLJSC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCERe3j3efr-wf3lNFHwqM1E2Dpg4HKJ6Y',
    appId: '1:780072412373:android:8be28c803947082bd0ee5c',
    messagingSenderId: '780072412373',
    projectId: 'steelhacks-2023-db',
    storageBucket: 'steelhacks-2023-db.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6ZUq_5_dagmiBo2rLxJKu56lOC0fGO4I',
    appId: '1:780072412373:ios:a567e58d75bb7015d0ee5c',
    messagingSenderId: '780072412373',
    projectId: 'steelhacks-2023-db',
    storageBucket: 'steelhacks-2023-db.appspot.com',
    iosClientId: '780072412373-nm7lgj09mlfs7vb3f644amagt6e1nuf1.apps.googleusercontent.com',
    iosBundleId: 'com.example.lostFoundSteelhacks',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6ZUq_5_dagmiBo2rLxJKu56lOC0fGO4I',
    appId: '1:780072412373:ios:a567e58d75bb7015d0ee5c',
    messagingSenderId: '780072412373',
    projectId: 'steelhacks-2023-db',
    storageBucket: 'steelhacks-2023-db.appspot.com',
    iosClientId: '780072412373-nm7lgj09mlfs7vb3f644amagt6e1nuf1.apps.googleusercontent.com',
    iosBundleId: 'com.example.lostFoundSteelhacks',
  );
}
