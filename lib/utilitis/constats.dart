import 'package:flutter/widgets.dart';

class ConstantHelperMadaFlutter {
  ConstantHelperMadaFlutter._();

  static String? appName;
  static bool allowPrint = false;
  static String? token;
  static Widget? drawerWidget;

  static final ConstantHelperMadaFlutter instance =
      ConstantHelperMadaFlutter._();
}
