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
    apiKey: 'AIzaSyBokD3y4Wge_oUvpabPlgEhjoYkQFF-fZA',
    appId: '1:1075091607106:web:9181cdffa9623b88e5e7db',
    messagingSenderId: '1075091607106',
    projectId: 'fir-chat-app-e1e74',
    authDomain: 'fir-chat-app-e1e74.firebaseapp.com',
    storageBucket: 'fir-chat-app-e1e74.appspot.com',
    measurementId: 'G-Y58RWLGP58',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVTNScwfZ4oOkt2X-q0V5Zg0DXtKEi1Y8',
    appId: '1:1075091607106:android:7b037c7a1b8e88ffe5e7db',
    messagingSenderId: '1075091607106',
    projectId: 'fir-chat-app-e1e74',
    storageBucket: 'fir-chat-app-e1e74.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAES-u-PA8q5qh3uHeAU68TLQqWz8uJspc',
    appId: '1:1075091607106:ios:8e8a4a286f8a7ea0e5e7db',
    messagingSenderId: '1075091607106',
    projectId: 'fir-chat-app-e1e74',
    storageBucket: 'fir-chat-app-e1e74.appspot.com',
    iosBundleId: 'com.example.firebaseChatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAES-u-PA8q5qh3uHeAU68TLQqWz8uJspc',
    appId: '1:1075091607106:ios:8e8a4a286f8a7ea0e5e7db',
    messagingSenderId: '1075091607106',
    projectId: 'fir-chat-app-e1e74',
    storageBucket: 'fir-chat-app-e1e74.appspot.com',
    iosBundleId: 'com.example.firebaseChatApp',
  );
}
