library helper;


import 'utilitis/constats.dart';

export 'package:helper_plugin/mixings/files/image_piker_mixing.dart';
export 'package:helper_plugin/mixings/api/pagination_mixing.dart';

class HelperMadaFlutter {
  static void initial({String? appName}) {
    ConstantHelperMadaFlutter.instance;
    ConstantHelperMadaFlutter.appName = appName;
   }
}
