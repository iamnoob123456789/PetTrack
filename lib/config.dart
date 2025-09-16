import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class Config {
  // ✅ Backend URL depending on platform
  static String get backendUrl {
    if (kIsWeb) {
      return 'http://localhost:5000'; // Web runs in browser
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000'; // Android Emulator
    } else if (Platform.isIOS) {
      return 'http://localhost:5000'; // iOS Simulator
    } else {
      return 'http://192.168.1.10:5000'; // LAN IP for physical devices
    }
  }

  // ✅ Cloudinary Configuration
  static const String cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/dslut5epx/image/upload';

  static const String cloudinaryUploadPreset = 'pettrack_preset';
}
