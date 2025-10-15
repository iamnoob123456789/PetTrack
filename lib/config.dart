import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class Config {
  static String get backendUrl {
    if (kIsWeb) {
      return 'http://localhost:5000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    } else if (Platform.isIOS) {
      return 'http://localhost:5000';
    } else {
      return 'http://localhost:5000';
    }
  }

  static const String cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/dslut5epx/image/upload';
  static const String cloudinaryUploadPreset = 'pettrack_preset';
}