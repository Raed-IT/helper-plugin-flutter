import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConstantHelperMadaFlutter {
  ConstantHelperMadaFlutter._();

  //for api main key EX:
  //{status: success, msg: لم تقم بحل الوظيبة بعد ...}
  static String normalApiKey = "status";
  static dynamic normalApiVal = "success"; // you can use bool int ....

  static String normalErrorMessage = "msg";

  static ToastGravity toastPosition = ToastGravity.TOP;
  static int normalResponse = 200;
  static String? appName;
  static String? loginPageRout;
  static bool allowPrint = false;
  static bool allowPrintResponse = false;
  static String? token;
  static Widget? drawerWidget;

  static final ConstantHelperMadaFlutter instance =
      ConstantHelperMadaFlutter._();
}
