import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helper_plugin/providers/api_provider.dart';
import 'package:helper_plugin/utilitis/constats.dart';
import 'package:helper_plugin/utilitis/error_type_enum.dart';
import 'package:helper_plugin/utilitis/internet_connection_checker.dart';
import 'package:helper_plugin/utilitis/url_model.dart';

import '../../utilitis/helper_functions.dart';

mixin ApiHelperMixin {
  bool isPostDio = false;
  RxBool isLoad = RxBool(false);
  bool isDelete = false;

  RxBool isPostGetConnect = RxBool(false);
  List<UrlModel> urlsGetRequest = [];
  ApiProvider apiProvider = ApiProvider();

  void onError(String type) {
    isLoad.value = false;
  }

  void getModelFromJsonUsing(dynamic json, String urlType) {}

  void getDataFromPostDioUsing(dynamic json) {}

  void onDeleteSuccess() {
    Fluttertoast.showToast(msg: "تم الحذف بنجاح");
  }

  Future<void> getData({isPrintResponse = false}) async {
    if (urlsGetRequest.isEmpty) {
      throw Exception("please add url to urlsGetRequest array");
    }
    isLoad.value = true;
    if (await checkInternet()) {
      for (var url in urlsGetRequest) {
        try {
          await apiProvider
              .getData(
            url:
                "${url.url}${url.parameter != null ? "?${url.parameter}" : ''}",
          )
              .then((response) {
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
                    type: url.type??'',
                    isPrintResponse: isPrintResponse);
              });
            } else {
              isLoad.value = false;
              onError("${url.type}");
            }
          });
        } catch (e) {
          Fluttertoast.showToast(
              msg: "$e", gravity: ConstantHelperMadaFlutter.toastPosition);
        }
      }
    } else {
      Fluttertoast.showToast(msg: "لايوجد اتصال بالانترنت ");
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
    if (await checkInternet()) {
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
                    printHelper(status);
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
            printHelper(response.headers);
            printHelper(response.data);
          }
          if (response.statusCode == ConstantHelperMadaFlutter.normalResponse) {
            print(response.statusCode);
            getDataFromPostDioUsing(response.data);
          } else if (response.statusCode ==
              ConstantHelperMadaFlutter.normalErrorResponse) {
            Fluttertoast.showToast(
                msg: response
                    .data[ConstantHelperMadaFlutter.normalErrorMessage]);
            onError(ErrorApiTypeEnum.postDio.name);
          } else {
            onError(ErrorApiTypeEnum.postDio.name);
          }
          isPostDio = false;
          return response;
        } on dio.DioError catch (e) {
          if (ConstantHelperMadaFlutter.allowPrintResponse) {
            printHelper(e.response);
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
    } else {
      Fluttertoast.showToast(msg: "لايوجد اتصال بالانترنت ");
    }
    return null;
  }

  Future<Response?> postGetConnect({
    required String url,
    required FormData data,
  }) async {
    if (await checkInternet()) {
      if (!isPostGetConnect.value) {
        isPostGetConnect.value = true;
        Response res = await apiProvider.postData(url: url, data: data);
        if (res.statusCode == ConstantHelperMadaFlutter.normalResponse) {
          getModelFromJsonUsing(res.body, "postGetConnect");
        } else if (res.statusCode ==
            ConstantHelperMadaFlutter.normalErrorResponse) {
          onError(ErrorApiTypeEnum.postGetConnect.name);
        } else if (res.statusCode == 500) {
          onError(ErrorApiTypeEnum.postGetConnect.name);
        } else if (res.statusCode == null) {
          Fluttertoast.showToast(msg: "خطاء في الاتصال ");
        }
        isPostGetConnect.value = false;
        return res;
      }
    } else {
      Fluttertoast.showToast(msg: "لايوجد اتصال بالانترنت ");
    }
    return null;
  }

  Future<bool> deleteGetConnect(
      {required String url,
      required int id,
      bool isPrintResponse = false}) async {
    if (await checkInternet()) {
      if (!isDelete) {
        isDelete = true;
        Response res = await apiProvider.deleteData(url: url, id: id);
        if (isPrintResponse) {
          printHelper("${res.body}");
        }
        if (res.statusCode == 200) {
          isDelete = false;
          onDeleteSuccess();
          return true;
        } else {
          isDelete = false;
          onError(ErrorApiTypeEnum.delete.name);
        }
      }
    } else {
      Fluttertoast.showToast(msg: "لايوجد اتصال بالانترنت ");
    }
    return false;
  }
}
