import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/utilitis/constats.dart';
import 'package:helper_plugin/utilitis/helper_functions.dart';

mixin CheckResponseMixin {
  Response checkResponse({required Response response}) {
    try {
      if (response.body == null) {
        Fluttertoast.showToast(
            msg: "خطاء بااتصال",
            gravity: ConstantHelperMadaFlutter.toastPosition);
      }
      if (response.isOk) {
        if (response.body.containsKey(ConstantHelperMadaFlutter.normalApiKey)) {
          printHelper("containsKey ===>>> ${response.body['status']}");
          if (response.body[ConstantHelperMadaFlutter.normalApiKey] ==
              ConstantHelperMadaFlutter.normalApiVal) {
            return response;
          } else {
            if (response.body.containsKey(
                ConstantHelperMadaFlutter.normalErrorMessage)) {
              Fluttertoast.showToast(
                  msg:
                  response.body[ConstantHelperMadaFlutter.normalErrorMessage],
                  gravity: ConstantHelperMadaFlutter.toastPosition);
            }
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
          return response;
        }
      } else {
        // theirs error
        if (response.status.connectionError) {
          Fluttertoast.showToast(
              msg: "خطاء بااتصال",
              gravity: ConstantHelperMadaFlutter.toastPosition);
          return response;
        } else if (response.status.isForbidden) {
          Fluttertoast.showToast(
              msg: "محظور من الوصول ",
              gravity: ConstantHelperMadaFlutter.toastPosition);
          exitApp();
          return response;
        } else if (response.status.isNotFound) {
          Fluttertoast.showToast(
              msg: "لم يتم العثور على الطلب ",
              gravity: ConstantHelperMadaFlutter.toastPosition);
          return response;
        } else if (response.status.isServerError) {
          Fluttertoast.showToast(
              msg: "خطأ بالسيرفر الرجاء الاتصال بالدعم الفني  ",
              gravity: ConstantHelperMadaFlutter.toastPosition);
          return response;
        } else if (response.status.isUnauthorized) {
          Fluttertoast.showToast(
              msg: "الرجاء تسجيل الدخول  ",
              gravity: ConstantHelperMadaFlutter.toastPosition);
          exitApp();
          return response;
        } else {
          Fluttertoast.showToast(
              msg: "خطاء غير معروف ${response.statusCode}",
              gravity: ConstantHelperMadaFlutter.toastPosition);
          return response;
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "  error ==>  $e");
      return response;
    }
  }

  void exitApp() {
    ConstantHelperMadaFlutter.isLogOut.value = true;
  }
}
