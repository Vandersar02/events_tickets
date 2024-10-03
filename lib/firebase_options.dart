import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAMywexTtjD3kpxY2ZThlWr3QKRK_ufRl4',
    appId: '1:438000097602:web:293b23e282dc8d8a0510db',
    messagingSenderId: '438000097602',
    projectId: 'eventtickets-377db',
    authDomain: 'eventtickets-377db.firebaseapp.com',
    storageBucket: 'eventtickets-377db.appspot.com',
    measurementId: 'G-HTWL0BW4GM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHHQ9iArVZzdncdvgtFTxO1BPijYCgQTE',
    appId: '1:438000097602:android:4b9bb3c7f5daa5320510db',
    messagingSenderId: '438000097602',
    projectId: 'eventtickets-377db',
    storageBucket: 'eventtickets-377db.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBlNZXqbd3TjnoOX8r5pqAVUf79KSrgQEk',
    appId: '1:438000097602:ios:9f6cec12fb0769a50510db',
    messagingSenderId: '438000097602',
    projectId: 'eventtickets-377db',
    storageBucket: 'eventtickets-377db.appspot.com',
    iosBundleId: 'com.example.eventsTicket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBlNZXqbd3TjnoOX8r5pqAVUf79KSrgQEk',
    appId: '1:438000097602:ios:9f6cec12fb0769a50510db',
    messagingSenderId: '438000097602',
    projectId: 'eventtickets-377db',
    storageBucket: 'eventtickets-377db.appspot.com',
    iosBundleId: 'com.example.eventsTicket',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAMywexTtjD3kpxY2ZThlWr3QKRK_ufRl4',
    appId: '1:438000097602:web:d80502ae5d39a4bf0510db',
    messagingSenderId: '438000097602',
    projectId: 'eventtickets-377db',
    authDomain: 'eventtickets-377db.firebaseapp.com',
    storageBucket: 'eventtickets-377db.appspot.com',
    measurementId: 'G-ZKCYQ13PNK',
  );
}
