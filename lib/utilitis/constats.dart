import 'package:flutter/material.dart';
 import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
class ConstantHelperMadaFlutter {
  ConstantHelperMadaFlutter._();

  //for api main key EX:
  //{status: success, msg: لم تقم بحل الوظيبة بعد ...}
  static String normalApiKey = "status";
  static dynamic normalApiVal = "success"; // you can use bool int ....

  static String normalErrorMessage = "msg";

  static ToastGravity toastPosition = ToastGravity.TOP;
  static int normalResponse = 200;
  static int normalErrorResponse = 201;
  static String? appName;
  static String? loginPageRout;
  static bool allowPrint = false;
  static bool allowPrintResponse = false;
  static String? token;
  static RxBool isLogOut = RxBool(false);
  static Widget? drawerWidget;
  static Widget? endDrawerWidget;
  static Widget? noDataWidget;
  static Widget? loadMoreWidget;
  static double? toastFontSize ;
  static ScrollPhysics? scrollPhysics = BouncingScrollPhysics();
  static Color? scaffoldColor =Colors.white;
  static double ? loadMorAtHeight ;
  static Map<String, String> ? header ;


  static final ConstantHelperMadaFlutter instance =
      ConstantHelperMadaFlutter._();
}
