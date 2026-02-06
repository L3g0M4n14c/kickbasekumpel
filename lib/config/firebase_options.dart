import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

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
    apiKey: 'AIzaSyAwu1rs5Dvr_L0iMnv_6hdbBHWCvwokrxs',
    appId: '1:843006606880:web:873da22f6bdea565de0645',
    messagingSenderId: '843006606880',
    projectId: 'kickbasekumpel',
    authDomain: 'kickbasekumpel.firebaseapp.com',
    storageBucket: 'kickbasekumpel.firebasestorage.app',
    measurementId: 'G-F107DFZ643',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwu1rs5Dvr_L0iMnv_6hdbBHWCvwokrxs',
    appId: '1:843006606880:android:873da22f6bdea565de0645',
    messagingSenderId: '843006606880',
    projectId: 'kickbasekumpel',
    storageBucket: 'kickbasekumpel.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwu1rs5Dvr_L0iMnv_6hdbBHWCvwokrxs',
    appId: '1:843006606880:ios:873da22f6bdea565de0645',
    messagingSenderId: '843006606880',
    projectId: 'kickbasekumpel',
    storageBucket: 'kickbasekumpel.firebasestorage.app',
  );
}
