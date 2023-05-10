import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helper_plugin/utilitis/constats.dart';

mixin CheckResponseMixin {
  Response checkResponse({required Response response}) {
    try {
      if (response.body == null) {
        Fluttertoast.showToast(msg: "خطاء بااتصال");
      }
      if (response.isOk) {
        if (response.body['status'] == "success") {
          return response;
        } else {
          Fluttertoast.showToast(msg: response.body['msg']);
          return Response(
              request: response.request,
              statusText: response.statusText,
              statusCode: 201,
              body: response.body,
              bodyBytes: response.bodyBytes,
              bodyString: response.bodyString,
              headers: response.headers);
        }
      } else {
        // theirs error
        if (response.status.connectionError) {
          Fluttertoast.showToast(msg: "خطاء بااتصال");
          return response;
        } else if (response.status.isForbidden) {
          Fluttertoast.showToast(msg: "محظور من الوصول ");
          exitApp();
          return response;
        } else if (response.status.isNotFound) {
          Fluttertoast.showToast(msg: "لم يتم العثور على الطلب ");
          return response;
        } else if (response.status.isServerError) {
          Fluttertoast.showToast(
              msg: "خطأ بالسيرفر الرجاء الاتصال بالدعم الفني  ");
          return response;
        } else if (response.status.isUnauthorized) {
          Fluttertoast.showToast(msg: "الرجاء تسجيل الدخول  ");
          exitApp();
          return response;
        } else {
          Fluttertoast.showToast(msg: "خطاء غير معروف   ");
          return response;
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      return response;
    }
  }

  void exitApp() {
    ConstantHelperMadaFlutter.token = null;
    GetStorage("${ConstantHelperMadaFlutter.appName}").remove("token");
    GetStorage("${ConstantHelperMadaFlutter.appName}").remove("user");
    Get.toNamed('/login');
  }
}
