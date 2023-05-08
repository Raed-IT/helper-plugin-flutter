library helper;


import 'utilitis/constats.dart';
import 'utilitis/helper_functions.dart';

export 'package:helper_plugin/mixings/files/image_piker_mixing.dart';
export 'package:helper_plugin/mixings/api/pagination_mixing.dart';

class HelperMadaFlutter {
  static void initial({String? appName}) {
    Constants.instance;
    Constants.appName = appName;
    printHelper("${Constants.appName}");
  }
}
