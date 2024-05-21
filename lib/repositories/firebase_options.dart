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
    apiKey: 'AIzaSyCikrv8TCjlI1fVf2xGR8XrkFv6ZG8zcnA',
    appId: '1:801398445076:web:3e43542fe312f5ca0dc301',
    messagingSenderId: '801398445076',
    projectId: 'flutter-travel-app-3f538',
    authDomain: 'flutter-travel-app-3f538.firebaseapp.com',
    databaseURL: 'https://flutter-travel-app-3f538-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-travel-app-3f538.appspot.com',
    measurementId: 'G-Z1CBSL22HW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7e8IvH1HSYcRVgy7fHq9VQyT_LKr8K6k',
    appId: '1:801398445076:android:df86416ab466a3da0dc301',
    messagingSenderId: '801398445076',
    projectId: 'flutter-travel-app-3f538',
    databaseURL: 'https://flutter-travel-app-3f538-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-travel-app-3f538.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1XzquMPc7WDbhDafB9NvNAgej99FkfvM',
    appId: '1:801398445076:ios:5d765ee327ff55330dc301',
    messagingSenderId: '801398445076',
    projectId: 'flutter-travel-app-3f538',
    databaseURL: 'https://flutter-travel-app-3f538-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-travel-app-3f538.appspot.com',
    iosClientId: '801398445076-u6hlucq0vdahjloqn5pfmfmm7qdorsot.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1XzquMPc7WDbhDafB9NvNAgej99FkfvM',
    appId: '1:801398445076:ios:5d765ee327ff55330dc301',
    messagingSenderId: '801398445076',
    projectId: 'flutter-travel-app-3f538',
    databaseURL: 'https://flutter-travel-app-3f538-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-travel-app-3f538.appspot.com',
    iosClientId: '801398445076-u6hlucq0vdahjloqn5pfmfmm7qdorsot.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelapp',
  );
}