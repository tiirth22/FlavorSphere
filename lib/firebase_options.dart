// firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Replace with your actual Firebase configuration options
    // For Android and iOS, use the values from your Firebase project settings
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: "AIzaSyDb34TUTUBu7K_upjZk20zTlUwb3_I_0D8",
        authDomain: "your-web-auth-domain",
        projectId: "flavorsphere-897b3",
        storageBucket: "flavorsphere-897b3.appspot.com",
        messagingSenderId: "274732030102",
        appId: "1:274732030102:android:799f4a2271fc7427d1cab7",
        measurementId: "your-measurement-id",
      );
    }
    // For Android
    return FirebaseOptions(
      apiKey: "AIzaSyDb34TUTUBu7K_upjZk20zTlUwb3_I_0D8",
      appId: "1:274732030102:android:799f4a2271fc7427d1cab7",
      messagingSenderId: "274732030102",
      projectId: "flavorsphere-897b3",
      storageBucket: "flavorsphere-897b3.appspot.com",
    );
  }
}
// TODO Implement this library.

