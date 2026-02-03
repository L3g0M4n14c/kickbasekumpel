import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

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
    apiKey: 'AIzaSyDOCAbC1234567890',
    appId: '1:123456789:web:abc123def456',
    messagingSenderId: '123456789',
    projectId: 'kickbasekumpel-dev',
    authDomain: 'kickbasekumpel-dev.firebaseapp.com',
    databaseURL: 'https://kickbasekumpel-dev.firebaseio.com',
    storageBucket: 'kickbasekumpel-dev.appspot.com',
    measurementId: 'G-ABC123DEF456',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOCAbC1234567890',
    appId: '1:123456789:android:abc123def456',
    messagingSenderId: '123456789',
    projectId: 'kickbasekumpel-dev',
    databaseURL: 'https://kickbasekumpel-dev.firebaseio.com',
    storageBucket: 'kickbasekumpel-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOCAbC1234567890',
    appId: '1:123456789:ios:abc123def456',
    messagingSenderId: '123456789',
    projectId: 'kickbasekumpel-dev',
    databaseURL: 'https://kickbasekumpel-dev.firebaseio.com',
    storageBucket: 'kickbasekumpel-dev.appspot.com',
  );
}
