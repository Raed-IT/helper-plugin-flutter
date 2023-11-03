import 'package:get/get.dart';
import 'package:helper_plugin/utilitis/helper_functions.dart';

import '../utilitis/base_get_connect.dart';

class ApiProvider extends BaseGetConnect {
  Future<Response> getData({required String url}) async {
    printHelper("get url pagination => $url");
    return await get(url);
  }

  Future<Response> postData({required String url, required FormData data}) =>
      post(url, data);

  Future<Response> deleteData({required String url, required int id}) =>
      delete("$url/$id");
}
