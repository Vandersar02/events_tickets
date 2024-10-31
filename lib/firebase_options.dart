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
    apiKey: 'AIzaSyC2gkvektP9AEGhY0f5deGA2GaeWBlK--M',
    appId: '1:930540187209:web:dbbaaadef6c55786489998',
    messagingSenderId: '930540187209',
    projectId: 'eventstickets-3ceba',
    authDomain: 'eventstickets-3ceba.firebaseapp.com',
    databaseURL: 'https://eventstickets-3ceba-default-rtdb.firebaseio.com',
    storageBucket: 'eventstickets-3ceba.appspot.com',
    measurementId: 'G-MYN1T5ZMP2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtDxhND9eu5SCF5_9KViaPrVx36scXADU',
    appId: '1:930540187209:android:b8b06197f19b3a36489998',
    messagingSenderId: '930540187209',
    projectId: 'eventstickets-3ceba',
    databaseURL: 'https://eventstickets-3ceba-default-rtdb.firebaseio.com',
    storageBucket: 'eventstickets-3ceba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdQFVO5Mlthn8tavHwUyTIZqtDzbaI1VY',
    appId: '1:930540187209:ios:f454663d66d85b52489998',
    messagingSenderId: '930540187209',
    projectId: 'eventstickets-3ceba',
    databaseURL: 'https://eventstickets-3ceba-default-rtdb.firebaseio.com',
    storageBucket: 'eventstickets-3ceba.appspot.com',
    iosClientId: '930540187209-cituhbkj7ldg0gpg7a9tlu96v77bgkn5.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventsTicket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCdQFVO5Mlthn8tavHwUyTIZqtDzbaI1VY',
    appId: '1:930540187209:ios:f454663d66d85b52489998',
    messagingSenderId: '930540187209',
    projectId: 'eventstickets-3ceba',
    databaseURL: 'https://eventstickets-3ceba-default-rtdb.firebaseio.com',
    storageBucket: 'eventstickets-3ceba.appspot.com',
    iosClientId: '930540187209-cituhbkj7ldg0gpg7a9tlu96v77bgkn5.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventsTicket',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2gkvektP9AEGhY0f5deGA2GaeWBlK--M',
    appId: '1:930540187209:web:95a34967f1ab2e42489998',
    messagingSenderId: '930540187209',
    projectId: 'eventstickets-3ceba',
    authDomain: 'eventstickets-3ceba.firebaseapp.com',
    databaseURL: 'https://eventstickets-3ceba-default-rtdb.firebaseio.com',
    storageBucket: 'eventstickets-3ceba.appspot.com',
    measurementId: 'G-15FG33N60V',
  );

}