import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    appId: '1:514456227871:android:8521eb81312cd854645a',
    apiKey: 'AIzaSyCY4T5w7yeZzvtD1_UUDqDvxoFjsichWFI',
    projectId: 'tenaye-app',
    messagingSenderId: '514456227871',
    storageBucket: 'tenaye-app.firebasestorage.app',
  );
  static FirebaseOptions get currentPlatform => android;
}

// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return web;
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.macOS:
//         throw UnsupportedError('DefaultFirebaseOptions have not been configured for macos');
//       case TargetPlatform.windows:
//         throw UnsupportedError('DefaultFirebaseOptions have not been configured for windows');
//       case TargetPlatform.linux:
//         throw UnsupportedError('DefaultFirebaseOptions have not been configured for linux');
//       default:
//         throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
//     }
//   }

//   static const FirebaseOptions web = FirebaseOptions(
//     apiKey: 'your-web-api-key',
//     appId: 'your-app-id',
//     messagingSenderId: 'your-messaging-sender-id',
//     projectId: 'your-project-id',
//     authDomain: 'your-auth-domain',
//     storageBucket: 'your-storage-bucket',
//   );

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'your-android-api-key',
//     appId: 'your-app-id',
//     messagingSenderId: 'your-messaging-sender-id',
//     projectId: 'your-project-id',
//     storageBucket: 'your-storage-bucket',
//   );

//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'your-ios-api-key',
//     appId: 'your-app-id',
//     messagingSenderId: 'your-messaging-sender-id',
//     projectId: 'your-project-id',
//     storageBucket: 'your-storage-bucket',
//     iosBundleId: 'your-ios-bundle-id',
//   );
// }