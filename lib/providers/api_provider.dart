import 'package:get/get.dart';

import '../utilitis/base_get_connect.dart';

class ApiProvider extends BaseGetConnect {
  Future<Response> getData({required String url}) => get(url);

  Future<Response> postData({required String url, required FormData data}) =>
      post(url, data);
  Future<Response> deleteData({required String url, required int id }) =>
      delete("$url/$id");
}
