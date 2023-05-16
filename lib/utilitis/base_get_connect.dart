import 'package:get/get.dart';
import 'package:helper_plugin/utilitis/helper_functions.dart';

import '../mixings/api/check_response.dart';
import 'constats.dart';

class BaseGetConnect extends GetConnect with CheckResponseMixin {
  BaseGetConnect() {
    httpClient.timeout = const Duration(seconds: 8);
    httpClient.addRequestModifier<dynamic>((request) {
      printHelper("${request.url}");
      request.headers['Authorization'] =
          "Bearer ${ConstantHelperMadaFlutter.token}";
      request.headers['Accept'] = "application/json";
      return request;
    });
    httpClient.addResponseModifier<dynamic>(
      (request, response) {
        if (ConstantHelperMadaFlutter.allowPrintResponse) {
          printHelper("Response status code =>   ${response.statusCode}");
          printHelper("Response body => ${response.body} ");
        }
        return checkResponse(response: response);
      },
    );
  }
}
