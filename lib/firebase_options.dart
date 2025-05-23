// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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

  static final FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD5B2ATCyKAu9AhNaYhMvqpB_CdQ7dlYPM',
    appId: '1:679380105565:web:e600d76e65b60d5aa590b4',
    messagingSenderId: '679380105565',
    projectId: 'tracker-app-fbc43',
    authDomain: 'tracker-app-fbc43.firebaseapp.com',
    databaseURL: 'https://tracker-app-fbc43-default-rtdb.firebaseio.com',
    storageBucket: 'tracker-app-fbc43.firebasestorage.app',
    measurementId: 'G-6L7J2C66G6',
  );

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWkUyVbiPXdCb3mTqUG2W4kth2nWTjAnU',
    appId: '1:679380105565:android:9e37323014594fcca590b4',
    messagingSenderId: '679380105565',
    projectId: 'tracker-app-fbc43',
    databaseURL: 'https://tracker-app-fbc43-default-rtdb.firebaseio.com',
    storageBucket: 'tracker-app-fbc43.firebasestorage.app',
  );

  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCArmGgHxa6YTUXTa920W9W3_1CFhK2H80',
    appId: '1:679380105565:ios:3b5e60a1e652d4b1a590b4',
    messagingSenderId: '679380105565',
    projectId: 'tracker-app-fbc43',
    databaseURL: 'https://tracker-app-fbc43-default-rtdb.firebaseio.com',
    storageBucket: 'tracker-app-fbc43.firebasestorage.app',
    iosBundleId: 'com.example.tracker',
  );

  static final FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD5B2ATCyKAu9AhNaYhMvqpB_CdQ7dlYPM',
    appId: '1:679380105565:web:65a620adb64395b2a590b4',
    messagingSenderId: '679380105565',
    projectId: 'tracker-app-fbc43',
    authDomain: 'tracker-app-fbc43.firebaseapp.com',
    databaseURL: 'https://tracker-app-fbc43-default-rtdb.firebaseio.com',
    storageBucket: 'tracker-app-fbc43.firebasestorage.app',
    measurementId: 'G-NKFQFC3XXL',
  );
}
