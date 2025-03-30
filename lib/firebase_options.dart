import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'; // Add this import to check platforms

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDujAdf3OdeM7Tx39zTICIakGO811UWuAM',
    appId: '1:391574993641:android:76fce8878c5cd7d9e38e78',
    messagingSenderId: '391574993641',
    projectId: 'book-rental-platform',
    storageBucket: 'book-rental-platform.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDujAdf3OdeM7Tx39zTICIakGO811UWuAM',
    appId: '1:391574993641:ios:3e0df356f3520713e38e78',
    messagingSenderId: '391574993641',
    projectId: 'book-rental-platform',
    storageBucket: 'book-rental-platform.firebasestorage.app',
    iosBundleId: 'com.example.bookrentalapp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDujAdf3OdeM7Tx39zTICIakGO811UWuAM',
    appId: '1:391574993641:web:d3b5244c450f4856e38e78',
    messagingSenderId: '391574993641',
    projectId: 'book-rental-platform',
    storageBucket: 'book-rental-platform.firebasestorage.app',
  );
}
