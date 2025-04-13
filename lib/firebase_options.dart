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
      apiKey: "AIzaSyAVBYas_7yQXRNpvhu6mer1XtIRxMO4ZM0",
      authDomain: "kaar-bc4eb.firebaseapp.com",
      projectId: "kaar-bc4eb",
      storageBucket: "kaar-bc4eb.firebasestorage.app",
      messagingSenderId: "561578805864",
      appId: "1:561578805864:web:2b78679f3db62044d7c9dd",
      measurementId: "G-N6WRSJ88BW");

  static FirebaseOptions android = const FirebaseOptions(
    apiKey: "AIzaSyBhSBywZuDeK2bjRmYFMIAeFfdgnBuyfVc",
    appId: "1:561578805864:android:13f769ba786b2d7dd7c9dd",
    messagingSenderId: "561578805864",
    projectId: "kaar-783a4",
  );
}
