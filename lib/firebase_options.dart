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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions fail for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8wLzP_xjQYQ4xX3jfzCfDN29cvw5Eq-Y',
    appId: '1:1095879553110:android:1d31d56768d81ea1a2cbf7',
    messagingSenderId: '1095879553110',
    projectId: 'sunumarche-366c4',
    storageBucket: 'sunumarche-366c4.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD8wLzP_xjQYQ4xX3jfzCfDN29cvw5Eq-Y',
    appId: '1:1095879553110:web:abc123def456ghi789',
    messagingSenderId: '1095879553110',
    projectId: 'sunumarche-366c4',
    authDomain: 'sunumarche-366c4.firebaseapp.com',
    storageBucket: 'sunumarche-366c4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8wLzP_xjQYQ4xX3jfzCfDN29cvw5Eq-Y',
    appId: '1:1095879553110:ios:abc123def456ghi789',
    messagingSenderId: '1095879553110',
    projectId: 'sunumarche-366c4',
    storageBucket: 'sunumarche-366c4.firebasestorage.app',
    iosBundleId: 'com.example.sunumarche',
  );
}