import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  DefaultFirebaseOptions(web);

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions web = const FirebaseOptions(
      apiKey: "AIzaSyC0wNBPbj7eDjjhQOg-EQxVrToGxpw_0jg",
      authDomain: "kaar-783a4.firebaseapp.com",
      projectId: "kaar-783a4",
      storageBucket: "kaar-783a4.firebasestorage.app",
      messagingSenderId: "962288805959",
      appId: "1:962288805959:web:0d64615a59db73c2012962",
      measurementId: "G-XPX0VZJEBN");

  static FirebaseOptions android = const FirebaseOptions(
    apiKey: "AIzaSyCIBD_ZKAJo3qgcxJZC7xzRHuLQLotKDdU",
    appId: "1:962288805959:android:69f4fe07bc0bcab3012962",
    messagingSenderId: "962288805959",
    projectId: "kaar-783a4",
  );
}
