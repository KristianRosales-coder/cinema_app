import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions is not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnuE_30uTFMaZMI2Cw4Wtn4cd9DLe9q6U',
    appId: '1:913131295246:android:900b64ff0a29f65a97a25f',
    messagingSenderId: '913131295246',
    projectId: 'cinema-app-4e5b7',
    storageBucket: 'cinema-app-4e5b7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnuE_30uTFMaZMI2Cw4Wtn4cd9DLe9q6U',
    appId: '1:913131295246:ios:fabe5af68ddda26f97a25f',
    messagingSenderId: '913131295246',
    projectId: 'cinema-app-4e5b7',
    storageBucket: 'cinema-app-4e5b7.firebasestorage.app',
    iosBundleId: 'com.example.cinemaTicketing',
  );
}
