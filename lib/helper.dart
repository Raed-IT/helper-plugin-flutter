library helper;

import 'package:flutter/material.dart';
import 'utilitis/constats.dart';
export 'package:helper_plugin/mixings/files/image_piker_mixing.dart';
export 'package:helper_plugin/mixings/api/pagination_mixing.dart';

class HelperMadaFlutter {
  static void initial({String? appName, Widget? drawerWidget}) {
    ConstantHelperMadaFlutter.instance;
    ConstantHelperMadaFlutter.appName = appName;
    ConstantHelperMadaFlutter.drawerWidget = drawerWidget;
  }
}
