import 'dart:developer' as developer;

import 'package:helper_plugin/utilitis/constats.dart';

printHelper(dynamic message) {
  if (ConstantHelperMadaFlutter.allowPrint) {
    developer.log(
      '$message',
      name: "helper",
    );
  }
}
