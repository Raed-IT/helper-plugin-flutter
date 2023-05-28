import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:helper_plugin/providers/api_provider.dart';
import 'package:helper_plugin/utilitis/constats.dart';
import 'package:helper_plugin/utilitis/url_model.dart';

import '../../utilitis/helper_functions.dart';

mixin ApiHelperMixin {
  bool isPostDio = false;
  RxBool isLoad = RxBool(false);
  RxBool isPostGetConnect = RxBool(false);
  List<UrlModel> urlsGetRequest = [];
  ApiProvider apiProvider = ApiProvider();

  void onError(String type) {
    isLoad.value = false;
  }

  void getModelFromJsonUsing(dynamic json, String urlType);

  void getDataFromPostDioUsing(dynamic json) {}

  Future<void> getData({isPrintResponse = false}) async {
    if (urlsGetRequest.isEmpty) {
      throw Exception("please add url to urlsGetRequest array");
    }
    isLoad.value = true;
    for (var url in urlsGetRequest) {
      try {
        Response response = await apiProvider.getData(
          url: "${url.url}${url.parameter != null ? "?${url.parameter}" : ''}",
        );
        if (isPrintResponse) {
          printHelper("${response.body}");
        }
        if (response.statusCode == 200) {
          getModelFromJsonUsing(response.body, "${url.type}");
          isLoad.value = false;
        } else if (response.statusCode == null) {
          Future.delayed(const Duration(seconds: 3), () async {
            _reGetData(
                url:
                "${url.url}${url.parameter != null ? "?${url.parameter}" : ''}",
                type: url.type!,
                isPrintResponse: isPrintResponse);
          });
        } else {
          isLoad.value = false;
          onError("${url.type}");
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "$e", gravity: ConstantHelperMadaFlutter.toastPosition);
      }
    }
  }

  Future<void> _reGetData(
      {required String url,
        required String type,
        required bool isPrintResponse,
        int? countTying}) async {
    try {
      Response response = await apiProvider.getData(url: url);
      if (isPrintResponse) {
        printHelper(" retry get url ==> $url");
      }
      if (response.statusCode == 200) {
        getModelFromJsonUsing(response.body, type);
        isLoad.value = false;
      } else if (response.statusCode == null) {
        await Future.delayed(const Duration(seconds: 3), () async {
          if (countTying != null && countTying == 2) {
            onError(type);
            Fluttertoast.showToast(
                msg: "الرجاء التاكد من الاتصال بالانترنت  ",
                gravity: ConstantHelperMadaFlutter.toastPosition);
            isLoad.value = false;
          } else {
            _reGetData(
                url: url,
                type: type,
                isPrintResponse: isPrintResponse,
                countTying: countTying == null ? 1 : (countTying + 1));
          }
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e", gravity: ConstantHelperMadaFlutter.toastPosition);
    }
  }

  Future<dio.Response?> postDataDio(
      {required String url,
        required dio.FormData data,
        Function(int count)? onSendProgress}) async {
    if (!isPostDio) {
      isPostDio = true;
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
              if (onSendProgress != null) {
                onSendProgress(
                  int.parse(
                    ((rec / total) * 100).toStringAsFixed(0),
                  ),
                );
              }
            });
        if (ConstantHelperMadaFlutter.allowPrintResponse) {
          printHelper(response.data);
        }
        getDataFromPostDioUsing(response.data);
        isPostDio = false;
        return response;
      } on dio.DioError catch (e) {
        if (ConstantHelperMadaFlutter.allowPrintResponse) {
          printHelper(e.response);
        }
        isPostDio = false;
        if (onSendProgress != null) {
          onSendProgress(0);
        }
        if (e.response?.statusCode == 404) {
          Fluttertoast.showToast(
              msg: "الطلب غير موجود ",
              gravity: ConstantHelperMadaFlutter.toastPosition);
        } else if (e.response?.statusCode == 500) {
          Fluttertoast.showToast(
              msg: "خطاء السيرفر  ",
              gravity: ConstantHelperMadaFlutter.toastPosition);
        } else {
          Fluttertoast.showToast(
              msg: "${e.message}",
              gravity: ConstantHelperMadaFlutter.toastPosition);
        }
      }
    }
    return null;
  }

  Future<Response> postGetConnect({
    required String url,
    required FormData data,
  }) async {
    isPostGetConnect.value = true;
    Response res = await apiProvider.postData(url: url, data: data);
    if (res.statusCode == ConstantHelperMadaFlutter.normalResponse) {
      getModelFromJsonUsing(res.body, "postGetConnect");
    } else if (res.statusCode ==
        ConstantHelperMadaFlutter.normalErrorResponse) {
      onError("postGetConnect");
    } else if (res.statusCode==500){
      onError("postGetConnect");
    } else if (res.statusCode == null) {
      Fluttertoast.showToast(msg: "خطاء في الاتصال ");
    }
    isPostGetConnect.value = false;
    return res;
  }
}
