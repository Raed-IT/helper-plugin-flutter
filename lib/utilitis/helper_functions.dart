import 'dart:developer' as developer;

import 'package:helper_plugin/utilitis/constats.dart';

printHelper(String message) {
  if (ConstantHelperMadaFlutter.allowPrint) {
    developer.log('$message', name: "helper");
  }
}
