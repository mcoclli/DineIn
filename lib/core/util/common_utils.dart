import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

class CommonUtils {
  static void log(String message) {
    if (!kReleaseMode) {
      dev.log(message);
    }
  }
}
