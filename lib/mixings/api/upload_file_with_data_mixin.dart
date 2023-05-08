import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';

mixin FilesDioProvider {
  bool isFileUploadWithData = false;

  Future<dio.Response?> uploadFilesWithData(
      {required String url,
      required dio.FormData data,
      String? token,
      required Function(int count) onSendProgress}) async {
    if (!isFileUploadWithData) {
      isFileUploadWithData = true;
      dio.Dio dioR = dio.Dio();
      dioR.options.headers["authorization"] = "Bearer $token";
      try {
        dio.Response response = await dioR.post(url,
            data: data,
            options: dio.Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }), onSendProgress: (rec, total) {
          onSendProgress(int.parse(((rec / total) * 100).toStringAsFixed(0)));
        });
        isFileUploadWithData = false;
        return response;
      } on dio.DioError catch (e) {
        isFileUploadWithData = false;
        Fluttertoast.showToast(msg: "فشل في الرفع");
        if (e.response?.statusCode == 404) {
          Fluttertoast.showToast(msg: "الطلب غير موجود ");
        } else if (e.response?.statusCode == 500) {
          Fluttertoast.showToast(msg: "خطاء السيرفر  ");
        } else {
          Fluttertoast.showToast(msg: "${e.message}");
        }
      }
    }
    return null;
  }
}
