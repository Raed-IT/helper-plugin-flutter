import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/providers/api_provider.dart';
import 'package:helper_plugin/utilitis/constats.dart';
import 'package:helper_plugin/utilitis/url_model.dart';

import '../../utilitis/helper_functions.dart';

mixin ApiHelperMixin {
  bool isUpload = false;
  RxBool isLoad = RxBool(false);
  List<UrlModel> urlsGetRequest = [];
  ApiProvider apiProvider = ApiProvider();
  String? parameter;

  void getModelFromJsonUsing(Map<String, dynamic> json, String urlType);

  Future<void> getData(
      {isPrintResponse = false, bool isRefresh = false}) async {
    isLoad.value = true;
    for (var url in urlsGetRequest) {
      try {
        Response response = await apiProvider.getData(
            url: "${url.url}${parameter != null ? '?$parameter' : ''}");
        if (isPrintResponse) {
          printHelper("${response.body}");
        }
        if (response.statusCode == 200) {
          getModelFromJsonUsing(response.body, "${url.type}");
          isLoad.value = false;
        } else if (response.statusCode == null) {
          Future.delayed(const Duration(seconds: 3), () async {
            _reGetData(
                url: "${url.url}",
                isRefresh: isRefresh,
                type: url.type!,
                isPrintResponse: isPrintResponse);
          });
        }else{
          isLoad.value = false;
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "$e");
      }
    }
  }

  Future<void> _reGetData(
      {required String url,
      required String type,
      required bool isRefresh,
      required bool isPrintResponse,
      int? countTying}) async {
    try {
      Response response = await apiProvider.getData(
          url: "$url${parameter != null ? '?$parameter' : ''}");
      if (isPrintResponse) {
        printHelper(" retry get url ==> ${response.body}");
      }
      if (response.statusCode == 200) {
        getModelFromJsonUsing(response.body, type);
        isLoad.value = false;
      } else if (response.statusCode == null) {
        await Future.delayed(const Duration(seconds: 3), () async {
          if (countTying != null && countTying == 2) {
            Fluttertoast.showToast(msg: "الرجاء التاكد من الاتصال بالانترنت  ");
            isLoad.value = false;
          } else {
            _reGetData(
                url: url,
                isRefresh: isRefresh,
                type: type,
                isPrintResponse: isPrintResponse,
                countTying: countTying == null ? 1 : (countTying + 1));
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<dio.Response?> postDataDio(
      {required String url,
      required dio.FormData data,
      String? token,
      required Function(int count) onSendProgress}) async {
    if (!isUpload) {
      isUpload = true;
      dio.Dio dioR = dio.Dio();
      dioR.options.headers["authorization"] =
          "Bearer ${ConstantHelperMadaFlutter.token}";
      try {
        dio.Response response = await dioR.post(url,
            data: data,
            options: dio.Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }), onSendProgress: (rec, total) {
          onSendProgress(
            int.parse(
              ((rec / total) * 100).toStringAsFixed(0),
            ),
          );
        });
        isUpload = false;
        return response;
      } on dio.DioError catch (e) {
        isUpload = false;
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
