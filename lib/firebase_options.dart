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
    apiKey: 'AIzaSyDHowFiL0d75jAXDPdIXIjflQarPlrw_Bw',
    appId: '1:2866104611:web:ff90103b25bfc238ebe496',
    messagingSenderId: '2866104611',
    projectId: 'roomescape-9363e',
    authDomain: 'roomescape-9363e.firebaseapp.com',
    storageBucket: 'roomescape-9363e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSnYqpzKpR40b95K5hkWLuLtq1IwJ3OKM',
    appId: '1:2866104611:android:baa23a9649ad5c5bebe496',
    messagingSenderId: '2866104611',
    projectId: 'roomescape-9363e',
    storageBucket: 'roomescape-9363e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHNjeFpsPmvPw3rn-c9ZQsN5qgExGltks',
    appId: '1:2866104611:ios:9ecbd65cf169b334ebe496',
    messagingSenderId: '2866104611',
    projectId: 'roomescape-9363e',
    storageBucket: 'roomescape-9363e.appspot.com',
    iosBundleId: 'com.example.roomescapeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHNjeFpsPmvPw3rn-c9ZQsN5qgExGltks',
    appId: '1:2866104611:ios:a01018b81844f9c8ebe496',
    messagingSenderId: '2866104611',
    projectId: 'roomescape-9363e',
    storageBucket: 'roomescape-9363e.appspot.com',
    iosBundleId: 'com.example.roomescapeApp.RunnerTests',
  );
}